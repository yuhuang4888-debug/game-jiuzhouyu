%%%---------------------------------------
%%% @Module  : data_afk
%%% @Description:  生成挂机掉落规则
%%%---------------------------------------
-module(data_afk).
-compile(export_all).
-include("afk.hrl").

 
get_value(1) ->
 	72000;
get_value(2) ->
 	200;
get_value(3) ->
 	37020001;
get_value(4) ->
 	5;
get_value(5) ->
 	2;
get_value(6) ->
 	3600;
get_value(7) ->
 	5000;
get_value(8) ->
 	55;
get_value(9) ->
 	[];
get_value(10) ->
 	20;
get_value(11) ->
 	1;
get_value(12) ->
 	36000;
get_value(13) ->
 	86400;
get_value(14) ->
 	43200;
get_value(15) ->
 	160;
get_value(_Key) ->
 	[].
 
get_afk(_lv) when _lv =< 1 ->
 	#base_afk{lv=1, base_power=31200,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 2 ->
 	#base_afk{lv=2, base_power=32400,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 3 ->
 	#base_afk{lv=3, base_power=33600,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 4 ->
 	#base_afk{lv=4, base_power=34800,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 5 ->
 	#base_afk{lv=5, base_power=36000,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 6 ->
 	#base_afk{lv=6, base_power=37200,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 7 ->
 	#base_afk{lv=7, base_power=38400,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 8 ->
 	#base_afk{lv=8, base_power=39600,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 9 ->
 	#base_afk{lv=9, base_power=40800,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 10 ->
 	#base_afk{lv=10, base_power=42000,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 11 ->
 	#base_afk{lv=11, base_power=43200,base_exp=9800,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 12 ->
 	#base_afk{lv=12, base_power=44400,base_exp=9760,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 13 ->
 	#base_afk{lv=13, base_power=45600,base_exp=9760,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 14 ->
 	#base_afk{lv=14, base_power=46800,base_exp=9760,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 15 ->
 	#base_afk{lv=15, base_power=48000,base_exp=9760,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 16 ->
 	#base_afk{lv=16, base_power=49200,base_exp=9730,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 17 ->
 	#base_afk{lv=17, base_power=50400,base_exp=9730,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 18 ->
 	#base_afk{lv=18, base_power=51600,base_exp=9660,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 19 ->
 	#base_afk{lv=19, base_power=52800,base_exp=9660,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 20 ->
 	#base_afk{lv=20, base_power=54000,base_exp=9660,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 21 ->
 	#base_afk{lv=21, base_power=55200,base_exp=122818,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 22 ->
 	#base_afk{lv=22, base_power=56400,base_exp=122828,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 23 ->
 	#base_afk{lv=23, base_power=57600,base_exp=122838,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 24 ->
 	#base_afk{lv=24, base_power=58800,base_exp=122848,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 25 ->
 	#base_afk{lv=25, base_power=60000,base_exp=122858,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 26 ->
 	#base_afk{lv=26, base_power=62000,base_exp=122808,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 27 ->
 	#base_afk{lv=27, base_power=64000,base_exp=122818,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 28 ->
 	#base_afk{lv=28, base_power=66000,base_exp=122748,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 29 ->
 	#base_afk{lv=29, base_power=68000,base_exp=122758,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 30 ->
 	#base_afk{lv=30, base_power=70000,base_exp=122768,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 31 ->
 	#base_afk{lv=31, base_power=72000,base_exp=122778,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 32 ->
 	#base_afk{lv=32, base_power=74000,base_exp=122788,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 33 ->
 	#base_afk{lv=33, base_power=76000,base_exp=122798,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 34 ->
 	#base_afk{lv=34, base_power=78000,base_exp=122808,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 35 ->
 	#base_afk{lv=35, base_power=80000,base_exp=122818,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 36 ->
 	#base_afk{lv=36, base_power=82000,base_exp=122828,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 37 ->
 	#base_afk{lv=37, base_power=84000,base_exp=122838,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 38 ->
 	#base_afk{lv=38, base_power=86000,base_exp=122848,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 39 ->
 	#base_afk{lv=39, base_power=88000,base_exp=122858,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 40 ->
 	#base_afk{lv=40, base_power=90000,base_exp=122808,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 41 ->
 	#base_afk{lv=41, base_power=92000,base_exp=122818,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 42 ->
 	#base_afk{lv=42, base_power=94000,base_exp=122828,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 43 ->
 	#base_afk{lv=43, base_power=96000,base_exp=122838,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 44 ->
 	#base_afk{lv=44, base_power=98000,base_exp=122848,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 45 ->
 	#base_afk{lv=45, base_power=100000,base_exp=84998,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 46 ->
 	#base_afk{lv=46, base_power=102000,base_exp=85008,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 47 ->
 	#base_afk{lv=47, base_power=104000,base_exp=85018,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 48 ->
 	#base_afk{lv=48, base_power=106000,base_exp=85028,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 49 ->
 	#base_afk{lv=49, base_power=108000,base_exp=85038,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 50 ->
 	#base_afk{lv=50, base_power=110000,base_exp=85048,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 51 ->
 	#base_afk{lv=51, base_power=112000,base_exp=85058,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 52 ->
 	#base_afk{lv=52, base_power=114000,base_exp=84868,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 53 ->
 	#base_afk{lv=53, base_power=116000,base_exp=84878,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 54 ->
 	#base_afk{lv=54, base_power=118000,base_exp=84888,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 55 ->
 	#base_afk{lv=55, base_power=120000,base_exp=84798,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 56 ->
 	#base_afk{lv=56, base_power=122000,base_exp=84808,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 57 ->
 	#base_afk{lv=57, base_power=124000,base_exp=84818,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 58 ->
 	#base_afk{lv=58, base_power=126000,base_exp=84828,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 59 ->
 	#base_afk{lv=59, base_power=128000,base_exp=84738,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 60 ->
 	#base_afk{lv=60, base_power=130000,base_exp=84748,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 61 ->
 	#base_afk{lv=61, base_power=132000,base_exp=84758,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 62 ->
 	#base_afk{lv=62, base_power=134000,base_exp=84768,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 63 ->
 	#base_afk{lv=63, base_power=136000,base_exp=84778,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 64 ->
 	#base_afk{lv=64, base_power=138000,base_exp=84788,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 65 ->
 	#base_afk{lv=65, base_power=140000,base_exp=84798,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 66 ->
 	#base_afk{lv=66, base_power=142000,base_exp=84808,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 67 ->
 	#base_afk{lv=67, base_power=144000,base_exp=84818,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 68 ->
 	#base_afk{lv=68, base_power=146000,base_exp=84828,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 69 ->
 	#base_afk{lv=69, base_power=148000,base_exp=84838,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 70 ->
 	#base_afk{lv=70, base_power=150000,base_exp=84848,base_coin=30, drop_list = [],drop_rule = []};
get_afk(_lv) when _lv =< 71 ->
 	#base_afk{lv=71, base_power=152000,base_exp=84758,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 72 ->
 	#base_afk{lv=72, base_power=154000,base_exp=84768,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 73 ->
 	#base_afk{lv=73, base_power=156000,base_exp=84678,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 74 ->
 	#base_afk{lv=74, base_power=158000,base_exp=84688,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 75 ->
 	#base_afk{lv=75, base_power=160000,base_exp=84698,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 76 ->
 	#base_afk{lv=76, base_power=162000,base_exp=84708,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 77 ->
 	#base_afk{lv=77, base_power=164000,base_exp=84518,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 78 ->
 	#base_afk{lv=78, base_power=166000,base_exp=84528,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 79 ->
 	#base_afk{lv=79, base_power=168000,base_exp=84538,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 80 ->
 	#base_afk{lv=80, base_power=170000,base_exp=84548,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 81 ->
 	#base_afk{lv=81, base_power=172000,base_exp=84558,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 82 ->
 	#base_afk{lv=82, base_power=174000,base_exp=84568,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 83 ->
 	#base_afk{lv=83, base_power=176000,base_exp=84578,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 84 ->
 	#base_afk{lv=84, base_power=178000,base_exp=84488,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 85 ->
 	#base_afk{lv=85, base_power=180000,base_exp=84498,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 86 ->
 	#base_afk{lv=86, base_power=182000,base_exp=84508,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 87 ->
 	#base_afk{lv=87, base_power=184000,base_exp=84518,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 88 ->
 	#base_afk{lv=88, base_power=186000,base_exp=84528,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 89 ->
 	#base_afk{lv=89, base_power=188000,base_exp=84538,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 90 ->
 	#base_afk{lv=90, base_power=190000,base_exp=84548,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 91 ->
 	#base_afk{lv=91, base_power=192000,base_exp=84558,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 92 ->
 	#base_afk{lv=92, base_power=194000,base_exp=84568,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 93 ->
 	#base_afk{lv=93, base_power=196000,base_exp=84578,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 94 ->
 	#base_afk{lv=94, base_power=198000,base_exp=84588,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 95 ->
 	#base_afk{lv=95, base_power=200000,base_exp=84598,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 96 ->
 	#base_afk{lv=96, base_power=202000,base_exp=84608,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 97 ->
 	#base_afk{lv=97, base_power=204000,base_exp=84618,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 98 ->
 	#base_afk{lv=98, base_power=206000,base_exp=84628,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 99 ->
 	#base_afk{lv=99, base_power=208000,base_exp=84638,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 100 ->
 	#base_afk{lv=100, base_power=210000,base_exp=84648,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 101 ->
 	#base_afk{lv=101, base_power=214000,base_exp=84658,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 102 ->
 	#base_afk{lv=102, base_power=218000,base_exp=84668,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 103 ->
 	#base_afk{lv=103, base_power=222000,base_exp=84678,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 104 ->
 	#base_afk{lv=104, base_power=226000,base_exp=84688,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 105 ->
 	#base_afk{lv=105, base_power=230000,base_exp=84698,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 106 ->
 	#base_afk{lv=106, base_power=234000,base_exp=84708,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 107 ->
 	#base_afk{lv=107, base_power=238000,base_exp=84718,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 108 ->
 	#base_afk{lv=108, base_power=242000,base_exp=84728,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 109 ->
 	#base_afk{lv=109, base_power=246000,base_exp=84638,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 110 ->
 	#base_afk{lv=110, base_power=250000,base_exp=84648,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 111 ->
 	#base_afk{lv=111, base_power=254000,base_exp=84658,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 112 ->
 	#base_afk{lv=112, base_power=258000,base_exp=84668,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 113 ->
 	#base_afk{lv=113, base_power=262000,base_exp=84678,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 114 ->
 	#base_afk{lv=114, base_power=266000,base_exp=84588,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 115 ->
 	#base_afk{lv=115, base_power=270000,base_exp=84598,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 116 ->
 	#base_afk{lv=116, base_power=274000,base_exp=84608,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 117 ->
 	#base_afk{lv=117, base_power=278000,base_exp=84618,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 118 ->
 	#base_afk{lv=118, base_power=282000,base_exp=84528,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 119 ->
 	#base_afk{lv=119, base_power=286000,base_exp=84538,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 120 ->
 	#base_afk{lv=120, base_power=290000,base_exp=84448,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 121 ->
 	#base_afk{lv=121, base_power=294000,base_exp=84358,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 122 ->
 	#base_afk{lv=122, base_power=298000,base_exp=84368,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 123 ->
 	#base_afk{lv=123, base_power=302000,base_exp=85198,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 124 ->
 	#base_afk{lv=124, base_power=306000,base_exp=86027,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 125 ->
 	#base_afk{lv=125, base_power=310000,base_exp=86857,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 126 ->
 	#base_afk{lv=126, base_power=314000,base_exp=86719,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 127 ->
 	#base_afk{lv=127, base_power=318000,base_exp=87549,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 128 ->
 	#base_afk{lv=128, base_power=322000,base_exp=88378,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 129 ->
 	#base_afk{lv=129, base_power=326000,base_exp=89208,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 130 ->
 	#base_afk{lv=130, base_power=330000,base_exp=90038,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 131 ->
 	#base_afk{lv=131, base_power=336000,base_exp=90867,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 132 ->
 	#base_afk{lv=132, base_power=342000,base_exp=91697,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 133 ->
 	#base_afk{lv=133, base_power=348000,base_exp=91453,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 134 ->
 	#base_afk{lv=134, base_power=354000,base_exp=92283,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 135 ->
 	#base_afk{lv=135, base_power=360000,base_exp=92490,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 136 ->
 	#base_afk{lv=136, base_power=366000,base_exp=93320,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 137 ->
 	#base_afk{lv=137, base_power=372000,base_exp=94150,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 138 ->
 	#base_afk{lv=138, base_power=378000,base_exp=94980,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 139 ->
 	#base_afk{lv=139, base_power=384000,base_exp=95809,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 140 ->
 	#base_afk{lv=140, base_power=390000,base_exp=96639,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 141 ->
 	#base_afk{lv=141, base_power=392000,base_exp=97469,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 142 ->
 	#base_afk{lv=142, base_power=394000,base_exp=98298,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 143 ->
 	#base_afk{lv=143, base_power=396000,base_exp=99128,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 144 ->
 	#base_afk{lv=144, base_power=398000,base_exp=99958,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 145 ->
 	#base_afk{lv=145, base_power=400000,base_exp=100788,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 146 ->
 	#base_afk{lv=146, base_power=408000,base_exp=101617,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 147 ->
 	#base_afk{lv=147, base_power=416000,base_exp=81954,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 148 ->
 	#base_afk{lv=148, base_power=424000,base_exp=82784,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 149 ->
 	#base_afk{lv=149, base_power=432000,base_exp=82577,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 150 ->
 	#base_afk{lv=150, base_power=440000,base_exp=83407,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 151 ->
 	#base_afk{lv=151, base_power=448000,base_exp=83865,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 152 ->
 	#base_afk{lv=152, base_power=456000,base_exp=82192,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 153 ->
 	#base_afk{lv=153, base_power=464000,base_exp=82087,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 154 ->
 	#base_afk{lv=154, base_power=472000,base_exp=82917,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 155 ->
 	#base_afk{lv=155, base_power=480000,base_exp=83747,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 156 ->
 	#base_afk{lv=156, base_power=488000,base_exp=83084,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 157 ->
 	#base_afk{lv=157, base_power=496000,base_exp=83394,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 158 ->
 	#base_afk{lv=158, base_power=504000,base_exp=84224,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 159 ->
 	#base_afk{lv=159, base_power=512000,base_exp=85054,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 160 ->
 	#base_afk{lv=160, base_power=520000,base_exp=85883,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 161 ->
 	#base_afk{lv=161, base_power=528000,base_exp=86713,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 162 ->
 	#base_afk{lv=162, base_power=536000,base_exp=87543,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 163 ->
 	#base_afk{lv=163, base_power=544000,base_exp=87841,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 164 ->
 	#base_afk{lv=164, base_power=552000,base_exp=88670,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 165 ->
 	#base_afk{lv=165, base_power=560000,base_exp=88402,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 166 ->
 	#base_afk{lv=166, base_power=568000,base_exp=88667,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 167 ->
 	#base_afk{lv=167, base_power=576000,base_exp=88920,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 168 ->
 	#base_afk{lv=168, base_power=584000,base_exp=89750,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 169 ->
 	#base_afk{lv=169, base_power=592000,base_exp=90580,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 170 ->
 	#base_afk{lv=170, base_power=600000,base_exp=90823,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 171 ->
 	#base_afk{lv=171, base_power=608000,base_exp=91652,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 172 ->
 	#base_afk{lv=172, base_power=616000,base_exp=92482,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 173 ->
 	#base_afk{lv=173, base_power=624000,base_exp=93312,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 174 ->
 	#base_afk{lv=174, base_power=632000,base_exp=94141,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 175 ->
 	#base_afk{lv=175, base_power=640000,base_exp=94971,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 176 ->
 	#base_afk{lv=176, base_power=648000,base_exp=95801,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 177 ->
 	#base_afk{lv=177, base_power=656000,base_exp=95425,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 178 ->
 	#base_afk{lv=178, base_power=664000,base_exp=94370,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 179 ->
 	#base_afk{lv=179, base_power=672000,base_exp=95200,base_coin=30, drop_list = [9999,10000,2147,2148,2149,2150,2151,6256,6257,10821,10822,10847,10848,10873,10874],drop_rule = [{[{340010202,1}],120},{[{56000101,1}],83},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 180 ->
 	#base_afk{lv=180, base_power=680000,base_exp=96030,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 181 ->
 	#base_afk{lv=181, base_power=688000,base_exp=91409,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 182 ->
 	#base_afk{lv=182, base_power=696000,base_exp=92239,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 183 ->
 	#base_afk{lv=183, base_power=704000,base_exp=90878,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 184 ->
 	#base_afk{lv=184, base_power=712000,base_exp=91708,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 185 ->
 	#base_afk{lv=185, base_power=720000,base_exp=92537,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 186 ->
 	#base_afk{lv=186, base_power=729000,base_exp=91102,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 187 ->
 	#base_afk{lv=187, base_power=738000,base_exp=91161,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 188 ->
 	#base_afk{lv=188, base_power=747000,base_exp=91212,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 189 ->
 	#base_afk{lv=189, base_power=756000,base_exp=92041,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 190 ->
 	#base_afk{lv=190, base_power=765000,base_exp=92085,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 191 ->
 	#base_afk{lv=191, base_power=782000,base_exp=92121,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 192 ->
 	#base_afk{lv=192, base_power=799000,base_exp=92950,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 193 ->
 	#base_afk{lv=193, base_power=816000,base_exp=93780,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 194 ->
 	#base_afk{lv=194, base_power=833000,base_exp=90536,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 195 ->
 	#base_afk{lv=195, base_power=850000,base_exp=86263,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 196 ->
 	#base_afk{lv=196, base_power=867000,base_exp=84461,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 197 ->
 	#base_afk{lv=197, base_power=884000,base_exp=85291,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 198 ->
 	#base_afk{lv=198, base_power=901000,base_exp=86408,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 199 ->
 	#base_afk{lv=199, base_power=918000,base_exp=86637,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 200 ->
 	#base_afk{lv=200, base_power=935000,base_exp=86861,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 201 ->
 	#base_afk{lv=201, base_power=952000,base_exp=87081,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 202 ->
 	#base_afk{lv=202, base_power=969000,base_exp=88197,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 203 ->
 	#base_afk{lv=203, base_power=986000,base_exp=86593,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 204 ->
 	#base_afk{lv=204, base_power=1003000,base_exp=80272,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 205 ->
 	#base_afk{lv=205, base_power=1020000,base_exp=78543,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 206 ->
 	#base_afk{lv=206, base_power=1037000,base_exp=73895,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 207 ->
 	#base_afk{lv=207, base_power=1054000,base_exp=71128,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 208 ->
 	#base_afk{lv=208, base_power=1071000,base_exp=70295,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 209 ->
 	#base_afk{lv=209, base_power=1088000,base_exp=71412,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 210 ->
 	#base_afk{lv=210, base_power=1105000,base_exp=72528,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 211 ->
 	#base_afk{lv=211, base_power=1108000,base_exp=73645,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 212 ->
 	#base_afk{lv=212, base_power=1111000,base_exp=74762,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 213 ->
 	#base_afk{lv=213, base_power=1114000,base_exp=75878,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 214 ->
 	#base_afk{lv=214, base_power=1117000,base_exp=76995,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 215 ->
 	#base_afk{lv=215, base_power=1120000,base_exp=78112,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 216 ->
 	#base_afk{lv=216, base_power=1146000,base_exp=79228,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 217 ->
 	#base_afk{lv=217, base_power=1172000,base_exp=80345,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 218 ->
 	#base_afk{lv=218, base_power=1198000,base_exp=81461,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 219 ->
 	#base_afk{lv=219, base_power=1224000,base_exp=82578,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6262,6263,10823,10824,10849,10850,10875,10876],drop_rule = [{[{340010502,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 220 ->
 	#base_afk{lv=220, base_power=1250000,base_exp=83695,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 221 ->
 	#base_afk{lv=221, base_power=1276000,base_exp=83834,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 222 ->
 	#base_afk{lv=222, base_power=1302000,base_exp=83973,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 223 ->
 	#base_afk{lv=223, base_power=1328000,base_exp=84749,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 224 ->
 	#base_afk{lv=224, base_power=1354000,base_exp=84547,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 225 ->
 	#base_afk{lv=225, base_power=1380000,base_exp=83365,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 226 ->
 	#base_afk{lv=226, base_power=1402000,base_exp=84142,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 227 ->
 	#base_afk{lv=227, base_power=1424000,base_exp=84918,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 228 ->
 	#base_afk{lv=228, base_power=1446000,base_exp=85694,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 229 ->
 	#base_afk{lv=229, base_power=1468000,base_exp=86471,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 230 ->
 	#base_afk{lv=230, base_power=1490000,base_exp=87247,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 231 ->
 	#base_afk{lv=231, base_power=1522000,base_exp=86063,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 232 ->
 	#base_afk{lv=232, base_power=1554000,base_exp=86839,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 233 ->
 	#base_afk{lv=233, base_power=1586000,base_exp=87615,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 234 ->
 	#base_afk{lv=234, base_power=1618000,base_exp=87412,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 235 ->
 	#base_afk{lv=235, base_power=1650000,base_exp=85248,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 236 ->
 	#base_afk{lv=236, base_power=1690000,base_exp=86025,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 237 ->
 	#base_afk{lv=237, base_power=1730000,base_exp=84844,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 238 ->
 	#base_afk{lv=238, base_power=1770000,base_exp=85620,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 239 ->
 	#base_afk{lv=239, base_power=1810000,base_exp=86397,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 240 ->
 	#base_afk{lv=240, base_power=1850000,base_exp=87173,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 241 ->
 	#base_afk{lv=241, base_power=1924000,base_exp=87950,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 242 ->
 	#base_afk{lv=242, base_power=1998000,base_exp=87748,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 243 ->
 	#base_afk{lv=243, base_power=2072000,base_exp=88524,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 244 ->
 	#base_afk{lv=244, base_power=2146000,base_exp=89301,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 245 ->
 	#base_afk{lv=245, base_power=2220000,base_exp=90077,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 246 ->
 	#base_afk{lv=246, base_power=2294000,base_exp=90854,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 247 ->
 	#base_afk{lv=247, base_power=2368000,base_exp=91630,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 248 ->
 	#base_afk{lv=248, base_power=2442000,base_exp=94814,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 249 ->
 	#base_afk{lv=249, base_power=2516000,base_exp=97998,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],6},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 250 ->
 	#base_afk{lv=250, base_power=2590000,base_exp=101182,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 251 ->
 	#base_afk{lv=251, base_power=2622000,base_exp=104366,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 252 ->
 	#base_afk{lv=252, base_power=2654000,base_exp=107550,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 253 ->
 	#base_afk{lv=253, base_power=2686000,base_exp=110734,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 254 ->
 	#base_afk{lv=254, base_power=2718000,base_exp=113918,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 255 ->
 	#base_afk{lv=255, base_power=2750000,base_exp=117102,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 256 ->
 	#base_afk{lv=256, base_power=2792000,base_exp=120286,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 257 ->
 	#base_afk{lv=257, base_power=2834000,base_exp=123470,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 258 ->
 	#base_afk{lv=258, base_power=2876000,base_exp=126654,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 259 ->
 	#base_afk{lv=259, base_power=2918000,base_exp=129838,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 260 ->
 	#base_afk{lv=260, base_power=2960000,base_exp=133022,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 261 ->
 	#base_afk{lv=261, base_power=3034000,base_exp=136206,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 262 ->
 	#base_afk{lv=262, base_power=3108000,base_exp=137438,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 263 ->
 	#base_afk{lv=263, base_power=3182000,base_exp=140622,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 264 ->
 	#base_afk{lv=264, base_power=3256000,base_exp=142831,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 265 ->
 	#base_afk{lv=265, base_power=3330000,base_exp=141167,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 266 ->
 	#base_afk{lv=266, base_power=3406000,base_exp=144351,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 267 ->
 	#base_afk{lv=267, base_power=3482000,base_exp=147535,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 268 ->
 	#base_afk{lv=268, base_power=3558000,base_exp=150719,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 269 ->
 	#base_afk{lv=269, base_power=3634000,base_exp=153903,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6268,6269,10825,10826,10851,10852,10877,10878],drop_rule = [{[{340020302,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 270 ->
 	#base_afk{lv=270, base_power=3710000,base_exp=153245,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 271 ->
 	#base_afk{lv=271, base_power=3862000,base_exp=153576,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 272 ->
 	#base_afk{lv=272, base_power=4014000,base_exp=154873,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 273 ->
 	#base_afk{lv=273, base_power=4166000,base_exp=155559,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 274 ->
 	#base_afk{lv=274, base_power=4318000,base_exp=158123,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 275 ->
 	#base_afk{lv=275, base_power=4470000,base_exp=149112,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 276 ->
 	#base_afk{lv=276, base_power=4622000,base_exp=152604,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 277 ->
 	#base_afk{lv=277, base_power=4774000,base_exp=155242,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 278 ->
 	#base_afk{lv=278, base_power=4926000,base_exp=158734,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 279 ->
 	#base_afk{lv=279, base_power=5078000,base_exp=161378,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 280 ->
 	#base_afk{lv=280, base_power=5230000,base_exp=164870,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 281 ->
 	#base_afk{lv=281, base_power=5384000,base_exp=166687,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 282 ->
 	#base_afk{lv=282, base_power=5538000,base_exp=169351,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 283 ->
 	#base_afk{lv=283, base_power=5692000,base_exp=172843,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 284 ->
 	#base_afk{lv=284, base_power=5846000,base_exp=171515,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 285 ->
 	#base_afk{lv=285, base_power=6000000,base_exp=172698,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 286 ->
 	#base_afk{lv=286, base_power=6156000,base_exp=171791,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 287 ->
 	#base_afk{lv=287, base_power=6312000,base_exp=161195,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 288 ->
 	#base_afk{lv=288, base_power=6468000,base_exp=164686,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 289 ->
 	#base_afk{lv=289, base_power=6624000,base_exp=168177,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 290 ->
 	#base_afk{lv=290, base_power=6780000,base_exp=171222,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 291 ->
 	#base_afk{lv=291, base_power=6936000,base_exp=173857,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 292 ->
 	#base_afk{lv=292, base_power=7092000,base_exp=175791,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 293 ->
 	#base_afk{lv=293, base_power=7248000,base_exp=178583,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 294 ->
 	#base_afk{lv=294, base_power=7404000,base_exp=181746,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 295 ->
 	#base_afk{lv=295, base_power=7560000,base_exp=185237,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 296 ->
 	#base_afk{lv=296, base_power=7720000,base_exp=185891,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 297 ->
 	#base_afk{lv=297, base_power=7880000,base_exp=189537,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 298 ->
 	#base_afk{lv=298, base_power=8040000,base_exp=192146,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 299 ->
 	#base_afk{lv=299, base_power=8200000,base_exp=195173,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 300 ->
 	#base_afk{lv=300, base_power=8360000,base_exp=198201,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 301 ->
 	#base_afk{lv=301, base_power=8520000,base_exp=201120,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 302 ->
 	#base_afk{lv=302, base_power=8680000,base_exp=204147,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 303 ->
 	#base_afk{lv=303, base_power=8840000,base_exp=207174,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 304 ->
 	#base_afk{lv=304, base_power=9000000,base_exp=210202,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 305 ->
 	#base_afk{lv=305, base_power=9160000,base_exp=207784,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 306 ->
 	#base_afk{lv=306, base_power=9322000,base_exp=215986,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 307 ->
 	#base_afk{lv=307, base_power=9484000,base_exp=213838,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 308 ->
 	#base_afk{lv=308, base_power=9646000,base_exp=216866,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 309 ->
 	#base_afk{lv=309, base_power=9808000,base_exp=219793,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 310 ->
 	#base_afk{lv=310, base_power=9970000,base_exp=222620,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 311 ->
 	#base_afk{lv=311, base_power=10132000,base_exp=225647,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 312 ->
 	#base_afk{lv=312, base_power=10294000,base_exp=228675,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 313 ->
 	#base_afk{lv=313, base_power=10456000,base_exp=231652,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 314 ->
 	#base_afk{lv=314, base_power=10618000,base_exp=234679,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 315 ->
 	#base_afk{lv=315, base_power=10780000,base_exp=237106,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 316 ->
 	#base_afk{lv=316, base_power=10946000,base_exp=240134,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 317 ->
 	#base_afk{lv=317, base_power=11112000,base_exp=243161,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 318 ->
 	#base_afk{lv=318, base_power=11278000,base_exp=246188,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 319 ->
 	#base_afk{lv=319, base_power=11444000,base_exp=249215,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6274,6275,10827,10828,10853,10854,10879,10880],drop_rule = [{[{340030102,1}],120},{[{56000101,1}],83},{[{9999999,1}],7},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 320 ->
 	#base_afk{lv=320, base_power=11610000,base_exp=252243,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 321 ->
 	#base_afk{lv=321, base_power=11776000,base_exp=255170,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 322 ->
 	#base_afk{lv=322, base_power=11942000,base_exp=257897,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 323 ->
 	#base_afk{lv=323, base_power=12108000,base_exp=261128,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 324 ->
 	#base_afk{lv=324, base_power=12274000,base_exp=264458,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 325 ->
 	#base_afk{lv=325, base_power=12440000,base_exp=267989,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 326 ->
 	#base_afk{lv=326, base_power=12610000,base_exp=271370,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 327 ->
 	#base_afk{lv=327, base_power=12780000,base_exp=274800,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 328 ->
 	#base_afk{lv=328, base_power=12950000,base_exp=277781,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 329 ->
 	#base_afk{lv=329, base_power=13120000,base_exp=281262,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 330 ->
 	#base_afk{lv=330, base_power=13290000,base_exp=284492,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 331 ->
 	#base_afk{lv=331, base_power=13546000,base_exp=288123,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 332 ->
 	#base_afk{lv=332, base_power=13802000,base_exp=291654,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 333 ->
 	#base_afk{lv=333, base_power=14058000,base_exp=295034,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 334 ->
 	#base_afk{lv=334, base_power=14314000,base_exp=298665,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 335 ->
 	#base_afk{lv=335, base_power=14570000,base_exp=301846,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 336 ->
 	#base_afk{lv=336, base_power=14656000,base_exp=305227,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 337 ->
 	#base_afk{lv=337, base_power=14742000,base_exp=308807,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 338 ->
 	#base_afk{lv=338, base_power=14828000,base_exp=312438,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 339 ->
 	#base_afk{lv=339, base_power=14914000,base_exp=315469,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 340 ->
 	#base_afk{lv=340, base_power=15000000,base_exp=318749,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 341 ->
 	#base_afk{lv=341, base_power=15260000,base_exp=322230,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 342 ->
 	#base_afk{lv=342, base_power=15520000,base_exp=325861,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 343 ->
 	#base_afk{lv=343, base_power=15780000,base_exp=329141,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 344 ->
 	#base_afk{lv=344, base_power=16040000,base_exp=332622,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 345 ->
 	#base_afk{lv=345, base_power=16300000,base_exp=336153,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 346 ->
 	#base_afk{lv=346, base_power=16476000,base_exp=339783,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 347 ->
 	#base_afk{lv=347, base_power=16652000,base_exp=342714,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 348 ->
 	#base_afk{lv=348, base_power=16828000,base_exp=346919,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 349 ->
 	#base_afk{lv=349, base_power=17004000,base_exp=351274,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 350 ->
 	#base_afk{lv=350, base_power=17180000,base_exp=355629,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 351 ->
 	#base_afk{lv=351, base_power=17358000,base_exp=359783,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 352 ->
 	#base_afk{lv=352, base_power=17536000,base_exp=364088,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 353 ->
 	#base_afk{lv=353, base_power=17714000,base_exp=368143,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 354 ->
 	#base_afk{lv=354, base_power=17892000,base_exp=372498,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 355 ->
 	#base_afk{lv=355, base_power=18070000,base_exp=376403,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 356 ->
 	#base_afk{lv=356, base_power=18250000,base_exp=380708,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 357 ->
 	#base_afk{lv=357, base_power=18430000,base_exp=384862,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 358 ->
 	#base_afk{lv=358, base_power=18610000,base_exp=389217,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 359 ->
 	#base_afk{lv=359, base_power=18790000,base_exp=393072,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 360 ->
 	#base_afk{lv=360, base_power=18970000,base_exp=397377,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 361 ->
 	#base_afk{lv=361, base_power=19152000,base_exp=401532,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 362 ->
 	#base_afk{lv=362, base_power=19334000,base_exp=405887,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 363 ->
 	#base_afk{lv=363, base_power=19516000,base_exp=409991,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 364 ->
 	#base_afk{lv=364, base_power=19698000,base_exp=414146,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 365 ->
 	#base_afk{lv=365, base_power=19880000,base_exp=418501,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 366 ->
 	#base_afk{lv=366, base_power=20064000,base_exp=422056,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 367 ->
 	#base_afk{lv=367, base_power=20248000,base_exp=426261,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 368 ->
 	#base_afk{lv=368, base_power=20432000,base_exp=430766,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 369 ->
 	#base_afk{lv=369, base_power=20616000,base_exp=435120,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6280,6281,10829,10830,10855,10856,10881,10882],drop_rule = [{[{340030402,1}],120},{[{56000101,1}],83},{[{9999999,1}],8},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 370 ->
 	#base_afk{lv=370, base_power=20800000,base_exp=439475,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 371 ->
 	#base_afk{lv=371, base_power=21172000,base_exp=443180,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 372 ->
 	#base_afk{lv=372, base_power=21544000,base_exp=446835,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 373 ->
 	#base_afk{lv=373, base_power=21916000,base_exp=451959,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 374 ->
 	#base_afk{lv=374, base_power=22288000,base_exp=457183,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 375 ->
 	#base_afk{lv=375, base_power=22660000,base_exp=462206,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 376 ->
 	#base_afk{lv=376, base_power=22944000,base_exp=467230,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 377 ->
 	#base_afk{lv=377, base_power=23228000,base_exp=471504,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 378 ->
 	#base_afk{lv=378, base_power=23512000,base_exp=476528,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 379 ->
 	#base_afk{lv=379, base_power=23796000,base_exp=481702,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 380 ->
 	#base_afk{lv=380, base_power=24080000,base_exp=486575,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 381 ->
 	#base_afk{lv=381, base_power=24368000,base_exp=491749,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 382 ->
 	#base_afk{lv=382, base_power=24656000,base_exp=496973,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 383 ->
 	#base_afk{lv=383, base_power=24944000,base_exp=501747,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 384 ->
 	#base_afk{lv=384, base_power=25232000,base_exp=506871,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 385 ->
 	#base_afk{lv=385, base_power=25520000,base_exp=511544,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 386 ->
 	#base_afk{lv=386, base_power=25814000,base_exp=516618,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 387 ->
 	#base_afk{lv=387, base_power=26108000,base_exp=521492,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 388 ->
 	#base_afk{lv=388, base_power=26402000,base_exp=526716,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 389 ->
 	#base_afk{lv=389, base_power=26696000,base_exp=531790,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 390 ->
 	#base_afk{lv=390, base_power=26990000,base_exp=536113,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 391 ->
 	#base_afk{lv=391, base_power=27286000,base_exp=541337,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 392 ->
 	#base_afk{lv=392, base_power=27582000,base_exp=546061,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 393 ->
 	#base_afk{lv=393, base_power=27878000,base_exp=550085,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 394 ->
 	#base_afk{lv=394, base_power=28174000,base_exp=555309,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 395 ->
 	#base_afk{lv=395, base_power=28470000,base_exp=559632,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 396 ->
 	#base_afk{lv=396, base_power=28874000,base_exp=564706,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 397 ->
 	#base_afk{lv=397, base_power=29278000,base_exp=569930,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 398 ->
 	#base_afk{lv=398, base_power=29682000,base_exp=575997,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 399 ->
 	#base_afk{lv=399, base_power=30086000,base_exp=582063,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 400 ->
 	#base_afk{lv=400, base_power=30490000,base_exp=588330,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 401 ->
 	#base_afk{lv=401, base_power=30798000,base_exp=594446,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 402 ->
 	#base_afk{lv=402, base_power=31106000,base_exp=599563,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 403 ->
 	#base_afk{lv=403, base_power=31414000,base_exp=605429,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 404 ->
 	#base_afk{lv=404, base_power=31722000,base_exp=611696,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 405 ->
 	#base_afk{lv=405, base_power=32030000,base_exp=617612,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 406 ->
 	#base_afk{lv=406, base_power=32342000,base_exp=623879,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 407 ->
 	#base_afk{lv=407, base_power=32654000,base_exp=629996,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 408 ->
 	#base_afk{lv=408, base_power=32966000,base_exp=636262,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 409 ->
 	#base_afk{lv=409, base_power=33278000,base_exp=642129,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 410 ->
 	#base_afk{lv=410, base_power=33590000,base_exp=648395,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 411 ->
 	#base_afk{lv=411, base_power=33908000,base_exp=654462,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 412 ->
 	#base_afk{lv=412, base_power=34226000,base_exp=660278,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 413 ->
 	#base_afk{lv=413, base_power=34544000,base_exp=666495,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 414 ->
 	#base_afk{lv=414, base_power=34862000,base_exp=672562,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 415 ->
 	#base_afk{lv=415, base_power=35180000,base_exp=678778,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 416 ->
 	#base_afk{lv=416, base_power=35502000,base_exp=684945,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 417 ->
 	#base_afk{lv=417, base_power=35824000,base_exp=690961,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 418 ->
 	#base_afk{lv=418, base_power=36146000,base_exp=696928,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 419 ->
 	#base_afk{lv=419, base_power=36468000,base_exp=702944,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6286,6287,10831,10832,10857,10858,10883,10884],drop_rule = [{[{340040102,1}],120},{[{56000101,1}],83},{[{9999999,1}],9},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 420 ->
 	#base_afk{lv=420, base_power=36790000,base_exp=709161,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 421 ->
 	#base_afk{lv=421, base_power=37226000,base_exp=715177,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 422 ->
 	#base_afk{lv=422, base_power=37662000,base_exp=720444,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 423 ->
 	#base_afk{lv=423, base_power=38098000,base_exp=727862,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 424 ->
 	#base_afk{lv=424, base_power=38534000,base_exp=734980,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 425 ->
 	#base_afk{lv=425, base_power=38970000,base_exp=742248,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 426 ->
 	#base_afk{lv=426, base_power=39416000,base_exp=749766,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 427 ->
 	#base_afk{lv=427, base_power=39862000,base_exp=757083,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 428 ->
 	#base_afk{lv=428, base_power=40308000,base_exp=764601,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 429 ->
 	#base_afk{lv=429, base_power=40754000,base_exp=771869,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 430 ->
 	#base_afk{lv=430, base_power=41200000,base_exp=779387,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 431 ->
 	#base_afk{lv=431, base_power=41654000,base_exp=786655,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 432 ->
 	#base_afk{lv=432, base_power=42108000,base_exp=794023,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 433 ->
 	#base_afk{lv=433, base_power=42562000,base_exp=801391,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 434 ->
 	#base_afk{lv=434, base_power=43016000,base_exp=808609,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 435 ->
 	#base_afk{lv=435, base_power=43470000,base_exp=815876,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 436 ->
 	#base_afk{lv=436, base_power=43934000,base_exp=823244,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 437 ->
 	#base_afk{lv=437, base_power=44398000,base_exp=830612,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 438 ->
 	#base_afk{lv=438, base_power=44862000,base_exp=837380,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 439 ->
 	#base_afk{lv=439, base_power=45326000,base_exp=844748,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 440 ->
 	#base_afk{lv=440, base_power=45790000,base_exp=852266,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 441 ->
 	#base_afk{lv=441, base_power=46262000,base_exp=859584,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 442 ->
 	#base_afk{lv=442, base_power=46734000,base_exp=866952,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 443 ->
 	#base_afk{lv=443, base_power=47206000,base_exp=874469,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 444 ->
 	#base_afk{lv=444, base_power=47678000,base_exp=881737,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 445 ->
 	#base_afk{lv=445, base_power=48150000,base_exp=889105,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 446 ->
 	#base_afk{lv=446, base_power=48634000,base_exp=896273,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 447 ->
 	#base_afk{lv=447, base_power=49118000,base_exp=903491,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 448 ->
 	#base_afk{lv=448, base_power=49602000,base_exp=912210,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 449 ->
 	#base_afk{lv=449, base_power=50086000,base_exp=921180,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 450 ->
 	#base_afk{lv=450, base_power=50570000,base_exp=930149,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 451 ->
 	#base_afk{lv=451, base_power=50938000,base_exp=938169,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 452 ->
 	#base_afk{lv=452, base_power=51306000,base_exp=946838,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 453 ->
 	#base_afk{lv=453, base_power=51674000,base_exp=955508,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 454 ->
 	#base_afk{lv=454, base_power=52042000,base_exp=964427,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 455 ->
 	#base_afk{lv=455, base_power=52410000,base_exp=973347,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 456 ->
 	#base_afk{lv=456, base_power=53036000,base_exp=982316,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 457 ->
 	#base_afk{lv=457, base_power=53662000,base_exp=990985,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 458 ->
 	#base_afk{lv=458, base_power=54288000,base_exp=1000005,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 459 ->
 	#base_afk{lv=459, base_power=54914000,base_exp=1008724,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 460 ->
 	#base_afk{lv=460, base_power=55540000,base_exp=1017694,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 461 ->
 	#base_afk{lv=461, base_power=55924000,base_exp=1026413,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 462 ->
 	#base_afk{lv=462, base_power=56308000,base_exp=1035183,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 463 ->
 	#base_afk{lv=463, base_power=56692000,base_exp=1044152,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 464 ->
 	#base_afk{lv=464, base_power=57076000,base_exp=1052971,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 465 ->
 	#base_afk{lv=465, base_power=57460000,base_exp=1061991,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 466 ->
 	#base_afk{lv=466, base_power=57718000,base_exp=1070160,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 467 ->
 	#base_afk{lv=467, base_power=57976000,base_exp=1079180,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 468 ->
 	#base_afk{lv=468, base_power=58234000,base_exp=1087999,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 469 ->
 	#base_afk{lv=469, base_power=58492000,base_exp=1096919,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6292,6293,10833,10834,10859,10860,10885,10886],drop_rule = [{[{340040402,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 470 ->
 	#base_afk{lv=470, base_power=58750000,base_exp=1105888,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 471 ->
 	#base_afk{lv=471, base_power=58986000,base_exp=1114358,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 472 ->
 	#base_afk{lv=472, base_power=59222000,base_exp=1123327,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 473 ->
 	#base_afk{lv=473, base_power=59458000,base_exp=1134048,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 474 ->
 	#base_afk{lv=474, base_power=59694000,base_exp=1144670,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 475 ->
 	#base_afk{lv=475, base_power=59930000,base_exp=1154791,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 476 ->
 	#base_afk{lv=476, base_power=60170000,base_exp=1165362,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 477 ->
 	#base_afk{lv=477, base_power=60410000,base_exp=1175834,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 478 ->
 	#base_afk{lv=478, base_power=60650000,base_exp=1186505,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 479 ->
 	#base_afk{lv=479, base_power=60890000,base_exp=1197276,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 480 ->
 	#base_afk{lv=480, base_power=61130000,base_exp=1207748,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 481 ->
 	#base_afk{lv=481, base_power=61374000,base_exp=1218519,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 482 ->
 	#base_afk{lv=482, base_power=61618000,base_exp=1228890,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 483 ->
 	#base_afk{lv=483, base_power=61862000,base_exp=1239412,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 484 ->
 	#base_afk{lv=484, base_power=62106000,base_exp=1249933,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 485 ->
 	#base_afk{lv=485, base_power=62350000,base_exp=1260354,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 486 ->
 	#base_afk{lv=486, base_power=62600000,base_exp=1271075,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 487 ->
 	#base_afk{lv=487, base_power=62850000,base_exp=1281497,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 488 ->
 	#base_afk{lv=488, base_power=63100000,base_exp=1291618,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 489 ->
 	#base_afk{lv=489, base_power=63350000,base_exp=1302389,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],10},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 490 ->
 	#base_afk{lv=490, base_power=63600000,base_exp=1313111,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 491 ->
 	#base_afk{lv=491, base_power=63854000,base_exp=1323732,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 492 ->
 	#base_afk{lv=492, base_power=64108000,base_exp=1334403,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 493 ->
 	#base_afk{lv=493, base_power=64362000,base_exp=1345175,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 494 ->
 	#base_afk{lv=494, base_power=64616000,base_exp=1355996,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 495 ->
 	#base_afk{lv=495, base_power=64870000,base_exp=1366517,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 496 ->
 	#base_afk{lv=496, base_power=65130000,base_exp=1377289,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 497 ->
 	#base_afk{lv=497, base_power=65390000,base_exp=1387960,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 498 ->
 	#base_afk{lv=498, base_power=65650000,base_exp=1400944,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 499 ->
 	#base_afk{lv=499, base_power=65910000,base_exp=1413827,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 500 ->
 	#base_afk{lv=500, base_power=66170000,base_exp=1426761,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 501 ->
 	#base_afk{lv=501, base_power=66434000,base_exp=1438744,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 502 ->
 	#base_afk{lv=502, base_power=66698000,base_exp=1451528,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 503 ->
 	#base_afk{lv=503, base_power=66962000,base_exp=1463812,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 504 ->
 	#base_afk{lv=504, base_power=67226000,base_exp=1475895,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 505 ->
 	#base_afk{lv=505, base_power=67490000,base_exp=1488879,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 506 ->
 	#base_afk{lv=506, base_power=67760000,base_exp=1501812,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 507 ->
 	#base_afk{lv=507, base_power=68030000,base_exp=1514746,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 508 ->
 	#base_afk{lv=508, base_power=68300000,base_exp=1527680,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 509 ->
 	#base_afk{lv=509, base_power=68570000,base_exp=1540613,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 510 ->
 	#base_afk{lv=510, base_power=68840000,base_exp=1553597,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 511 ->
 	#base_afk{lv=511, base_power=69116000,base_exp=1566480,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 512 ->
 	#base_afk{lv=512, base_power=69392000,base_exp=1578964,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 513 ->
 	#base_afk{lv=513, base_power=69668000,base_exp=1591948,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 514 ->
 	#base_afk{lv=514, base_power=69944000,base_exp=1604881,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 515 ->
 	#base_afk{lv=515, base_power=70220000,base_exp=1617865,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 516 ->
 	#base_afk{lv=516, base_power=70500000,base_exp=1630748,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 517 ->
 	#base_afk{lv=517, base_power=70780000,base_exp=1643732,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 518 ->
 	#base_afk{lv=518, base_power=71060000,base_exp=1656616,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 519 ->
 	#base_afk{lv=519, base_power=71340000,base_exp=1669599,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6298,6299,10835,10836,10861,10862,10887,10888],drop_rule = [{[{340050102,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 520 ->
 	#base_afk{lv=520, base_power=71620000,base_exp=1682483,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 521 ->
 	#base_afk{lv=521, base_power=71906000,base_exp=1695466,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 522 ->
 	#base_afk{lv=522, base_power=72192000,base_exp=1708350,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 523 ->
 	#base_afk{lv=523, base_power=72478000,base_exp=1723928,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 524 ->
 	#base_afk{lv=524, base_power=72764000,base_exp=1739407,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 525 ->
 	#base_afk{lv=525, base_power=73050000,base_exp=1754985,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 526 ->
 	#base_afk{lv=526, base_power=73342000,base_exp=1770463,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 527 ->
 	#base_afk{lv=527, base_power=73634000,base_exp=1786042,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 528 ->
 	#base_afk{lv=528, base_power=73926000,base_exp=1801520,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 529 ->
 	#base_afk{lv=529, base_power=74218000,base_exp=1817098,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 530 ->
 	#base_afk{lv=530, base_power=74510000,base_exp=1832577,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 531 ->
 	#base_afk{lv=531, base_power=74808000,base_exp=1848155,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 532 ->
 	#base_afk{lv=532, base_power=75106000,base_exp=1863633,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 533 ->
 	#base_afk{lv=533, base_power=75404000,base_exp=1879212,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 534 ->
 	#base_afk{lv=534, base_power=75702000,base_exp=1894690,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 535 ->
 	#base_afk{lv=535, base_power=76000000,base_exp=1910268,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 536 ->
 	#base_afk{lv=536, base_power=76304000,base_exp=1925746,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 537 ->
 	#base_afk{lv=537, base_power=76608000,base_exp=1941325,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 538 ->
 	#base_afk{lv=538, base_power=76912000,base_exp=1956803,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 539 ->
 	#base_afk{lv=539, base_power=77216000,base_exp=1972381,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 540 ->
 	#base_afk{lv=540, base_power=77520000,base_exp=1987860,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 541 ->
 	#base_afk{lv=541, base_power=77830000,base_exp=2003438,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 542 ->
 	#base_afk{lv=542, base_power=78140000,base_exp=2018916,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 543 ->
 	#base_afk{lv=543, base_power=78450000,base_exp=2034495,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 544 ->
 	#base_afk{lv=544, base_power=78760000,base_exp=2049973,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 545 ->
 	#base_afk{lv=545, base_power=79070000,base_exp=2065551,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 546 ->
 	#base_afk{lv=546, base_power=79386000,base_exp=2081030,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 547 ->
 	#base_afk{lv=547, base_power=79702000,base_exp=2096608,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 548 ->
 	#base_afk{lv=548, base_power=80018000,base_exp=2115200,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 549 ->
 	#base_afk{lv=549, base_power=80334000,base_exp=2133892,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],11},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 550 ->
 	#base_afk{lv=550, base_power=80650000,base_exp=2152484,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 551 ->
 	#base_afk{lv=551, base_power=80972000,base_exp=2171176,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 552 ->
 	#base_afk{lv=552, base_power=81294000,base_exp=2189768,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 553 ->
 	#base_afk{lv=553, base_power=81616000,base_exp=2208460,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 554 ->
 	#base_afk{lv=554, base_power=81938000,base_exp=2227052,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 555 ->
 	#base_afk{lv=555, base_power=82260000,base_exp=2245744,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 556 ->
 	#base_afk{lv=556, base_power=82590000,base_exp=2264336,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 557 ->
 	#base_afk{lv=557, base_power=82920000,base_exp=2283028,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 558 ->
 	#base_afk{lv=558, base_power=83250000,base_exp=2301620,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 559 ->
 	#base_afk{lv=559, base_power=83580000,base_exp=2320312,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 560 ->
 	#base_afk{lv=560, base_power=83910000,base_exp=2338904,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 561 ->
 	#base_afk{lv=561, base_power=84246000,base_exp=2357596,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 562 ->
 	#base_afk{lv=562, base_power=84582000,base_exp=2376188,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 563 ->
 	#base_afk{lv=563, base_power=84918000,base_exp=2394880,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 564 ->
 	#base_afk{lv=564, base_power=85254000,base_exp=2413472,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 565 ->
 	#base_afk{lv=565, base_power=85590000,base_exp=2432164,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 566 ->
 	#base_afk{lv=566, base_power=85932000,base_exp=2450756,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 567 ->
 	#base_afk{lv=567, base_power=86274000,base_exp=2469448,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 568 ->
 	#base_afk{lv=568, base_power=86616000,base_exp=2488040,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 569 ->
 	#base_afk{lv=569, base_power=86958000,base_exp=2506732,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6304,6305,10837,10838,10863,10864,10889,10890],drop_rule = [{[{340050402,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 570 ->
 	#base_afk{lv=570, base_power=87300000,base_exp=2525324,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 571 ->
 	#base_afk{lv=571, base_power=87650000,base_exp=2544016,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 572 ->
 	#base_afk{lv=572, base_power=88000000,base_exp=2562608,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 573 ->
 	#base_afk{lv=573, base_power=88350000,base_exp=2585036,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 574 ->
 	#base_afk{lv=574, base_power=88700000,base_exp=2607365,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 575 ->
 	#base_afk{lv=575, base_power=89050000,base_exp=2629793,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 576 ->
 	#base_afk{lv=576, base_power=89406000,base_exp=2652121,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 577 ->
 	#base_afk{lv=577, base_power=89762000,base_exp=2674550,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 578 ->
 	#base_afk{lv=578, base_power=90118000,base_exp=2696878,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 579 ->
 	#base_afk{lv=579, base_power=90474000,base_exp=2719307,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 580 ->
 	#base_afk{lv=580, base_power=90830000,base_exp=2741635,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 581 ->
 	#base_afk{lv=581, base_power=91194000,base_exp=2764063,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 582 ->
 	#base_afk{lv=582, base_power=91558000,base_exp=2786392,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 583 ->
 	#base_afk{lv=583, base_power=91922000,base_exp=2808820,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 584 ->
 	#base_afk{lv=584, base_power=92286000,base_exp=2831148,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 585 ->
 	#base_afk{lv=585, base_power=92650000,base_exp=2853577,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 586 ->
 	#base_afk{lv=586, base_power=93020000,base_exp=2875905,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 587 ->
 	#base_afk{lv=587, base_power=93390000,base_exp=2898333,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 588 ->
 	#base_afk{lv=588, base_power=93760000,base_exp=2920662,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 589 ->
 	#base_afk{lv=589, base_power=94130000,base_exp=2943090,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 590 ->
 	#base_afk{lv=590, base_power=94500000,base_exp=2965418,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 591 ->
 	#base_afk{lv=591, base_power=94878000,base_exp=2987847,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 592 ->
 	#base_afk{lv=592, base_power=95256000,base_exp=3010175,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 593 ->
 	#base_afk{lv=593, base_power=95634000,base_exp=3032604,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 594 ->
 	#base_afk{lv=594, base_power=96012000,base_exp=3054932,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 595 ->
 	#base_afk{lv=595, base_power=96390000,base_exp=3077360,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 596 ->
 	#base_afk{lv=596, base_power=96776000,base_exp=3099689,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 597 ->
 	#base_afk{lv=597, base_power=97162000,base_exp=3122117,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 598 ->
 	#base_afk{lv=598, base_power=97548000,base_exp=3148929,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 599 ->
 	#base_afk{lv=599, base_power=97934000,base_exp=3175841,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],12},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 600 ->
 	#base_afk{lv=600, base_power=98320000,base_exp=3202653,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 601 ->
 	#base_afk{lv=601, base_power=98714000,base_exp=3229565,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 602 ->
 	#base_afk{lv=602, base_power=99108000,base_exp=3256377,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 603 ->
 	#base_afk{lv=603, base_power=99502000,base_exp=3283289,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 604 ->
 	#base_afk{lv=604, base_power=99896000,base_exp=3310101,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 605 ->
 	#base_afk{lv=605, base_power=100290000,base_exp=3337013,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 606 ->
 	#base_afk{lv=606, base_power=100692000,base_exp=3363825,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 607 ->
 	#base_afk{lv=607, base_power=101094000,base_exp=3390737,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 608 ->
 	#base_afk{lv=608, base_power=101496000,base_exp=3417549,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 609 ->
 	#base_afk{lv=609, base_power=101898000,base_exp=3444461,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 610 ->
 	#base_afk{lv=610, base_power=102300000,base_exp=3471274,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 611 ->
 	#base_afk{lv=611, base_power=102710000,base_exp=3498186,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 612 ->
 	#base_afk{lv=612, base_power=103120000,base_exp=3524998,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 613 ->
 	#base_afk{lv=613, base_power=103530000,base_exp=3551910,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 614 ->
 	#base_afk{lv=614, base_power=103940000,base_exp=3578722,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 615 ->
 	#base_afk{lv=615, base_power=104350000,base_exp=3605634,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 616 ->
 	#base_afk{lv=616, base_power=104768000,base_exp=3632446,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 617 ->
 	#base_afk{lv=617, base_power=105186000,base_exp=3659358,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 618 ->
 	#base_afk{lv=618, base_power=105604000,base_exp=3686170,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 619 ->
 	#base_afk{lv=619, base_power=106022000,base_exp=3713082,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6310,6311,10839,10840,10865,10866,10891,10892],drop_rule = [{[{340060102,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 620 ->
 	#base_afk{lv=620, base_power=106440000,base_exp=3739894,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 621 ->
 	#base_afk{lv=621, base_power=106866000,base_exp=3766806,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 622 ->
 	#base_afk{lv=622, base_power=107292000,base_exp=3793618,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 623 ->
 	#base_afk{lv=623, base_power=107718000,base_exp=3825910,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 624 ->
 	#base_afk{lv=624, base_power=108144000,base_exp=3858103,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 625 ->
 	#base_afk{lv=625, base_power=108570000,base_exp=3890395,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 626 ->
 	#base_afk{lv=626, base_power=109004000,base_exp=3922588,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 627 ->
 	#base_afk{lv=627, base_power=109438000,base_exp=3954880,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 628 ->
 	#base_afk{lv=628, base_power=109872000,base_exp=3987073,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 629 ->
 	#base_afk{lv=629, base_power=110306000,base_exp=4019365,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 630 ->
 	#base_afk{lv=630, base_power=110740000,base_exp=4051558,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 631 ->
 	#base_afk{lv=631, base_power=111182000,base_exp=4083850,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 632 ->
 	#base_afk{lv=632, base_power=111624000,base_exp=4116043,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 633 ->
 	#base_afk{lv=633, base_power=112066000,base_exp=4148335,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 634 ->
 	#base_afk{lv=634, base_power=112508000,base_exp=4180528,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 635 ->
 	#base_afk{lv=635, base_power=112950000,base_exp=4212820,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 636 ->
 	#base_afk{lv=636, base_power=113402000,base_exp=4245013,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 637 ->
 	#base_afk{lv=637, base_power=113854000,base_exp=4277305,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 638 ->
 	#base_afk{lv=638, base_power=114306000,base_exp=4309498,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 639 ->
 	#base_afk{lv=639, base_power=114758000,base_exp=4341790,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 640 ->
 	#base_afk{lv=640, base_power=115210000,base_exp=4373983,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 641 ->
 	#base_afk{lv=641, base_power=115670000,base_exp=4406275,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 642 ->
 	#base_afk{lv=642, base_power=116130000,base_exp=4438468,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 643 ->
 	#base_afk{lv=643, base_power=116590000,base_exp=4470760,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 644 ->
 	#base_afk{lv=644, base_power=117050000,base_exp=4502953,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 645 ->
 	#base_afk{lv=645, base_power=117510000,base_exp=4535245,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 646 ->
 	#base_afk{lv=646, base_power=117980000,base_exp=4567438,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 647 ->
 	#base_afk{lv=647, base_power=118450000,base_exp=4599730,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 648 ->
 	#base_afk{lv=648, base_power=118920000,base_exp=4638379,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 649 ->
 	#base_afk{lv=649, base_power=119390000,base_exp=4677128,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 650 ->
 	#base_afk{lv=650, base_power=119860000,base_exp=4715777,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 651 ->
 	#base_afk{lv=651, base_power=120340000,base_exp=4754526,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 652 ->
 	#base_afk{lv=652, base_power=120820000,base_exp=4793175,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 653 ->
 	#base_afk{lv=653, base_power=121300000,base_exp=4831924,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 654 ->
 	#base_afk{lv=654, base_power=121780000,base_exp=4870573,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 655 ->
 	#base_afk{lv=655, base_power=122260000,base_exp=4909322,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 656 ->
 	#base_afk{lv=656, base_power=122750000,base_exp=4947971,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 657 ->
 	#base_afk{lv=657, base_power=123240000,base_exp=4986720,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 658 ->
 	#base_afk{lv=658, base_power=123730000,base_exp=5025369,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 659 ->
 	#base_afk{lv=659, base_power=124220000,base_exp=5064118,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 660 ->
 	#base_afk{lv=660, base_power=124710000,base_exp=5102766,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 661 ->
 	#base_afk{lv=661, base_power=125208000,base_exp=5141515,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 662 ->
 	#base_afk{lv=662, base_power=125706000,base_exp=5180164,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 663 ->
 	#base_afk{lv=663, base_power=126204000,base_exp=5218913,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 664 ->
 	#base_afk{lv=664, base_power=126702000,base_exp=5257562,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 665 ->
 	#base_afk{lv=665, base_power=127200000,base_exp=5296311,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 666 ->
 	#base_afk{lv=666, base_power=127708000,base_exp=5334960,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 667 ->
 	#base_afk{lv=667, base_power=128216000,base_exp=5373709,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 668 ->
 	#base_afk{lv=668, base_power=128724000,base_exp=5412358,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 669 ->
 	#base_afk{lv=669, base_power=129232000,base_exp=5451107,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6316,6317,10841,10842,10867,10868,10893,10894],drop_rule = [{[{340060402,1}],120},{[{56000101,1}],83},{[{9999999,1}],13},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 670 ->
 	#base_afk{lv=670, base_power=129740000,base_exp=5489756,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 671 ->
 	#base_afk{lv=671, base_power=130258000,base_exp=5528505,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 672 ->
 	#base_afk{lv=672, base_power=130776000,base_exp=5567154,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 673 ->
 	#base_afk{lv=673, base_power=131294000,base_exp=5613651,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 674 ->
 	#base_afk{lv=674, base_power=131812000,base_exp=5660048,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 675 ->
 	#base_afk{lv=675, base_power=132330000,base_exp=5706544,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 676 ->
 	#base_afk{lv=676, base_power=132860000,base_exp=5752941,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 677 ->
 	#base_afk{lv=677, base_power=133390000,base_exp=5799438,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 678 ->
 	#base_afk{lv=678, base_power=133920000,base_exp=5845835,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 679 ->
 	#base_afk{lv=679, base_power=134450000,base_exp=5892331,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 680 ->
 	#base_afk{lv=680, base_power=134980000,base_exp=5938728,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 681 ->
 	#base_afk{lv=681, base_power=135520000,base_exp=5985225,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 682 ->
 	#base_afk{lv=682, base_power=136060000,base_exp=6031622,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 683 ->
 	#base_afk{lv=683, base_power=136600000,base_exp=6078118,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 684 ->
 	#base_afk{lv=684, base_power=137140000,base_exp=6124515,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 685 ->
 	#base_afk{lv=685, base_power=137680000,base_exp=6171012,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 686 ->
 	#base_afk{lv=686, base_power=138230000,base_exp=6217409,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 687 ->
 	#base_afk{lv=687, base_power=138780000,base_exp=6263905,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 688 ->
 	#base_afk{lv=688, base_power=139330000,base_exp=6310302,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 689 ->
 	#base_afk{lv=689, base_power=139880000,base_exp=6356799,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 690 ->
 	#base_afk{lv=690, base_power=140430000,base_exp=6403196,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 691 ->
 	#base_afk{lv=691, base_power=140992000,base_exp=6449692,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 692 ->
 	#base_afk{lv=692, base_power=141554000,base_exp=6496089,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 693 ->
 	#base_afk{lv=693, base_power=142116000,base_exp=6542586,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 694 ->
 	#base_afk{lv=694, base_power=142678000,base_exp=6588983,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 695 ->
 	#base_afk{lv=695, base_power=143240000,base_exp=6635479,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 696 ->
 	#base_afk{lv=696, base_power=143812000,base_exp=6681876,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 697 ->
 	#base_afk{lv=697, base_power=144384000,base_exp=6728373,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 698 ->
 	#base_afk{lv=698, base_power=144956000,base_exp=6784067,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 699 ->
 	#base_afk{lv=699, base_power=145528000,base_exp=6839861,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 700 ->
 	#base_afk{lv=700, base_power=146100000,base_exp=6895555,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 701 ->
 	#base_afk{lv=701, base_power=146684000,base_exp=6951349,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 702 ->
 	#base_afk{lv=702, base_power=147268000,base_exp=7007043,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 703 ->
 	#base_afk{lv=703, base_power=147852000,base_exp=7062837,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 704 ->
 	#base_afk{lv=704, base_power=148436000,base_exp=7118532,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 705 ->
 	#base_afk{lv=705, base_power=149020000,base_exp=7174326,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 706 ->
 	#base_afk{lv=706, base_power=149616000,base_exp=7230020,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 707 ->
 	#base_afk{lv=707, base_power=150212000,base_exp=7285814,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 708 ->
 	#base_afk{lv=708, base_power=150808000,base_exp=7341508,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 709 ->
 	#base_afk{lv=709, base_power=151404000,base_exp=7397302,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 710 ->
 	#base_afk{lv=710, base_power=152000000,base_exp=7452996,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 711 ->
 	#base_afk{lv=711, base_power=152608000,base_exp=7508790,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 712 ->
 	#base_afk{lv=712, base_power=153216000,base_exp=7564484,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 713 ->
 	#base_afk{lv=713, base_power=153824000,base_exp=7620278,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 714 ->
 	#base_afk{lv=714, base_power=154432000,base_exp=7675972,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 715 ->
 	#base_afk{lv=715, base_power=155040000,base_exp=7731766,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 716 ->
 	#base_afk{lv=716, base_power=155660000,base_exp=7787461,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 717 ->
 	#base_afk{lv=717, base_power=156280000,base_exp=7843255,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 718 ->
 	#base_afk{lv=718, base_power=156900000,base_exp=7898949,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 719 ->
 	#base_afk{lv=719, base_power=157520000,base_exp=7954743,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6322,6323,10843,10844,10869,10870,10895,10896],drop_rule = [{[{340070102,1}],120},{[{56000101,1}],83},{[{9999999,1}],14},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 720 ->
 	#base_afk{lv=720, base_power=158140000,base_exp=8010437,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 721 ->
 	#base_afk{lv=721, base_power=158772000,base_exp=8066231,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 722 ->
 	#base_afk{lv=722, base_power=159404000,base_exp=8121925,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 723 ->
 	#base_afk{lv=723, base_power=160036000,base_exp=8188876,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 724 ->
 	#base_afk{lv=724, base_power=160668000,base_exp=8255727,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 725 ->
 	#base_afk{lv=725, base_power=161300000,base_exp=8322678,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 726 ->
 	#base_afk{lv=726, base_power=161946000,base_exp=8389529,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 727 ->
 	#base_afk{lv=727, base_power=162592000,base_exp=8456480,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 728 ->
 	#base_afk{lv=728, base_power=163238000,base_exp=8523331,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 729 ->
 	#base_afk{lv=729, base_power=163884000,base_exp=8590281,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 730 ->
 	#base_afk{lv=730, base_power=164530000,base_exp=8657132,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 731 ->
 	#base_afk{lv=731, base_power=165188000,base_exp=8724083,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 732 ->
 	#base_afk{lv=732, base_power=165846000,base_exp=8790934,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 733 ->
 	#base_afk{lv=733, base_power=166504000,base_exp=8857885,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 734 ->
 	#base_afk{lv=734, base_power=167162000,base_exp=8924736,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 735 ->
 	#base_afk{lv=735, base_power=167820000,base_exp=8991687,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 736 ->
 	#base_afk{lv=736, base_power=168492000,base_exp=9058538,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 737 ->
 	#base_afk{lv=737, base_power=169164000,base_exp=9125489,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 738 ->
 	#base_afk{lv=738, base_power=169836000,base_exp=9192340,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 739 ->
 	#base_afk{lv=739, base_power=170508000,base_exp=9259291,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 740 ->
 	#base_afk{lv=740, base_power=171180000,base_exp=9326142,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 741 ->
 	#base_afk{lv=741, base_power=171864000,base_exp=9393092,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 742 ->
 	#base_afk{lv=742, base_power=172548000,base_exp=9459943,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 743 ->
 	#base_afk{lv=743, base_power=173232000,base_exp=9526894,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 744 ->
 	#base_afk{lv=744, base_power=173916000,base_exp=9593745,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 745 ->
 	#base_afk{lv=745, base_power=174600000,base_exp=9660696,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 746 ->
 	#base_afk{lv=746, base_power=175298000,base_exp=9727547,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 747 ->
 	#base_afk{lv=747, base_power=175996000,base_exp=9794498,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 748 ->
 	#base_afk{lv=748, base_power=176694000,base_exp=9874737,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 749 ->
 	#base_afk{lv=749, base_power=177392000,base_exp=9955076,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 750 ->
 	#base_afk{lv=750, base_power=178090000,base_exp=10035315,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 751 ->
 	#base_afk{lv=751, base_power=178802000,base_exp=10115654,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 752 ->
 	#base_afk{lv=752, base_power=179514000,base_exp=10195894,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 753 ->
 	#base_afk{lv=753, base_power=180226000,base_exp=10276233,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 754 ->
 	#base_afk{lv=754, base_power=180938000,base_exp=10356472,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 755 ->
 	#base_afk{lv=755, base_power=181650000,base_exp=10436811,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 756 ->
 	#base_afk{lv=756, base_power=182376000,base_exp=10517050,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 757 ->
 	#base_afk{lv=757, base_power=183102000,base_exp=10597389,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 758 ->
 	#base_afk{lv=758, base_power=183828000,base_exp=10677628,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 759 ->
 	#base_afk{lv=759, base_power=184554000,base_exp=10757967,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 760 ->
 	#base_afk{lv=760, base_power=185280000,base_exp=10838207,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 761 ->
 	#base_afk{lv=761, base_power=186022000,base_exp=10918546,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 762 ->
 	#base_afk{lv=762, base_power=186764000,base_exp=10998785,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 763 ->
 	#base_afk{lv=763, base_power=187506000,base_exp=11079124,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 764 ->
 	#base_afk{lv=764, base_power=188248000,base_exp=11159363,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 765 ->
 	#base_afk{lv=765, base_power=188990000,base_exp=11239702,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 766 ->
 	#base_afk{lv=766, base_power=189746000,base_exp=11319941,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 767 ->
 	#base_afk{lv=767, base_power=190502000,base_exp=11400280,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 768 ->
 	#base_afk{lv=768, base_power=191258000,base_exp=11480520,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 769 ->
 	#base_afk{lv=769, base_power=192014000,base_exp=11560859,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 770 ->
 	#base_afk{lv=770, base_power=192770000,base_exp=11641098,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 771 ->
 	#base_afk{lv=771, base_power=193542000,base_exp=11721437,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 772 ->
 	#base_afk{lv=772, base_power=194314000,base_exp=11801676,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 773 ->
 	#base_afk{lv=773, base_power=195086000,base_exp=11898081,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 774 ->
 	#base_afk{lv=774, base_power=195858000,base_exp=11994386,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 775 ->
 	#base_afk{lv=775, base_power=196630000,base_exp=12090791,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 776 ->
 	#base_afk{lv=776, base_power=197416000,base_exp=12187096,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 777 ->
 	#base_afk{lv=777, base_power=198202000,base_exp=12283501,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 778 ->
 	#base_afk{lv=778, base_power=198988000,base_exp=12379806,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 779 ->
 	#base_afk{lv=779, base_power=199774000,base_exp=12476210,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 780 ->
 	#base_afk{lv=780, base_power=200560000,base_exp=12572515,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 781 ->
 	#base_afk{lv=781, base_power=201362000,base_exp=12668920,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 782 ->
 	#base_afk{lv=782, base_power=202164000,base_exp=12765225,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 783 ->
 	#base_afk{lv=783, base_power=202966000,base_exp=12861630,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 784 ->
 	#base_afk{lv=784, base_power=203768000,base_exp=12957935,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 785 ->
 	#base_afk{lv=785, base_power=204570000,base_exp=13054340,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 786 ->
 	#base_afk{lv=786, base_power=205388000,base_exp=13150645,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 787 ->
 	#base_afk{lv=787, base_power=206206000,base_exp=13247050,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 788 ->
 	#base_afk{lv=788, base_power=207024000,base_exp=13343355,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 789 ->
 	#base_afk{lv=789, base_power=207842000,base_exp=13439760,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],15},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 790 ->
 	#base_afk{lv=790, base_power=208660000,base_exp=13536065,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 791 ->
 	#base_afk{lv=791, base_power=209494000,base_exp=13632469,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 792 ->
 	#base_afk{lv=792, base_power=210328000,base_exp=13728774,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 793 ->
 	#base_afk{lv=793, base_power=211162000,base_exp=13825179,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 794 ->
 	#base_afk{lv=794, base_power=211996000,base_exp=13921484,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 795 ->
 	#base_afk{lv=795, base_power=212830000,base_exp=14017889,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 796 ->
 	#base_afk{lv=796, base_power=213682000,base_exp=14114194,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 797 ->
 	#base_afk{lv=797, base_power=214534000,base_exp=14210599,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 798 ->
 	#base_afk{lv=798, base_power=215386000,base_exp=14326183,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 799 ->
 	#base_afk{lv=799, base_power=216238000,base_exp=14441867,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 800 ->
 	#base_afk{lv=800, base_power=217090000,base_exp=14557451,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 801 ->
 	#base_afk{lv=801, base_power=217958000,base_exp=14673135,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 802 ->
 	#base_afk{lv=802, base_power=218826000,base_exp=14788719,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 803 ->
 	#base_afk{lv=803, base_power=219694000,base_exp=14904403,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 804 ->
 	#base_afk{lv=804, base_power=220562000,base_exp=15019986,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 805 ->
 	#base_afk{lv=805, base_power=221430000,base_exp=15135670,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 806 ->
 	#base_afk{lv=806, base_power=222316000,base_exp=15251254,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 807 ->
 	#base_afk{lv=807, base_power=223202000,base_exp=15366938,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 808 ->
 	#base_afk{lv=808, base_power=224088000,base_exp=15482522,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 809 ->
 	#base_afk{lv=809, base_power=224974000,base_exp=15598206,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 810 ->
 	#base_afk{lv=810, base_power=225860000,base_exp=15713790,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 811 ->
 	#base_afk{lv=811, base_power=226764000,base_exp=15829474,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 812 ->
 	#base_afk{lv=812, base_power=227668000,base_exp=15945058,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 813 ->
 	#base_afk{lv=813, base_power=228572000,base_exp=16060742,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 814 ->
 	#base_afk{lv=814, base_power=229476000,base_exp=16176326,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 815 ->
 	#base_afk{lv=815, base_power=230380000,base_exp=16292010,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 816 ->
 	#base_afk{lv=816, base_power=231302000,base_exp=16407593,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 817 ->
 	#base_afk{lv=817, base_power=232224000,base_exp=16523277,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 818 ->
 	#base_afk{lv=818, base_power=233146000,base_exp=16638861,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 819 ->
 	#base_afk{lv=819, base_power=234068000,base_exp=16754545,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 820 ->
 	#base_afk{lv=820, base_power=234990000,base_exp=16870129,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 821 ->
 	#base_afk{lv=821, base_power=235930000,base_exp=16985813,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 822 ->
 	#base_afk{lv=822, base_power=236870000,base_exp=17101397,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 823 ->
 	#base_afk{lv=823, base_power=237810000,base_exp=17240216,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 824 ->
 	#base_afk{lv=824, base_power=238750000,base_exp=17378934,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 825 ->
 	#base_afk{lv=825, base_power=239690000,base_exp=17517753,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 826 ->
 	#base_afk{lv=826, base_power=240648000,base_exp=17656472,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 827 ->
 	#base_afk{lv=827, base_power=241606000,base_exp=17795290,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 828 ->
 	#base_afk{lv=828, base_power=242564000,base_exp=17934009,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 829 ->
 	#base_afk{lv=829, base_power=243522000,base_exp=18072828,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 830 ->
 	#base_afk{lv=830, base_power=244480000,base_exp=18211546,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 831 ->
 	#base_afk{lv=831, base_power=245458000,base_exp=18350365,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 832 ->
 	#base_afk{lv=832, base_power=246436000,base_exp=18489084,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 833 ->
 	#base_afk{lv=833, base_power=247414000,base_exp=18627902,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 834 ->
 	#base_afk{lv=834, base_power=248392000,base_exp=18766621,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 835 ->
 	#base_afk{lv=835, base_power=249370000,base_exp=18905440,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 836 ->
 	#base_afk{lv=836, base_power=250368000,base_exp=19044159,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 837 ->
 	#base_afk{lv=837, base_power=251366000,base_exp=19182977,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 838 ->
 	#base_afk{lv=838, base_power=252364000,base_exp=19321696,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 839 ->
 	#base_afk{lv=839, base_power=253362000,base_exp=19460515,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 840 ->
 	#base_afk{lv=840, base_power=254360000,base_exp=19599233,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 841 ->
 	#base_afk{lv=841, base_power=255378000,base_exp=19738052,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 842 ->
 	#base_afk{lv=842, base_power=256396000,base_exp=19876771,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 843 ->
 	#base_afk{lv=843, base_power=257414000,base_exp=20015589,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 844 ->
 	#base_afk{lv=844, base_power=258432000,base_exp=20154308,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 845 ->
 	#base_afk{lv=845, base_power=259450000,base_exp=20293127,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 846 ->
 	#base_afk{lv=846, base_power=260488000,base_exp=20431845,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 847 ->
 	#base_afk{lv=847, base_power=261526000,base_exp=20570664,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 848 ->
 	#base_afk{lv=848, base_power=262564000,base_exp=20737144,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 849 ->
 	#base_afk{lv=849, base_power=263602000,base_exp=20903725,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],16},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 850 ->
 	#base_afk{lv=850, base_power=264640000,base_exp=21070205,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 851 ->
 	#base_afk{lv=851, base_power=265698000,base_exp=21236786,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 852 ->
 	#base_afk{lv=852, base_power=266756000,base_exp=21403266,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 853 ->
 	#base_afk{lv=853, base_power=267814000,base_exp=21569846,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 854 ->
 	#base_afk{lv=854, base_power=268872000,base_exp=21736327,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 855 ->
 	#base_afk{lv=855, base_power=269930000,base_exp=21902907,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 856 ->
 	#base_afk{lv=856, base_power=271010000,base_exp=22069388,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 857 ->
 	#base_afk{lv=857, base_power=272090000,base_exp=22235968,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 858 ->
 	#base_afk{lv=858, base_power=273170000,base_exp=22402448,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 859 ->
 	#base_afk{lv=859, base_power=274250000,base_exp=22569029,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 860 ->
 	#base_afk{lv=860, base_power=275330000,base_exp=22735509,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 861 ->
 	#base_afk{lv=861, base_power=276432000,base_exp=22902090,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 862 ->
 	#base_afk{lv=862, base_power=277534000,base_exp=23068570,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 863 ->
 	#base_afk{lv=863, base_power=278636000,base_exp=23235150,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 864 ->
 	#base_afk{lv=864, base_power=279738000,base_exp=23401631,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 865 ->
 	#base_afk{lv=865, base_power=280840000,base_exp=23568211,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 866 ->
 	#base_afk{lv=866, base_power=281964000,base_exp=23734692,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 867 ->
 	#base_afk{lv=867, base_power=283088000,base_exp=23901272,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 868 ->
 	#base_afk{lv=868, base_power=284212000,base_exp=24067752,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 869 ->
 	#base_afk{lv=869, base_power=285336000,base_exp=24234333,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 870 ->
 	#base_afk{lv=870, base_power=286460000,base_exp=24400813,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 871 ->
 	#base_afk{lv=871, base_power=287606000,base_exp=24567394,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 872 ->
 	#base_afk{lv=872, base_power=288752000,base_exp=24733874,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 873 ->
 	#base_afk{lv=873, base_power=289898000,base_exp=24933769,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 874 ->
 	#base_afk{lv=874, base_power=291044000,base_exp=25133563,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 875 ->
 	#base_afk{lv=875, base_power=292190000,base_exp=25333458,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 876 ->
 	#base_afk{lv=876, base_power=293358000,base_exp=25533252,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 877 ->
 	#base_afk{lv=877, base_power=294526000,base_exp=25733147,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 878 ->
 	#base_afk{lv=878, base_power=295694000,base_exp=25932941,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 879 ->
 	#base_afk{lv=879, base_power=296862000,base_exp=26132836,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 880 ->
 	#base_afk{lv=880, base_power=298030000,base_exp=26332630,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 881 ->
 	#base_afk{lv=881, base_power=299222000,base_exp=26532525,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 882 ->
 	#base_afk{lv=882, base_power=300414000,base_exp=26732319,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 883 ->
 	#base_afk{lv=883, base_power=301606000,base_exp=26932214,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 884 ->
 	#base_afk{lv=884, base_power=302798000,base_exp=27132008,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 885 ->
 	#base_afk{lv=885, base_power=303990000,base_exp=27331903,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 886 ->
 	#base_afk{lv=886, base_power=305206000,base_exp=27531697,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 887 ->
 	#base_afk{lv=887, base_power=306422000,base_exp=27731592,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 888 ->
 	#base_afk{lv=888, base_power=307638000,base_exp=27931386,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 889 ->
 	#base_afk{lv=889, base_power=308854000,base_exp=28131281,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 890 ->
 	#base_afk{lv=890, base_power=310070000,base_exp=28331075,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 891 ->
 	#base_afk{lv=891, base_power=311310000,base_exp=28530970,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 892 ->
 	#base_afk{lv=892, base_power=312550000,base_exp=28730764,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 893 ->
 	#base_afk{lv=893, base_power=313790000,base_exp=28930659,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 894 ->
 	#base_afk{lv=894, base_power=315030000,base_exp=29130453,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 895 ->
 	#base_afk{lv=895, base_power=316270000,base_exp=29330348,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 896 ->
 	#base_afk{lv=896, base_power=317536000,base_exp=29530142,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 897 ->
 	#base_afk{lv=897, base_power=318802000,base_exp=29730037,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 898 ->
 	#base_afk{lv=898, base_power=320068000,base_exp=29969808,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 899 ->
 	#base_afk{lv=899, base_power=321334000,base_exp=30209680,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 900 ->
 	#base_afk{lv=900, base_power=322600000,base_exp=30449451,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 901 ->
 	#base_afk{lv=901, base_power=323890000,base_exp=30689323,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 902 ->
 	#base_afk{lv=902, base_power=325180000,base_exp=30929094,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 903 ->
 	#base_afk{lv=903, base_power=326470000,base_exp=31168966,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 904 ->
 	#base_afk{lv=904, base_power=327760000,base_exp=31408737,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 905 ->
 	#base_afk{lv=905, base_power=329050000,base_exp=31648609,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 906 ->
 	#base_afk{lv=906, base_power=330366000,base_exp=31888380,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 907 ->
 	#base_afk{lv=907, base_power=331682000,base_exp=32128251,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 908 ->
 	#base_afk{lv=908, base_power=332998000,base_exp=32368023,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 909 ->
 	#base_afk{lv=909, base_power=334314000,base_exp=32607894,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],17},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 910 ->
 	#base_afk{lv=910, base_power=335630000,base_exp=32847666,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 911 ->
 	#base_afk{lv=911, base_power=336972000,base_exp=33087537,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 912 ->
 	#base_afk{lv=912, base_power=338314000,base_exp=33327309,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 913 ->
 	#base_afk{lv=913, base_power=339656000,base_exp=33567180,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 914 ->
 	#base_afk{lv=914, base_power=340998000,base_exp=33806951,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 915 ->
 	#base_afk{lv=915, base_power=342340000,base_exp=34046823,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 916 ->
 	#base_afk{lv=916, base_power=343710000,base_exp=34286594,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 917 ->
 	#base_afk{lv=917, base_power=345080000,base_exp=34526466,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 918 ->
 	#base_afk{lv=918, base_power=346450000,base_exp=34766237,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 919 ->
 	#base_afk{lv=919, base_power=347820000,base_exp=35006109,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 920 ->
 	#base_afk{lv=920, base_power=349190000,base_exp=35245880,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 921 ->
 	#base_afk{lv=921, base_power=350586000,base_exp=35485752,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 922 ->
 	#base_afk{lv=922, base_power=351982000,base_exp=35725523,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 923 ->
 	#base_afk{lv=923, base_power=353378000,base_exp=36013367,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 924 ->
 	#base_afk{lv=924, base_power=354774000,base_exp=36301110,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 925 ->
 	#base_afk{lv=925, base_power=356170000,base_exp=36588954,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 926 ->
 	#base_afk{lv=926, base_power=357594000,base_exp=36876698,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 927 ->
 	#base_afk{lv=927, base_power=359018000,base_exp=37164542,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 928 ->
 	#base_afk{lv=928, base_power=360442000,base_exp=37452285,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 929 ->
 	#base_afk{lv=929, base_power=361866000,base_exp=37740129,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 930 ->
 	#base_afk{lv=930, base_power=363290000,base_exp=38027873,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 931 ->
 	#base_afk{lv=931, base_power=364744000,base_exp=38315716,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 932 ->
 	#base_afk{lv=932, base_power=366198000,base_exp=38603460,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 933 ->
 	#base_afk{lv=933, base_power=367652000,base_exp=38891304,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 934 ->
 	#base_afk{lv=934, base_power=369106000,base_exp=39179048,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 935 ->
 	#base_afk{lv=935, base_power=370560000,base_exp=39466891,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 936 ->
 	#base_afk{lv=936, base_power=372042000,base_exp=39754635,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 937 ->
 	#base_afk{lv=937, base_power=373524000,base_exp=40042479,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 938 ->
 	#base_afk{lv=938, base_power=375006000,base_exp=40330223,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 939 ->
 	#base_afk{lv=939, base_power=376488000,base_exp=40618066,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 940 ->
 	#base_afk{lv=940, base_power=377970000,base_exp=40905810,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 941 ->
 	#base_afk{lv=941, base_power=379482000,base_exp=41193654,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 942 ->
 	#base_afk{lv=942, base_power=380994000,base_exp=41481397,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 943 ->
 	#base_afk{lv=943, base_power=382506000,base_exp=41769241,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 944 ->
 	#base_afk{lv=944, base_power=384018000,base_exp=42056985,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 945 ->
 	#base_afk{lv=945, base_power=385530000,base_exp=42344829,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 946 ->
 	#base_afk{lv=946, base_power=387072000,base_exp=42632572,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 947 ->
 	#base_afk{lv=947, base_power=388614000,base_exp=42920416,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 948 ->
 	#base_afk{lv=948, base_power=390156000,base_exp=43265726,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 949 ->
 	#base_afk{lv=949, base_power=391698000,base_exp=43611137,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 950 ->
 	#base_afk{lv=950, base_power=393240000,base_exp=43956447,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 951 ->
 	#base_afk{lv=951, base_power=394782000,base_exp=44301858,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 952 ->
 	#base_afk{lv=952, base_power=396324000,base_exp=44647168,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 953 ->
 	#base_afk{lv=953, base_power=397866000,base_exp=44992579,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 954 ->
 	#base_afk{lv=954, base_power=399408000,base_exp=45337889,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 955 ->
 	#base_afk{lv=955, base_power=400950000,base_exp=45683300,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 956 ->
 	#base_afk{lv=956, base_power=402492000,base_exp=46028610,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 957 ->
 	#base_afk{lv=957, base_power=404034000,base_exp=46374020,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 958 ->
 	#base_afk{lv=958, base_power=405576000,base_exp=46719331,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 959 ->
 	#base_afk{lv=959, base_power=407118000,base_exp=47064741,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 960 ->
 	#base_afk{lv=960, base_power=408660000,base_exp=47410052,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 961 ->
 	#base_afk{lv=961, base_power=410202000,base_exp=47755462,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 962 ->
 	#base_afk{lv=962, base_power=411744000,base_exp=48100773,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 963 ->
 	#base_afk{lv=963, base_power=413286000,base_exp=48446183,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 964 ->
 	#base_afk{lv=964, base_power=414828000,base_exp=48791493,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 965 ->
 	#base_afk{lv=965, base_power=416370000,base_exp=49136904,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 966 ->
 	#base_afk{lv=966, base_power=417912000,base_exp=49482214,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 967 ->
 	#base_afk{lv=967, base_power=419454000,base_exp=49827625,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 968 ->
 	#base_afk{lv=968, base_power=420996000,base_exp=50172935,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 969 ->
 	#base_afk{lv=969, base_power=422538000,base_exp=50518346,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],18},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 970 ->
 	#base_afk{lv=970, base_power=424080000,base_exp=50863656,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 971 ->
 	#base_afk{lv=971, base_power=425622000,base_exp=51209067,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 972 ->
 	#base_afk{lv=972, base_power=427164000,base_exp=51554377,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 973 ->
 	#base_afk{lv=973, base_power=428706000,base_exp=49481984,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 974 ->
 	#base_afk{lv=974, base_power=430248000,base_exp=47409492,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 975 ->
 	#base_afk{lv=975, base_power=431790000,base_exp=45337099,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 976 ->
 	#base_afk{lv=976, base_power=433332000,base_exp=43264606,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 977 ->
 	#base_afk{lv=977, base_power=434874000,base_exp=41192214,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 978 ->
 	#base_afk{lv=978, base_power=436416000,base_exp=39119721,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 979 ->
 	#base_afk{lv=979, base_power=437958000,base_exp=37047328,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 980 ->
 	#base_afk{lv=980, base_power=439500000,base_exp=34974836,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 981 ->
 	#base_afk{lv=981, base_power=441042000,base_exp=32902443,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 982 ->
 	#base_afk{lv=982, base_power=442584000,base_exp=30829950,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 983 ->
 	#base_afk{lv=983, base_power=444126000,base_exp=28757558,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 984 ->
 	#base_afk{lv=984, base_power=445668000,base_exp=26685065,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 985 ->
 	#base_afk{lv=985, base_power=447210000,base_exp=24612672,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 986 ->
 	#base_afk{lv=986, base_power=448752000,base_exp=22540179,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 987 ->
 	#base_afk{lv=987, base_power=450294000,base_exp=20467787,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 988 ->
 	#base_afk{lv=988, base_power=451836000,base_exp=18395294,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 989 ->
 	#base_afk{lv=989, base_power=453378000,base_exp=16322901,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 990 ->
 	#base_afk{lv=990, base_power=454920000,base_exp=14250409,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 991 ->
 	#base_afk{lv=991, base_power=456462000,base_exp=12178016,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 992 ->
 	#base_afk{lv=992, base_power=458004000,base_exp=10105523,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 993 ->
 	#base_afk{lv=993, base_power=459546000,base_exp=8033131,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 994 ->
 	#base_afk{lv=994, base_power=461088000,base_exp=5960638,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 995 ->
 	#base_afk{lv=995, base_power=462630000,base_exp=3888245,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 996 ->
 	#base_afk{lv=996, base_power=464172000,base_exp=1815753,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 997 ->
 	#base_afk{lv=997, base_power=465714000,base_exp=51553427,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 998 ->
 	#base_afk{lv=998, base_power=467256000,base_exp=49480934,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 999 ->
 	#base_afk{lv=999, base_power=468798000,base_exp=47408542,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_lv) when _lv =< 1000 ->
 	#base_afk{lv=1000, base_power=470340000,base_exp=45336049,base_coin=30, drop_list = [9999,10000,10001,10002,2147,2148,2149,2150,2151,6328,6329,10845,10846,10871,10872,10897,10898],drop_rule = [{[{340070402,1}],120},{[{56000101,1}],83},{[{9999999,1}],19},{[{9999998,1}],3}]};
get_afk(_Lv) ->
 	[].
 
 