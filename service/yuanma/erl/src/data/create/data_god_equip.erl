%%%---------------------------------------
%%% module      : data_god_equip
%%% description : 神装配置
%%%
%%%---------------------------------------
-module(data_god_equip).
-compile(export_all).
-include("god_equip.hrl").




get_max_stage_limit(1) ->
9;


get_max_stage_limit(2) ->
10;


get_max_stage_limit(3) ->
10;


get_max_stage_limit(4) ->
11;


get_max_stage_limit(5) ->
12;


get_max_stage_limit(6) ->
12;


get_max_stage_limit(7) ->
13;


get_max_stage_limit(8) ->
14;


get_max_stage_limit(9) ->
14;


get_max_stage_limit(10) ->
15;


get_max_stage_limit(11) ->
16;


get_max_stage_limit(12) ->
16;

get_max_stage_limit(_Level) ->
	0.


get_god_all_name(1) ->
<<"神一·"/utf8>>;


get_god_all_name(2) ->
<<"神二·"/utf8>>;


get_god_all_name(3) ->
<<"神三·"/utf8>>;


get_god_all_name(4) ->
<<"神四·"/utf8>>;


get_god_all_name(5) ->
<<"神五·"/utf8>>;


get_god_all_name(6) ->
<<"神六·"/utf8>>;


get_god_all_name(7) ->
<<"神七·"/utf8>>;


get_god_all_name(8) ->
<<"神八·"/utf8>>;


get_god_all_name(9) ->
<<"神九·"/utf8>>;


get_god_all_name(10) ->
<<"神十·"/utf8>>;


get_god_all_name(11) ->
<<"神十一·"/utf8>>;


get_god_all_name(12) ->
<<"神十二·"/utf8>>;

get_god_all_name(_Level) ->
	[].


get_god_name(1) ->
<<"神一·无序"/utf8>>;


get_god_name(2) ->
<<"神二·混乱"/utf8>>;


get_god_name(3) ->
<<"神三·灾祸"/utf8>>;


get_god_name(4) ->
<<"神四·毁灭"/utf8>>;


get_god_name(5) ->
<<"神五·永寂"/utf8>>;


get_god_name(6) ->
<<"神六·漫夜"/utf8>>;


get_god_name(7) ->
<<"神七·微芒"/utf8>>;


get_god_name(8) ->
<<"神八·新生"/utf8>>;


get_god_name(9) ->
<<"神九·信仰"/utf8>>;


get_god_name(10) ->
<<"神十·庇佑"/utf8>>;


get_god_name(11) ->
<<"神十一·神临"/utf8>>;


get_god_name(12) ->
<<"神十二·圣祗"/utf8>>;

get_god_name(_Level) ->
	[].

get_god_equip_level(1,0) ->
	#base_god_equip_level{pos = 1,level = 0,cost = [{0,38300101,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(1,1) ->
	#base_god_equip_level{pos = 1,level = 1,cost = [{0,38300101,35}],base_attr_add = [{1,1000},{attr,[{1,5600},{3,1680}]}],extra_attr = 1000};

get_god_equip_level(1,2) ->
	#base_god_equip_level{pos = 1,level = 2,cost = [{0,38300101,60}],base_attr_add = [{1,2000},{attr,[{1,9600},{3,2880}]}],extra_attr = 2000};

get_god_equip_level(1,3) ->
	#base_god_equip_level{pos = 1,level = 3,cost = [{0,38300101,110}],base_attr_add = [{1,3500},{attr,[{1,14400},{3,4320}]}],extra_attr = 3500};

get_god_equip_level(1,4) ->
	#base_god_equip_level{pos = 1,level = 4,cost = [{0,38300101,180}],base_attr_add = [{1,5000},{attr,[{1,20000},{3,6000}]}],extra_attr = 5000};

get_god_equip_level(1,5) ->
	#base_god_equip_level{pos = 1,level = 5,cost = [{0,38300101,220}],base_attr_add = [{1,6500},{attr,[{1,26400},{3,7920}]}],extra_attr = 6500};

get_god_equip_level(1,6) ->
	#base_god_equip_level{pos = 1,level = 6,cost = [{0,38300101,350}],base_attr_add = [{1,8000},{attr,[{1,33600},{3,10080}]}],extra_attr = 8000};

get_god_equip_level(1,7) ->
	#base_god_equip_level{pos = 1,level = 7,cost = [{0,38300101,500},{0,38300201,1}],base_attr_add = [{1,10000},{attr,[{1,41600},{3,12480}]}],extra_attr = 10000};

get_god_equip_level(1,8) ->
	#base_god_equip_level{pos = 1,level = 8,cost = [{0,38300101,600},{0,38300201,2}],base_attr_add = [{1,12000},{attr,[{1,50400},{3,15120}]}],extra_attr = 12000};

get_god_equip_level(1,9) ->
	#base_god_equip_level{pos = 1,level = 9,cost = [{0,38300101,750},{0,38300201,4}],base_attr_add = [{1,15000},{attr,[{1,60000},{3,18000}]}],extra_attr = 15000};

get_god_equip_level(1,10) ->
	#base_god_equip_level{pos = 1,level = 10,cost = [{0,38300101,800},{0,38300201,8}],base_attr_add = [{1,18000},{attr,[{1,70400},{3,21120}]}],extra_attr = 18000};

get_god_equip_level(1,11) ->
	#base_god_equip_level{pos = 1,level = 11,cost = [{0,38300101,1000},{0,38300201,12}],base_attr_add = [{1,21500},{attr,[{1,80800},{3,24240}]}],extra_attr = 21500};

get_god_equip_level(1,12) ->
	#base_god_equip_level{pos = 1,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{1,92800},{3,27840}]}],extra_attr = 25000};

get_god_equip_level(2,0) ->
	#base_god_equip_level{pos = 2,level = 0,cost = [{0,38300102,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(2,1) ->
	#base_god_equip_level{pos = 2,level = 1,cost = [{0,38300102,35}],base_attr_add = [{1,1000},{attr,[{2,112000},{4,1680}]}],extra_attr = 1000};

get_god_equip_level(2,2) ->
	#base_god_equip_level{pos = 2,level = 2,cost = [{0,38300102,60}],base_attr_add = [{1,2000},{attr,[{2,192000},{4,2880}]}],extra_attr = 2000};

get_god_equip_level(2,3) ->
	#base_god_equip_level{pos = 2,level = 3,cost = [{0,38300102,110}],base_attr_add = [{1,3500},{attr,[{2,288000},{4,4320}]}],extra_attr = 3500};

get_god_equip_level(2,4) ->
	#base_god_equip_level{pos = 2,level = 4,cost = [{0,38300102,180}],base_attr_add = [{1,5000},{attr,[{2,400000},{4,6000}]}],extra_attr = 5000};

get_god_equip_level(2,5) ->
	#base_god_equip_level{pos = 2,level = 5,cost = [{0,38300102,220}],base_attr_add = [{1,6500},{attr,[{2,528000},{4,7920}]}],extra_attr = 6500};

get_god_equip_level(2,6) ->
	#base_god_equip_level{pos = 2,level = 6,cost = [{0,38300102,350}],base_attr_add = [{1,8000},{attr,[{2,672000},{4,10080}]}],extra_attr = 8000};

get_god_equip_level(2,7) ->
	#base_god_equip_level{pos = 2,level = 7,cost = [{0,38300102,500},{0,38300201,1}],base_attr_add = [{1,10000},{attr,[{2,832000},{4,12480}]}],extra_attr = 10000};

get_god_equip_level(2,8) ->
	#base_god_equip_level{pos = 2,level = 8,cost = [{0,38300102,600},{0,38300201,2}],base_attr_add = [{1,12000},{attr,[{2,1008000},{4,15120}]}],extra_attr = 12000};

get_god_equip_level(2,9) ->
	#base_god_equip_level{pos = 2,level = 9,cost = [{0,38300102,750},{0,38300201,4}],base_attr_add = [{1,15000},{attr,[{2,1200000},{4,18000}]}],extra_attr = 15000};

get_god_equip_level(2,10) ->
	#base_god_equip_level{pos = 2,level = 10,cost = [{0,38300102,800},{0,38300201,8}],base_attr_add = [{1,18000},{attr,[{2,1408000},{4,21120}]}],extra_attr = 18000};

get_god_equip_level(2,11) ->
	#base_god_equip_level{pos = 2,level = 11,cost = [{0,38300102,1000},{0,38300201,12}],base_attr_add = [{1,21500},{attr,[{2,1616000},{4,24240}]}],extra_attr = 21500};

get_god_equip_level(2,12) ->
	#base_god_equip_level{pos = 2,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{2,1856000},{4,27840}]}],extra_attr = 25000};

get_god_equip_level(3,0) ->
	#base_god_equip_level{pos = 3,level = 0,cost = [{0,38300103,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(3,1) ->
	#base_god_equip_level{pos = 3,level = 1,cost = [{0,38300103,35}],base_attr_add = [{1,1000},{attr,[{1,5600},{3,1680}]}],extra_attr = 1000};

get_god_equip_level(3,2) ->
	#base_god_equip_level{pos = 3,level = 2,cost = [{0,38300103,60}],base_attr_add = [{1,2000},{attr,[{1,9600},{3,2880}]}],extra_attr = 2000};

get_god_equip_level(3,3) ->
	#base_god_equip_level{pos = 3,level = 3,cost = [{0,38300103,110}],base_attr_add = [{1,3500},{attr,[{1,14400},{3,4320}]}],extra_attr = 3500};

get_god_equip_level(3,4) ->
	#base_god_equip_level{pos = 3,level = 4,cost = [{0,38300103,180}],base_attr_add = [{1,5000},{attr,[{1,20000},{3,6000}]}],extra_attr = 5000};

get_god_equip_level(3,5) ->
	#base_god_equip_level{pos = 3,level = 5,cost = [{0,38300103,220}],base_attr_add = [{1,6500},{attr,[{1,26400},{3,7920}]}],extra_attr = 6500};

get_god_equip_level(3,6) ->
	#base_god_equip_level{pos = 3,level = 6,cost = [{0,38300103,350}],base_attr_add = [{1,8000},{attr,[{1,33600},{3,10080}]}],extra_attr = 8000};

get_god_equip_level(3,7) ->
	#base_god_equip_level{pos = 3,level = 7,cost = [{0,38300103,500},{0,38300202,1}],base_attr_add = [{1,10000},{attr,[{1,41600},{3,12480}]}],extra_attr = 10000};

get_god_equip_level(3,8) ->
	#base_god_equip_level{pos = 3,level = 8,cost = [{0,38300103,600},{0,38300202,2}],base_attr_add = [{1,12000},{attr,[{1,50400},{3,15120}]}],extra_attr = 12000};

get_god_equip_level(3,9) ->
	#base_god_equip_level{pos = 3,level = 9,cost = [{0,38300103,750},{0,38300202,4}],base_attr_add = [{1,15000},{attr,[{1,60000},{3,18000}]}],extra_attr = 15000};

get_god_equip_level(3,10) ->
	#base_god_equip_level{pos = 3,level = 10,cost = [{0,38300103,800},{0,38300202,8}],base_attr_add = [{1,18000},{attr,[{1,70400},{3,21120}]}],extra_attr = 18000};

get_god_equip_level(3,11) ->
	#base_god_equip_level{pos = 3,level = 11,cost = [{0,38300103,1000},{0,38300202,12}],base_attr_add = [{1,21500},{attr,[{1,80800},{3,24240}]}],extra_attr = 21500};

get_god_equip_level(3,12) ->
	#base_god_equip_level{pos = 3,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{1,92800},{3,27840}]}],extra_attr = 25000};

get_god_equip_level(4,0) ->
	#base_god_equip_level{pos = 4,level = 0,cost = [{0,38300104,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(4,1) ->
	#base_god_equip_level{pos = 4,level = 1,cost = [{0,38300104,35}],base_attr_add = [{1,1000},{attr,[{2,112000},{4,1680}]}],extra_attr = 1000};

get_god_equip_level(4,2) ->
	#base_god_equip_level{pos = 4,level = 2,cost = [{0,38300104,60}],base_attr_add = [{1,2000},{attr,[{2,192000},{4,2880}]}],extra_attr = 2000};

get_god_equip_level(4,3) ->
	#base_god_equip_level{pos = 4,level = 3,cost = [{0,38300104,110}],base_attr_add = [{1,3500},{attr,[{2,288000},{4,4320}]}],extra_attr = 3500};

get_god_equip_level(4,4) ->
	#base_god_equip_level{pos = 4,level = 4,cost = [{0,38300104,180}],base_attr_add = [{1,5000},{attr,[{2,400000},{4,6000}]}],extra_attr = 5000};

get_god_equip_level(4,5) ->
	#base_god_equip_level{pos = 4,level = 5,cost = [{0,38300104,220}],base_attr_add = [{1,6500},{attr,[{2,528000},{4,7920}]}],extra_attr = 6500};

get_god_equip_level(4,6) ->
	#base_god_equip_level{pos = 4,level = 6,cost = [{0,38300104,350}],base_attr_add = [{1,8000},{attr,[{2,672000},{4,10080}]}],extra_attr = 8000};

get_god_equip_level(4,7) ->
	#base_god_equip_level{pos = 4,level = 7,cost = [{0,38300104,500},{0,38300201,1}],base_attr_add = [{1,10000},{attr,[{2,832000},{4,12480}]}],extra_attr = 10000};

get_god_equip_level(4,8) ->
	#base_god_equip_level{pos = 4,level = 8,cost = [{0,38300104,600},{0,38300201,2}],base_attr_add = [{1,12000},{attr,[{2,1008000},{4,15120}]}],extra_attr = 12000};

get_god_equip_level(4,9) ->
	#base_god_equip_level{pos = 4,level = 9,cost = [{0,38300104,750},{0,38300201,4}],base_attr_add = [{1,15000},{attr,[{2,1200000},{4,18000}]}],extra_attr = 15000};

get_god_equip_level(4,10) ->
	#base_god_equip_level{pos = 4,level = 10,cost = [{0,38300104,800},{0,38300201,8}],base_attr_add = [{1,18000},{attr,[{2,1408000},{4,21120}]}],extra_attr = 18000};

get_god_equip_level(4,11) ->
	#base_god_equip_level{pos = 4,level = 11,cost = [{0,38300104,1000},{0,38300201,12}],base_attr_add = [{1,21500},{attr,[{2,1616000},{4,24240}]}],extra_attr = 21500};

get_god_equip_level(4,12) ->
	#base_god_equip_level{pos = 4,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{2,1856000},{4,27840}]}],extra_attr = 25000};

get_god_equip_level(5,0) ->
	#base_god_equip_level{pos = 5,level = 0,cost = [{0,38300105,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(5,1) ->
	#base_god_equip_level{pos = 5,level = 1,cost = [{0,38300105,35}],base_attr_add = [{1,1000},{attr,[{1,5600},{3,1680}]}],extra_attr = 1000};

get_god_equip_level(5,2) ->
	#base_god_equip_level{pos = 5,level = 2,cost = [{0,38300105,60}],base_attr_add = [{1,2000},{attr,[{1,9600},{3,2880}]}],extra_attr = 2000};

get_god_equip_level(5,3) ->
	#base_god_equip_level{pos = 5,level = 3,cost = [{0,38300105,110}],base_attr_add = [{1,3500},{attr,[{1,14400},{3,4320}]}],extra_attr = 3500};

get_god_equip_level(5,4) ->
	#base_god_equip_level{pos = 5,level = 4,cost = [{0,38300105,180}],base_attr_add = [{1,5000},{attr,[{1,20000},{3,6000}]}],extra_attr = 5000};

get_god_equip_level(5,5) ->
	#base_god_equip_level{pos = 5,level = 5,cost = [{0,38300105,220}],base_attr_add = [{1,6500},{attr,[{1,26400},{3,7920}]}],extra_attr = 6500};

get_god_equip_level(5,6) ->
	#base_god_equip_level{pos = 5,level = 6,cost = [{0,38300105,350}],base_attr_add = [{1,8000},{attr,[{1,33600},{3,10080}]}],extra_attr = 8000};

get_god_equip_level(5,7) ->
	#base_god_equip_level{pos = 5,level = 7,cost = [{0,38300105,500},{0,38300202,1}],base_attr_add = [{1,10000},{attr,[{1,41600},{3,12480}]}],extra_attr = 10000};

get_god_equip_level(5,8) ->
	#base_god_equip_level{pos = 5,level = 8,cost = [{0,38300105,600},{0,38300202,2}],base_attr_add = [{1,12000},{attr,[{1,50400},{3,15120}]}],extra_attr = 12000};

get_god_equip_level(5,9) ->
	#base_god_equip_level{pos = 5,level = 9,cost = [{0,38300105,750},{0,38300202,4}],base_attr_add = [{1,15000},{attr,[{1,60000},{3,18000}]}],extra_attr = 15000};

get_god_equip_level(5,10) ->
	#base_god_equip_level{pos = 5,level = 10,cost = [{0,38300105,800},{0,38300202,8}],base_attr_add = [{1,18000},{attr,[{1,70400},{3,21120}]}],extra_attr = 18000};

get_god_equip_level(5,11) ->
	#base_god_equip_level{pos = 5,level = 11,cost = [{0,38300105,1000},{0,38300202,12}],base_attr_add = [{1,21500},{attr,[{1,80800},{3,24240}]}],extra_attr = 21500};

get_god_equip_level(5,12) ->
	#base_god_equip_level{pos = 5,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{1,92800},{3,27840}]}],extra_attr = 25000};

get_god_equip_level(6,0) ->
	#base_god_equip_level{pos = 6,level = 0,cost = [{0,38300106,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(6,1) ->
	#base_god_equip_level{pos = 6,level = 1,cost = [{0,38300106,35}],base_attr_add = [{1,1000},{attr,[{2,112000},{4,1680}]}],extra_attr = 1000};

get_god_equip_level(6,2) ->
	#base_god_equip_level{pos = 6,level = 2,cost = [{0,38300106,60}],base_attr_add = [{1,2000},{attr,[{2,192000},{4,2880}]}],extra_attr = 2000};

get_god_equip_level(6,3) ->
	#base_god_equip_level{pos = 6,level = 3,cost = [{0,38300106,110}],base_attr_add = [{1,3500},{attr,[{2,288000},{4,4320}]}],extra_attr = 3500};

get_god_equip_level(6,4) ->
	#base_god_equip_level{pos = 6,level = 4,cost = [{0,38300106,180}],base_attr_add = [{1,5000},{attr,[{2,400000},{4,6000}]}],extra_attr = 5000};

get_god_equip_level(6,5) ->
	#base_god_equip_level{pos = 6,level = 5,cost = [{0,38300106,220}],base_attr_add = [{1,6500},{attr,[{2,528000},{4,7920}]}],extra_attr = 6500};

get_god_equip_level(6,6) ->
	#base_god_equip_level{pos = 6,level = 6,cost = [{0,38300106,350}],base_attr_add = [{1,8000},{attr,[{2,672000},{4,10080}]}],extra_attr = 8000};

get_god_equip_level(6,7) ->
	#base_god_equip_level{pos = 6,level = 7,cost = [{0,38300106,500},{0,38300201,1}],base_attr_add = [{1,10000},{attr,[{2,832000},{4,12480}]}],extra_attr = 10000};

get_god_equip_level(6,8) ->
	#base_god_equip_level{pos = 6,level = 8,cost = [{0,38300106,600},{0,38300201,2}],base_attr_add = [{1,12000},{attr,[{2,1008000},{4,15120}]}],extra_attr = 12000};

get_god_equip_level(6,9) ->
	#base_god_equip_level{pos = 6,level = 9,cost = [{0,38300106,750},{0,38300201,4}],base_attr_add = [{1,15000},{attr,[{2,1200000},{4,18000}]}],extra_attr = 15000};

get_god_equip_level(6,10) ->
	#base_god_equip_level{pos = 6,level = 10,cost = [{0,38300106,800},{0,38300201,8}],base_attr_add = [{1,18000},{attr,[{2,1408000},{4,21120}]}],extra_attr = 18000};

get_god_equip_level(6,11) ->
	#base_god_equip_level{pos = 6,level = 11,cost = [{0,38300106,1000},{0,38300201,12}],base_attr_add = [{1,21500},{attr,[{2,1616000},{4,24240}]}],extra_attr = 21500};

get_god_equip_level(6,12) ->
	#base_god_equip_level{pos = 6,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{2,1856000},{4,27840}]}],extra_attr = 25000};

get_god_equip_level(7,0) ->
	#base_god_equip_level{pos = 7,level = 0,cost = [{0,38300107,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(7,1) ->
	#base_god_equip_level{pos = 7,level = 1,cost = [{0,38300107,35}],base_attr_add = [{1,1000},{attr,[{1,5600},{3,1680}]}],extra_attr = 1000};

get_god_equip_level(7,2) ->
	#base_god_equip_level{pos = 7,level = 2,cost = [{0,38300107,60}],base_attr_add = [{1,2000},{attr,[{1,9600},{3,2880}]}],extra_attr = 2000};

get_god_equip_level(7,3) ->
	#base_god_equip_level{pos = 7,level = 3,cost = [{0,38300107,110}],base_attr_add = [{1,3500},{attr,[{1,14400},{3,4320}]}],extra_attr = 3500};

get_god_equip_level(7,4) ->
	#base_god_equip_level{pos = 7,level = 4,cost = [{0,38300107,180}],base_attr_add = [{1,5000},{attr,[{1,20000},{3,6000}]}],extra_attr = 5000};

get_god_equip_level(7,5) ->
	#base_god_equip_level{pos = 7,level = 5,cost = [{0,38300107,220}],base_attr_add = [{1,6500},{attr,[{1,26400},{3,7920}]}],extra_attr = 6500};

get_god_equip_level(7,6) ->
	#base_god_equip_level{pos = 7,level = 6,cost = [{0,38300107,350}],base_attr_add = [{1,8000},{attr,[{1,33600},{3,10080}]}],extra_attr = 8000};

get_god_equip_level(7,7) ->
	#base_god_equip_level{pos = 7,level = 7,cost = [{0,38300107,500},{0,38300202,1}],base_attr_add = [{1,10000},{attr,[{1,41600},{3,12480}]}],extra_attr = 10000};

get_god_equip_level(7,8) ->
	#base_god_equip_level{pos = 7,level = 8,cost = [{0,38300107,600},{0,38300202,2}],base_attr_add = [{1,12000},{attr,[{1,50400},{3,15120}]}],extra_attr = 12000};

get_god_equip_level(7,9) ->
	#base_god_equip_level{pos = 7,level = 9,cost = [{0,38300107,750},{0,38300202,4}],base_attr_add = [{1,15000},{attr,[{1,60000},{3,18000}]}],extra_attr = 15000};

get_god_equip_level(7,10) ->
	#base_god_equip_level{pos = 7,level = 10,cost = [{0,38300107,800},{0,38300202,8}],base_attr_add = [{1,18000},{attr,[{1,70400},{3,21120}]}],extra_attr = 18000};

get_god_equip_level(7,11) ->
	#base_god_equip_level{pos = 7,level = 11,cost = [{0,38300107,1000},{0,38300202,12}],base_attr_add = [{1,21500},{attr,[{1,80800},{3,24240}]}],extra_attr = 21500};

get_god_equip_level(7,12) ->
	#base_god_equip_level{pos = 7,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{1,92800},{3,27840}]}],extra_attr = 25000};

get_god_equip_level(8,0) ->
	#base_god_equip_level{pos = 8,level = 0,cost = [{0,38300108,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(8,1) ->
	#base_god_equip_level{pos = 8,level = 1,cost = [{0,38300108,35}],base_attr_add = [{1,1000},{attr,[{2,112000},{4,1680}]}],extra_attr = 1000};

get_god_equip_level(8,2) ->
	#base_god_equip_level{pos = 8,level = 2,cost = [{0,38300108,60}],base_attr_add = [{1,2000},{attr,[{2,192000},{4,2880}]}],extra_attr = 2000};

get_god_equip_level(8,3) ->
	#base_god_equip_level{pos = 8,level = 3,cost = [{0,38300108,110}],base_attr_add = [{1,3500},{attr,[{2,288000},{4,4320}]}],extra_attr = 3500};

get_god_equip_level(8,4) ->
	#base_god_equip_level{pos = 8,level = 4,cost = [{0,38300108,180}],base_attr_add = [{1,5000},{attr,[{2,400000},{4,6000}]}],extra_attr = 5000};

get_god_equip_level(8,5) ->
	#base_god_equip_level{pos = 8,level = 5,cost = [{0,38300108,220}],base_attr_add = [{1,6500},{attr,[{2,528000},{4,7920}]}],extra_attr = 6500};

get_god_equip_level(8,6) ->
	#base_god_equip_level{pos = 8,level = 6,cost = [{0,38300108,350}],base_attr_add = [{1,8000},{attr,[{2,672000},{4,10080}]}],extra_attr = 8000};

get_god_equip_level(8,7) ->
	#base_god_equip_level{pos = 8,level = 7,cost = [{0,38300108,500},{0,38300201,1}],base_attr_add = [{1,10000},{attr,[{2,832000},{4,12480}]}],extra_attr = 10000};

get_god_equip_level(8,8) ->
	#base_god_equip_level{pos = 8,level = 8,cost = [{0,38300108,600},{0,38300201,2}],base_attr_add = [{1,12000},{attr,[{2,1008000},{4,15120}]}],extra_attr = 12000};

get_god_equip_level(8,9) ->
	#base_god_equip_level{pos = 8,level = 9,cost = [{0,38300108,750},{0,38300201,4}],base_attr_add = [{1,15000},{attr,[{2,1200000},{4,18000}]}],extra_attr = 15000};

get_god_equip_level(8,10) ->
	#base_god_equip_level{pos = 8,level = 10,cost = [{0,38300108,800},{0,38300201,8}],base_attr_add = [{1,18000},{attr,[{2,1408000},{4,21120}]}],extra_attr = 18000};

get_god_equip_level(8,11) ->
	#base_god_equip_level{pos = 8,level = 11,cost = [{0,38300108,1000},{0,38300201,12}],base_attr_add = [{1,21500},{attr,[{2,1616000},{4,24240}]}],extra_attr = 21500};

get_god_equip_level(8,12) ->
	#base_god_equip_level{pos = 8,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{2,1856000},{4,27840}]}],extra_attr = 25000};

get_god_equip_level(9,0) ->
	#base_god_equip_level{pos = 9,level = 0,cost = [{0,38300109,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(9,1) ->
	#base_god_equip_level{pos = 9,level = 1,cost = [{0,38300109,35}],base_attr_add = [{1,1000},{attr,[{1,5600},{3,1680}]}],extra_attr = 1000};

get_god_equip_level(9,2) ->
	#base_god_equip_level{pos = 9,level = 2,cost = [{0,38300109,60}],base_attr_add = [{1,2000},{attr,[{1,9600},{3,2880}]}],extra_attr = 2000};

get_god_equip_level(9,3) ->
	#base_god_equip_level{pos = 9,level = 3,cost = [{0,38300109,110}],base_attr_add = [{1,3500},{attr,[{1,14400},{3,4320}]}],extra_attr = 3500};

get_god_equip_level(9,4) ->
	#base_god_equip_level{pos = 9,level = 4,cost = [{0,38300109,180}],base_attr_add = [{1,5000},{attr,[{1,20000},{3,6000}]}],extra_attr = 5000};

get_god_equip_level(9,5) ->
	#base_god_equip_level{pos = 9,level = 5,cost = [{0,38300109,220}],base_attr_add = [{1,6500},{attr,[{1,26400},{3,7920}]}],extra_attr = 6500};

get_god_equip_level(9,6) ->
	#base_god_equip_level{pos = 9,level = 6,cost = [{0,38300109,350}],base_attr_add = [{1,8000},{attr,[{1,33600},{3,10080}]}],extra_attr = 8000};

get_god_equip_level(9,7) ->
	#base_god_equip_level{pos = 9,level = 7,cost = [{0,38300109,500},{0,38300202,1}],base_attr_add = [{1,10000},{attr,[{1,41600},{3,12480}]}],extra_attr = 10000};

get_god_equip_level(9,8) ->
	#base_god_equip_level{pos = 9,level = 8,cost = [{0,38300109,600},{0,38300202,2}],base_attr_add = [{1,12000},{attr,[{1,50400},{3,15120}]}],extra_attr = 12000};

get_god_equip_level(9,9) ->
	#base_god_equip_level{pos = 9,level = 9,cost = [{0,38300109,750},{0,38300202,4}],base_attr_add = [{1,15000},{attr,[{1,60000},{3,18000}]}],extra_attr = 15000};

get_god_equip_level(9,10) ->
	#base_god_equip_level{pos = 9,level = 10,cost = [{0,38300109,800},{0,38300202,8}],base_attr_add = [{1,18000},{attr,[{1,70400},{3,21120}]}],extra_attr = 18000};

get_god_equip_level(9,11) ->
	#base_god_equip_level{pos = 9,level = 11,cost = [{0,38300109,1000},{0,38300202,12}],base_attr_add = [{1,21500},{attr,[{1,80800},{3,24240}]}],extra_attr = 21500};

get_god_equip_level(9,12) ->
	#base_god_equip_level{pos = 9,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{1,92800},{3,27840}]}],extra_attr = 25000};

get_god_equip_level(10,0) ->
	#base_god_equip_level{pos = 10,level = 0,cost = [{0,38300110,25}],base_attr_add = [],extra_attr = 0};

get_god_equip_level(10,1) ->
	#base_god_equip_level{pos = 10,level = 1,cost = [{0,38300110,35}],base_attr_add = [{1,1000},{attr,[{2,112000},{4,1680}]}],extra_attr = 1000};

get_god_equip_level(10,2) ->
	#base_god_equip_level{pos = 10,level = 2,cost = [{0,38300110,60}],base_attr_add = [{1,2000},{attr,[{2,192000},{4,2880}]}],extra_attr = 2000};

get_god_equip_level(10,3) ->
	#base_god_equip_level{pos = 10,level = 3,cost = [{0,38300110,110}],base_attr_add = [{1,3500},{attr,[{2,288000},{4,4320}]}],extra_attr = 3500};

get_god_equip_level(10,4) ->
	#base_god_equip_level{pos = 10,level = 4,cost = [{0,38300110,180}],base_attr_add = [{1,5000},{attr,[{2,400000},{4,6000}]}],extra_attr = 5000};

get_god_equip_level(10,5) ->
	#base_god_equip_level{pos = 10,level = 5,cost = [{0,38300110,220}],base_attr_add = [{1,6500},{attr,[{2,528000},{4,7920}]}],extra_attr = 6500};

get_god_equip_level(10,6) ->
	#base_god_equip_level{pos = 10,level = 6,cost = [{0,38300110,350}],base_attr_add = [{1,8000},{attr,[{2,672000},{4,10080}]}],extra_attr = 8000};

get_god_equip_level(10,7) ->
	#base_god_equip_level{pos = 10,level = 7,cost = [{0,38300110,500},{0,38300201,1}],base_attr_add = [{1,10000},{attr,[{2,832000},{4,12480}]}],extra_attr = 10000};

get_god_equip_level(10,8) ->
	#base_god_equip_level{pos = 10,level = 8,cost = [{0,38300110,600},{0,38300201,2}],base_attr_add = [{1,12000},{attr,[{2,1008000},{4,15120}]}],extra_attr = 12000};

get_god_equip_level(10,9) ->
	#base_god_equip_level{pos = 10,level = 9,cost = [{0,38300110,750},{0,38300201,4}],base_attr_add = [{1,15000},{attr,[{2,1200000},{4,18000}]}],extra_attr = 15000};

get_god_equip_level(10,10) ->
	#base_god_equip_level{pos = 10,level = 10,cost = [{0,38300110,800},{0,38300201,8}],base_attr_add = [{1,18000},{attr,[{2,1408000},{4,21120}]}],extra_attr = 18000};

get_god_equip_level(10,11) ->
	#base_god_equip_level{pos = 10,level = 11,cost = [{0,38300110,1000},{0,38300201,12}],base_attr_add = [{1,21500},{attr,[{2,1616000},{4,24240}]}],extra_attr = 21500};

get_god_equip_level(10,12) ->
	#base_god_equip_level{pos = 10,level = 12,cost = [],base_attr_add = [{1,25000},{attr,[{2,1856000},{4,27840}]}],extra_attr = 25000};

get_god_equip_level(_Pos,_Level) ->
	[].

get_all_pos() ->
[1,2,3,4,5,6,7,8,9,10].


get_value(open_lv) ->
371;


get_value(strength_limit) ->
[{stage, 9},{star, 2}];

get_value(_Key) ->
	[].


get_pos_limit(1) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(2) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(3) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(4) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(5) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(6) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(7) ->
[{stage, 7},{star, 2},{color, 4}];


get_pos_limit(8) ->
[{stage, 9},{star, 2},{color, 5}];


get_pos_limit(9) ->
[{stage, 7},{star, 2},{color, 4}];


get_pos_limit(10) ->
[{stage, 9},{star, 2},{color, 5}];

get_pos_limit(_Pos) ->
	[].


get_god_equip_limit(1) ->
9;


get_god_equip_limit(2) ->
9;


get_god_equip_limit(3) ->
9;


get_god_equip_limit(4) ->
9;


get_god_equip_limit(5) ->
9;


get_god_equip_limit(6) ->
9;


get_god_equip_limit(7) ->
7;


get_god_equip_limit(8) ->
9;


get_god_equip_limit(9) ->
7;


get_god_equip_limit(10) ->
9;

get_god_equip_limit(_Pos) ->
	0.

