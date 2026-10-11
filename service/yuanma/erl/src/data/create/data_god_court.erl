%%%---------------------------------------
%%% module      : data_god_court
%%% description : 神庭配置
%%%
%%%---------------------------------------
-module(data_god_court).
-compile(export_all).
-include("god_court.hrl").



get_court(1001) ->
	#base_god_court{id = 1001,name = <<"尚武神社"/utf8>>,condition = [{god_house, 1}],core_pos = 9};

get_court(1002) ->
	#base_god_court{id = 1002,name = <<"神道神社"/utf8>>,condition = [{god_house, 2}],core_pos = 10};

get_court(1003) ->
	#base_god_court{id = 1003,name = <<"月神神社"/utf8>>,condition = [{god_house, 3}],core_pos = 11};

get_court(1004) ->
	#base_god_court{id = 1004,name = <<"火神神社"/utf8>>,condition = [{god_house, 4}],core_pos = 12};

get_court(1005) ->
	#base_god_court{id = 1005,name = <<"八重神社"/utf8>>,condition = [{god_house, 5}],core_pos = 13};

get_court(1006) ->
	#base_god_court{id = 1006,name = <<"须佐神社"/utf8>>,condition = [{god_house, 6}],core_pos = 14};

get_court(1007) ->
	#base_god_court{id = 1007,name = <<"轮回神社"/utf8>>,condition = [{god_house, 7}],core_pos = 15};

get_court(1008) ->
	#base_god_court{id = 1008,name = <<"阴阳神社"/utf8>>,condition = [{god_house, 8}],core_pos = 16};

get_court(_Id) ->
	[].

get_court_ids() ->
[1001,1002,1003,1004,1005,1006,1007,1008].

get_core_pos() ->
[9,10,11,12,13,14,15,16].


get_name_by_core(9) ->
<<"尚武神社"/utf8>>;


get_name_by_core(10) ->
<<"神道神社"/utf8>>;


get_name_by_core(11) ->
<<"月神神社"/utf8>>;


get_name_by_core(12) ->
<<"火神神社"/utf8>>;


get_name_by_core(13) ->
<<"八重神社"/utf8>>;


get_name_by_core(14) ->
<<"须佐神社"/utf8>>;


get_name_by_core(15) ->
<<"轮回神社"/utf8>>;


get_name_by_core(16) ->
<<"阴阳神社"/utf8>>;

get_name_by_core(_Corepos) ->
	[].

get_equip(800110) ->
	#base_god_court_equip{id = 800110,base_attr = [{1,130},{3,65}],rare_attr = [],brilliant_attr = []};

get_equip(800120) ->
	#base_god_court_equip{id = 800120,base_attr = [{1,260},{3,130}],rare_attr = [],brilliant_attr = []};

get_equip(800130) ->
	#base_god_court_equip{id = 800130,base_attr = [{1,521},{3,260}],rare_attr = [],brilliant_attr = []};

get_equip(800140) ->
	#base_god_court_equip{id = 800140,base_attr = [{1,1042},{3,521}],rare_attr = [],brilliant_attr = []};

get_equip(800150) ->
	#base_god_court_equip{id = 800150,base_attr = [{1,2083},{3,1042}],rare_attr = [],brilliant_attr = []};

get_equip(800160) ->
	#base_god_court_equip{id = 800160,base_attr = [{1,4167},{3,2083}],rare_attr = [{17,37}],brilliant_attr = []};

get_equip(800210) ->
	#base_god_court_equip{id = 800210,base_attr = [{1,130},{3,65}],rare_attr = [],brilliant_attr = []};

get_equip(800220) ->
	#base_god_court_equip{id = 800220,base_attr = [{1,260},{3,130}],rare_attr = [],brilliant_attr = []};

get_equip(800230) ->
	#base_god_court_equip{id = 800230,base_attr = [{1,521},{3,260}],rare_attr = [],brilliant_attr = []};

get_equip(800240) ->
	#base_god_court_equip{id = 800240,base_attr = [{1,1042},{3,521}],rare_attr = [],brilliant_attr = []};

get_equip(800250) ->
	#base_god_court_equip{id = 800250,base_attr = [{1,2083},{3,1042}],rare_attr = [],brilliant_attr = []};

get_equip(800260) ->
	#base_god_court_equip{id = 800260,base_attr = [{1,4167},{3,2083}],rare_attr = [{17,37}],brilliant_attr = []};

get_equip(800310) ->
	#base_god_court_equip{id = 800310,base_attr = [{1,130},{3,65}],rare_attr = [],brilliant_attr = []};

get_equip(800320) ->
	#base_god_court_equip{id = 800320,base_attr = [{1,260},{3,130}],rare_attr = [],brilliant_attr = []};

get_equip(800330) ->
	#base_god_court_equip{id = 800330,base_attr = [{1,521},{3,260}],rare_attr = [],brilliant_attr = []};

get_equip(800340) ->
	#base_god_court_equip{id = 800340,base_attr = [{1,1042},{3,521}],rare_attr = [],brilliant_attr = []};

get_equip(800350) ->
	#base_god_court_equip{id = 800350,base_attr = [{1,2083},{3,1042}],rare_attr = [],brilliant_attr = []};

get_equip(800360) ->
	#base_god_court_equip{id = 800360,base_attr = [{1,4167},{3,2083}],rare_attr = [{17,37}],brilliant_attr = []};

get_equip(800410) ->
	#base_god_court_equip{id = 800410,base_attr = [{2,2344},{4,59}],rare_attr = [],brilliant_attr = []};

get_equip(800420) ->
	#base_god_court_equip{id = 800420,base_attr = [{2,4688},{4,117}],rare_attr = [],brilliant_attr = []};

get_equip(800430) ->
	#base_god_court_equip{id = 800430,base_attr = [{2,9375},{4,234}],rare_attr = [],brilliant_attr = []};

get_equip(800440) ->
	#base_god_court_equip{id = 800440,base_attr = [{2,18750},{4,469}],rare_attr = [],brilliant_attr = []};

get_equip(800450) ->
	#base_god_court_equip{id = 800450,base_attr = [{2,37500},{4,938}],rare_attr = [],brilliant_attr = []};

get_equip(800460) ->
	#base_god_court_equip{id = 800460,base_attr = [{2,75000},{4,1875}],rare_attr = [{45,37}],brilliant_attr = []};

get_equip(800510) ->
	#base_god_court_equip{id = 800510,base_attr = [{2,2344},{4,59}],rare_attr = [],brilliant_attr = []};

get_equip(800520) ->
	#base_god_court_equip{id = 800520,base_attr = [{2,4688},{4,117}],rare_attr = [],brilliant_attr = []};

get_equip(800530) ->
	#base_god_court_equip{id = 800530,base_attr = [{2,9375},{4,234}],rare_attr = [],brilliant_attr = []};

get_equip(800540) ->
	#base_god_court_equip{id = 800540,base_attr = [{2,18750},{4,469}],rare_attr = [],brilliant_attr = []};

get_equip(800550) ->
	#base_god_court_equip{id = 800550,base_attr = [{2,37500},{4,938}],rare_attr = [],brilliant_attr = []};

get_equip(800560) ->
	#base_god_court_equip{id = 800560,base_attr = [{2,75000},{4,1875}],rare_attr = [{45,37}],brilliant_attr = []};

get_equip(800610) ->
	#base_god_court_equip{id = 800610,base_attr = [{2,2344},{4,59}],rare_attr = [],brilliant_attr = []};

get_equip(800620) ->
	#base_god_court_equip{id = 800620,base_attr = [{2,4688},{4,117}],rare_attr = [],brilliant_attr = []};

get_equip(800630) ->
	#base_god_court_equip{id = 800630,base_attr = [{2,9375},{4,234}],rare_attr = [],brilliant_attr = []};

get_equip(800640) ->
	#base_god_court_equip{id = 800640,base_attr = [{2,18750},{4,469}],rare_attr = [],brilliant_attr = []};

get_equip(800650) ->
	#base_god_court_equip{id = 800650,base_attr = [{2,37500},{4,938}],rare_attr = [],brilliant_attr = []};

get_equip(800660) ->
	#base_god_court_equip{id = 800660,base_attr = [{2,75000},{4,1875}],rare_attr = [{45,37}],brilliant_attr = []};

get_equip(800710) ->
	#base_god_court_equip{id = 800710,base_attr = [{2,2344},{4,59}],rare_attr = [],brilliant_attr = []};

get_equip(800720) ->
	#base_god_court_equip{id = 800720,base_attr = [{2,4688},{4,117}],rare_attr = [],brilliant_attr = []};

get_equip(800730) ->
	#base_god_court_equip{id = 800730,base_attr = [{2,9375},{4,234}],rare_attr = [],brilliant_attr = []};

get_equip(800740) ->
	#base_god_court_equip{id = 800740,base_attr = [{2,18750},{4,469}],rare_attr = [],brilliant_attr = []};

get_equip(800750) ->
	#base_god_court_equip{id = 800750,base_attr = [{2,37500},{4,938}],rare_attr = [],brilliant_attr = []};

get_equip(800760) ->
	#base_god_court_equip{id = 800760,base_attr = [{2,75000},{4,1875}],rare_attr = [{45,37}],brilliant_attr = []};

get_equip(800810) ->
	#base_god_court_equip{id = 800810,base_attr = [{2,2344},{4,59}],rare_attr = [],brilliant_attr = []};

get_equip(800820) ->
	#base_god_court_equip{id = 800820,base_attr = [{2,4688},{4,117}],rare_attr = [],brilliant_attr = []};

get_equip(800830) ->
	#base_god_court_equip{id = 800830,base_attr = [{2,9375},{4,234}],rare_attr = [],brilliant_attr = []};

get_equip(800840) ->
	#base_god_court_equip{id = 800840,base_attr = [{2,18750},{4,469}],rare_attr = [],brilliant_attr = []};

get_equip(800850) ->
	#base_god_court_equip{id = 800850,base_attr = [{2,37500},{4,938}],rare_attr = [],brilliant_attr = []};

get_equip(800860) ->
	#base_god_court_equip{id = 800860,base_attr = [{2,75000},{4,1875}],rare_attr = [{45,37}],brilliant_attr = []};

get_equip(800950) ->
	#base_god_court_equip{id = 800950,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(800951) ->
	#base_god_court_equip{id = 800951,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(800952) ->
	#base_god_court_equip{id = 800952,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(800953) ->
	#base_god_court_equip{id = 800953,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(800954) ->
	#base_god_court_equip{id = 800954,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(800964) ->
	#base_god_court_equip{id = 800964,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801050) ->
	#base_god_court_equip{id = 801050,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801051) ->
	#base_god_court_equip{id = 801051,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801052) ->
	#base_god_court_equip{id = 801052,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801053) ->
	#base_god_court_equip{id = 801053,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801054) ->
	#base_god_court_equip{id = 801054,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801064) ->
	#base_god_court_equip{id = 801064,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801150) ->
	#base_god_court_equip{id = 801150,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801151) ->
	#base_god_court_equip{id = 801151,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801152) ->
	#base_god_court_equip{id = 801152,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801153) ->
	#base_god_court_equip{id = 801153,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801154) ->
	#base_god_court_equip{id = 801154,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801164) ->
	#base_god_court_equip{id = 801164,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801250) ->
	#base_god_court_equip{id = 801250,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801251) ->
	#base_god_court_equip{id = 801251,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801252) ->
	#base_god_court_equip{id = 801252,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801253) ->
	#base_god_court_equip{id = 801253,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801254) ->
	#base_god_court_equip{id = 801254,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801264) ->
	#base_god_court_equip{id = 801264,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801350) ->
	#base_god_court_equip{id = 801350,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801351) ->
	#base_god_court_equip{id = 801351,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801352) ->
	#base_god_court_equip{id = 801352,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801353) ->
	#base_god_court_equip{id = 801353,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801354) ->
	#base_god_court_equip{id = 801354,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801364) ->
	#base_god_court_equip{id = 801364,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801450) ->
	#base_god_court_equip{id = 801450,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801451) ->
	#base_god_court_equip{id = 801451,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801452) ->
	#base_god_court_equip{id = 801452,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801453) ->
	#base_god_court_equip{id = 801453,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801454) ->
	#base_god_court_equip{id = 801454,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801464) ->
	#base_god_court_equip{id = 801464,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801550) ->
	#base_god_court_equip{id = 801550,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801551) ->
	#base_god_court_equip{id = 801551,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801552) ->
	#base_god_court_equip{id = 801552,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801553) ->
	#base_god_court_equip{id = 801553,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801554) ->
	#base_god_court_equip{id = 801554,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801564) ->
	#base_god_court_equip{id = 801564,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(801650) ->
	#base_god_court_equip{id = 801650,base_attr = [{1,210},{3,106},{2,6303},{4,158}],rare_attr = [],brilliant_attr = [{330,10000}]};

get_equip(801651) ->
	#base_god_court_equip{id = 801651,base_attr = [{1,300},{3,151},{2,9004},{4,225}],rare_attr = [{22,160}],brilliant_attr = [{330,10000}]};

get_equip(801652) ->
	#base_god_court_equip{id = 801652,base_attr = [{1,429},{3,215},{2,12863},{4,321}],rare_attr = [{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801653) ->
	#base_god_court_equip{id = 801653,base_attr = [{1,613},{3,307},{2,18375},{4,459}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{329,10000},{330,10000}]};

get_equip(801654) ->
	#base_god_court_equip{id = 801654,base_attr = [{1,875},{3,438},{2,26250},{4,655}],rare_attr = [{20,160},{21,160},{22,160}],brilliant_attr = [{328,10000},{329,10000},{330,10000}]};

get_equip(801664) ->
	#base_god_court_equip{id = 801664,base_attr = [{1,1250},{3,625},{2,37500},{4,935}],rare_attr = [{19,160},{20,160},{21,160},{22,160}],brilliant_attr = [{327,10000},{328,10000},{329,10000},{330,10000}]};

get_equip(_Id) ->
	[].

get_all_equip() ->
[800110,800120,800130,800140,800150,800160,800210,800220,800230,800240,800250,800260,800310,800320,800330,800340,800350,800360,800410,800420,800430,800440,800450,800460,800510,800520,800530,800540,800550,800560,800610,800620,800630,800640,800650,800660,800710,800720,800730,800740,800750,800760,800810,800820,800830,800840,800850,800860,800950,800951,800952,800953,800954,800964,801050,801051,801052,801053,801054,801064,801150,801151,801152,801153,801154,801164,801250,801251,801252,801253,801254,801264,801350,801351,801352,801353,801354,801364,801450,801451,801452,801453,801454,801464,801550,801551,801552,801553,801554,801564,801650,801651,801652,801653,801654,801664].

get_court_strength(0) ->
	#base_god_court_strength{lv = 0,cost = [{255,36255098,10}],attr = [{1,250},{3,130},{2,7500},{4,190}]};

get_court_strength(1) ->
	#base_god_court_strength{lv = 1,cost = [{255,36255098,11}],attr = [{1,275},{3,143},{2,8250},{4,209}]};

get_court_strength(2) ->
	#base_god_court_strength{lv = 2,cost = [{255,36255098,12}],attr = [{1,300},{3,156},{2,9000},{4,228}]};

get_court_strength(3) ->
	#base_god_court_strength{lv = 3,cost = [{255,36255098,13}],attr = [{1,325},{3,169},{2,9750},{4,247}]};

get_court_strength(4) ->
	#base_god_court_strength{lv = 4,cost = [{255,36255098,14}],attr = [{1,350},{3,182},{2,10500},{4,266}]};

get_court_strength(5) ->
	#base_god_court_strength{lv = 5,cost = [{255,36255098,16}],attr = [{1,375},{3,195},{2,11250},{4,285}]};

get_court_strength(6) ->
	#base_god_court_strength{lv = 6,cost = [{255,36255098,18}],attr = [{1,400},{3,208},{2,12000},{4,304}]};

get_court_strength(7) ->
	#base_god_court_strength{lv = 7,cost = [{255,36255098,20}],attr = [{1,425},{3,221},{2,12750},{4,323}]};

get_court_strength(8) ->
	#base_god_court_strength{lv = 8,cost = [{255,36255098,22}],attr = [{1,450},{3,234},{2,13500},{4,342}]};

get_court_strength(9) ->
	#base_god_court_strength{lv = 9,cost = [{255,36255098,24}],attr = [{1,475},{3,247},{2,14250},{4,361}]};

get_court_strength(10) ->
	#base_god_court_strength{lv = 10,cost = [{255,36255098,26}],attr = [{1,500},{3,260},{2,15000},{4,380}]};

get_court_strength(11) ->
	#base_god_court_strength{lv = 11,cost = [{255,36255098,28}],attr = [{1,525},{3,273},{2,15750},{4,399}]};

get_court_strength(12) ->
	#base_god_court_strength{lv = 12,cost = [{255,36255098,30}],attr = [{1,550},{3,286},{2,16500},{4,418}]};

get_court_strength(13) ->
	#base_god_court_strength{lv = 13,cost = [{255,36255098,33}],attr = [{1,575},{3,299},{2,17250},{4,437}]};

get_court_strength(14) ->
	#base_god_court_strength{lv = 14,cost = [{255,36255098,36}],attr = [{1,600},{3,312},{2,18000},{4,456}]};

get_court_strength(15) ->
	#base_god_court_strength{lv = 15,cost = [{255,36255098,39}],attr = [{1,625},{3,325},{2,18750},{4,475}]};

get_court_strength(16) ->
	#base_god_court_strength{lv = 16,cost = [{255,36255098,42}],attr = [{1,650},{3,338},{2,19500},{4,494}]};

get_court_strength(17) ->
	#base_god_court_strength{lv = 17,cost = [{255,36255098,45}],attr = [{1,675},{3,351},{2,20250},{4,513}]};

get_court_strength(18) ->
	#base_god_court_strength{lv = 18,cost = [{255,36255098,48}],attr = [{1,700},{3,364},{2,21000},{4,532}]};

get_court_strength(19) ->
	#base_god_court_strength{lv = 19,cost = [{255,36255098,51}],attr = [{1,725},{3,377},{2,21750},{4,551}]};

get_court_strength(20) ->
	#base_god_court_strength{lv = 20,cost = [{255,36255098,54}],attr = [{1,750},{3,390},{2,22500},{4,570}]};

get_court_strength(21) ->
	#base_god_court_strength{lv = 21,cost = [{255,36255098,58}],attr = [{1,775},{3,403},{2,23250},{4,589}]};

get_court_strength(22) ->
	#base_god_court_strength{lv = 22,cost = [{255,36255098,62}],attr = [{1,800},{3,416},{2,24000},{4,608}]};

get_court_strength(23) ->
	#base_god_court_strength{lv = 23,cost = [{255,36255098,66}],attr = [{1,825},{3,429},{2,24750},{4,627}]};

get_court_strength(24) ->
	#base_god_court_strength{lv = 24,cost = [{255,36255098,70}],attr = [{1,850},{3,442},{2,25500},{4,646}]};

get_court_strength(25) ->
	#base_god_court_strength{lv = 25,cost = [{255,36255098,74}],attr = [{1,875},{3,455},{2,26250},{4,665}]};

get_court_strength(26) ->
	#base_god_court_strength{lv = 26,cost = [{255,36255098,78}],attr = [{1,900},{3,468},{2,27000},{4,684}]};

get_court_strength(27) ->
	#base_god_court_strength{lv = 27,cost = [{255,36255098,82}],attr = [{1,925},{3,481},{2,27750},{4,703}]};

get_court_strength(28) ->
	#base_god_court_strength{lv = 28,cost = [{255,36255098,86}],attr = [{1,950},{3,494},{2,28500},{4,722}]};

get_court_strength(29) ->
	#base_god_court_strength{lv = 29,cost = [{255,36255098,91}],attr = [{1,975},{3,507},{2,29250},{4,741}]};

get_court_strength(30) ->
	#base_god_court_strength{lv = 30,cost = [{255,36255098,96}],attr = [{1,1000},{3,520},{2,30000},{4,760}]};

get_court_strength(31) ->
	#base_god_court_strength{lv = 31,cost = [{255,36255098,101}],attr = [{1,1025},{3,533},{2,30750},{4,779}]};

get_court_strength(32) ->
	#base_god_court_strength{lv = 32,cost = [{255,36255098,106}],attr = [{1,1050},{3,546},{2,31500},{4,798}]};

get_court_strength(33) ->
	#base_god_court_strength{lv = 33,cost = [{255,36255098,111}],attr = [{1,1075},{3,559},{2,32250},{4,817}]};

get_court_strength(34) ->
	#base_god_court_strength{lv = 34,cost = [{255,36255098,116}],attr = [{1,1100},{3,572},{2,33000},{4,836}]};

get_court_strength(35) ->
	#base_god_court_strength{lv = 35,cost = [{255,36255098,121}],attr = [{1,1125},{3,585},{2,33750},{4,855}]};

get_court_strength(36) ->
	#base_god_court_strength{lv = 36,cost = [{255,36255098,126}],attr = [{1,1150},{3,598},{2,34500},{4,874}]};

get_court_strength(37) ->
	#base_god_court_strength{lv = 37,cost = [{255,36255098,132}],attr = [{1,1175},{3,611},{2,35250},{4,893}]};

get_court_strength(38) ->
	#base_god_court_strength{lv = 38,cost = [{255,36255098,138}],attr = [{1,1200},{3,624},{2,36000},{4,912}]};

get_court_strength(39) ->
	#base_god_court_strength{lv = 39,cost = [{255,36255098,144}],attr = [{1,1225},{3,637},{2,36750},{4,931}]};

get_court_strength(40) ->
	#base_god_court_strength{lv = 40,cost = [{255,36255098,150}],attr = [{1,1250},{3,650},{2,37500},{4,950}]};

get_court_strength(41) ->
	#base_god_court_strength{lv = 41,cost = [{255,36255098,156}],attr = [{1,1275},{3,663},{2,38250},{4,969}]};

get_court_strength(42) ->
	#base_god_court_strength{lv = 42,cost = [{255,36255098,162}],attr = [{1,1300},{3,676},{2,39000},{4,988}]};

get_court_strength(43) ->
	#base_god_court_strength{lv = 43,cost = [{255,36255098,168}],attr = [{1,1325},{3,689},{2,39750},{4,1007}]};

get_court_strength(44) ->
	#base_god_court_strength{lv = 44,cost = [{255,36255098,174}],attr = [{1,1350},{3,702},{2,40500},{4,1026}]};

get_court_strength(45) ->
	#base_god_court_strength{lv = 45,cost = [{255,36255098,181}],attr = [{1,1375},{3,715},{2,41250},{4,1045}]};

get_court_strength(46) ->
	#base_god_court_strength{lv = 46,cost = [{255,36255098,188}],attr = [{1,1400},{3,728},{2,42000},{4,1064}]};

get_court_strength(47) ->
	#base_god_court_strength{lv = 47,cost = [{255,36255098,195}],attr = [{1,1425},{3,741},{2,42750},{4,1083}]};

get_court_strength(48) ->
	#base_god_court_strength{lv = 48,cost = [{255,36255098,202}],attr = [{1,1450},{3,754},{2,43500},{4,1102}]};

get_court_strength(49) ->
	#base_god_court_strength{lv = 49,cost = [{255,36255098,209}],attr = [{1,1475},{3,767},{2,44250},{4,1121}]};

get_court_strength(50) ->
	#base_god_court_strength{lv = 50,cost = [{255,36255098,259}],attr = [{1,1500},{3,780},{2,45000},{4,1140}]};

get_court_strength(51) ->
	#base_god_court_strength{lv = 51,cost = [{255,36255098,268}],attr = [{1,1525},{3,793},{2,45750},{4,1159}]};

get_court_strength(52) ->
	#base_god_court_strength{lv = 52,cost = [{255,36255098,276}],attr = [{1,1550},{3,806},{2,46500},{4,1178}]};

get_court_strength(53) ->
	#base_god_court_strength{lv = 53,cost = [{255,36255098,286}],attr = [{1,1575},{3,819},{2,47250},{4,1197}]};

get_court_strength(54) ->
	#base_god_court_strength{lv = 54,cost = [{255,36255098,295}],attr = [{1,1600},{3,832},{2,48000},{4,1216}]};

get_court_strength(55) ->
	#base_god_court_strength{lv = 55,cost = [{255,36255098,305}],attr = [{1,1625},{3,845},{2,48750},{4,1235}]};

get_court_strength(56) ->
	#base_god_court_strength{lv = 56,cost = [{255,36255098,314}],attr = [{1,1650},{3,858},{2,49500},{4,1254}]};

get_court_strength(57) ->
	#base_god_court_strength{lv = 57,cost = [{255,36255098,324}],attr = [{1,1675},{3,871},{2,50250},{4,1273}]};

get_court_strength(58) ->
	#base_god_court_strength{lv = 58,cost = [{255,36255098,334}],attr = [{1,1700},{3,884},{2,51000},{4,1292}]};

get_court_strength(59) ->
	#base_god_court_strength{lv = 59,cost = [{255,36255098,343}],attr = [{1,1725},{3,897},{2,51750},{4,1311}]};

get_court_strength(60) ->
	#base_god_court_strength{lv = 60,cost = [{255,36255098,353}],attr = [{1,1750},{3,910},{2,52500},{4,1330}]};

get_court_strength(61) ->
	#base_god_court_strength{lv = 61,cost = [{255,36255098,364}],attr = [{1,1775},{3,923},{2,53250},{4,1349}]};

get_court_strength(62) ->
	#base_god_court_strength{lv = 62,cost = [{255,36255098,374}],attr = [{1,1800},{3,936},{2,54000},{4,1368}]};

get_court_strength(63) ->
	#base_god_court_strength{lv = 63,cost = [{255,36255098,385}],attr = [{1,1825},{3,949},{2,54750},{4,1387}]};

get_court_strength(64) ->
	#base_god_court_strength{lv = 64,cost = [{255,36255098,396}],attr = [{1,1850},{3,962},{2,55500},{4,1406}]};

get_court_strength(65) ->
	#base_god_court_strength{lv = 65,cost = [{255,36255098,407}],attr = [{1,1875},{3,975},{2,56250},{4,1425}]};

get_court_strength(66) ->
	#base_god_court_strength{lv = 66,cost = [{255,36255098,418}],attr = [{1,1900},{3,988},{2,57000},{4,1444}]};

get_court_strength(67) ->
	#base_god_court_strength{lv = 67,cost = [{255,36255098,428}],attr = [{1,1925},{3,1001},{2,57750},{4,1463}]};

get_court_strength(68) ->
	#base_god_court_strength{lv = 68,cost = [{255,36255098,439}],attr = [{1,1950},{3,1014},{2,58500},{4,1482}]};

get_court_strength(69) ->
	#base_god_court_strength{lv = 69,cost = [{255,36255098,451}],attr = [{1,1975},{3,1027},{2,59250},{4,1501}]};

get_court_strength(70) ->
	#base_god_court_strength{lv = 70,cost = [{255,36255098,463}],attr = [{1,2000},{3,1040},{2,60000},{4,1520}]};

get_court_strength(71) ->
	#base_god_court_strength{lv = 71,cost = [{255,36255098,475}],attr = [{1,2025},{3,1053},{2,60750},{4,1539}]};

get_court_strength(72) ->
	#base_god_court_strength{lv = 72,cost = [{255,36255098,487}],attr = [{1,2050},{3,1066},{2,61500},{4,1558}]};

get_court_strength(73) ->
	#base_god_court_strength{lv = 73,cost = [{255,36255098,499}],attr = [{1,2075},{3,1079},{2,62250},{4,1577}]};

get_court_strength(74) ->
	#base_god_court_strength{lv = 74,cost = [{255,36255098,511}],attr = [{1,2100},{3,1092},{2,63000},{4,1596}]};

get_court_strength(75) ->
	#base_god_court_strength{lv = 75,cost = [{255,36255098,523}],attr = [{1,2125},{3,1105},{2,63750},{4,1615}]};

get_court_strength(76) ->
	#base_god_court_strength{lv = 76,cost = [{255,36255098,535}],attr = [{1,2150},{3,1118},{2,64500},{4,1634}]};

get_court_strength(77) ->
	#base_god_court_strength{lv = 77,cost = [{255,36255098,548}],attr = [{1,2175},{3,1131},{2,65250},{4,1653}]};

get_court_strength(78) ->
	#base_god_court_strength{lv = 78,cost = [{255,36255098,562}],attr = [{1,2200},{3,1144},{2,66000},{4,1672}]};

get_court_strength(79) ->
	#base_god_court_strength{lv = 79,cost = [{255,36255098,575}],attr = [{1,2225},{3,1157},{2,66750},{4,1691}]};

get_court_strength(80) ->
	#base_god_court_strength{lv = 80,cost = [{255,36255098,588}],attr = [{1,2250},{3,1170},{2,67500},{4,1710}]};

get_court_strength(81) ->
	#base_god_court_strength{lv = 81,cost = [{255,36255098,601}],attr = [{1,2275},{3,1183},{2,68250},{4,1729}]};

get_court_strength(82) ->
	#base_god_court_strength{lv = 82,cost = [{255,36255098,614}],attr = [{1,2300},{3,1196},{2,69000},{4,1748}]};

get_court_strength(83) ->
	#base_god_court_strength{lv = 83,cost = [{255,36255098,628}],attr = [{1,2325},{3,1209},{2,69750},{4,1767}]};

get_court_strength(84) ->
	#base_god_court_strength{lv = 84,cost = [{255,36255098,641}],attr = [{1,2350},{3,1222},{2,70500},{4,1786}]};

get_court_strength(85) ->
	#base_god_court_strength{lv = 85,cost = [{255,36255098,655}],attr = [{1,2375},{3,1235},{2,71250},{4,1805}]};

get_court_strength(86) ->
	#base_god_court_strength{lv = 86,cost = [{255,36255098,670}],attr = [{1,2400},{3,1248},{2,72000},{4,1824}]};

get_court_strength(87) ->
	#base_god_court_strength{lv = 87,cost = [{255,36255098,684}],attr = [{1,2425},{3,1261},{2,72750},{4,1843}]};

get_court_strength(88) ->
	#base_god_court_strength{lv = 88,cost = [{255,36255098,698}],attr = [{1,2450},{3,1274},{2,73500},{4,1862}]};

get_court_strength(89) ->
	#base_god_court_strength{lv = 89,cost = [{255,36255098,713}],attr = [{1,2475},{3,1287},{2,74250},{4,1881}]};

get_court_strength(90) ->
	#base_god_court_strength{lv = 90,cost = [{255,36255098,727}],attr = [{1,2500},{3,1300},{2,75000},{4,1900}]};

get_court_strength(91) ->
	#base_god_court_strength{lv = 91,cost = [{255,36255098,742}],attr = [{1,2525},{3,1313},{2,75750},{4,1919}]};

get_court_strength(92) ->
	#base_god_court_strength{lv = 92,cost = [{255,36255098,756}],attr = [{1,2550},{3,1326},{2,76500},{4,1938}]};

get_court_strength(93) ->
	#base_god_court_strength{lv = 93,cost = [{255,36255098,772}],attr = [{1,2575},{3,1339},{2,77250},{4,1957}]};

get_court_strength(94) ->
	#base_god_court_strength{lv = 94,cost = [{255,36255098,787}],attr = [{1,2600},{3,1352},{2,78000},{4,1976}]};

get_court_strength(95) ->
	#base_god_court_strength{lv = 95,cost = [{255,36255098,803}],attr = [{1,2625},{3,1365},{2,78750},{4,1995}]};

get_court_strength(96) ->
	#base_god_court_strength{lv = 96,cost = [{255,36255098,818}],attr = [{1,2650},{3,1378},{2,79500},{4,2014}]};

get_court_strength(97) ->
	#base_god_court_strength{lv = 97,cost = [{255,36255098,834}],attr = [{1,2675},{3,1391},{2,80250},{4,2033}]};

get_court_strength(98) ->
	#base_god_court_strength{lv = 98,cost = [{255,36255098,850}],attr = [{1,2700},{3,1404},{2,81000},{4,2052}]};

get_court_strength(99) ->
	#base_god_court_strength{lv = 99,cost = [{255,36255098,865}],attr = [{1,2725},{3,1417},{2,81750},{4,2071}]};

get_court_strength(100) ->
	#base_god_court_strength{lv = 100,cost = [{255,36255098,881}],attr = [{1,2750},{3,1430},{2,82500},{4,2090}]};

get_court_strength(101) ->
	#base_god_court_strength{lv = 101,cost = [{255,36255098,898}],attr = [{1,2775},{3,1443},{2,83250},{4,2109}]};

get_court_strength(102) ->
	#base_god_court_strength{lv = 102,cost = [{255,36255098,914}],attr = [{1,2800},{3,1456},{2,84000},{4,2128}]};

get_court_strength(103) ->
	#base_god_court_strength{lv = 103,cost = [{255,36255098,931}],attr = [{1,2825},{3,1469},{2,84750},{4,2147}]};

get_court_strength(104) ->
	#base_god_court_strength{lv = 104,cost = [{255,36255098,948}],attr = [{1,2850},{3,1482},{2,85500},{4,2166}]};

get_court_strength(105) ->
	#base_god_court_strength{lv = 105,cost = [{255,36255098,965}],attr = [{1,2875},{3,1495},{2,86250},{4,2185}]};

get_court_strength(106) ->
	#base_god_court_strength{lv = 106,cost = [{255,36255098,982}],attr = [{1,2900},{3,1508},{2,87000},{4,2204}]};

get_court_strength(107) ->
	#base_god_court_strength{lv = 107,cost = [{255,36255098,998}],attr = [{1,2925},{3,1521},{2,87750},{4,2223}]};

get_court_strength(108) ->
	#base_god_court_strength{lv = 108,cost = [{255,36255098,1015}],attr = [{1,2950},{3,1534},{2,88500},{4,2242}]};

get_court_strength(109) ->
	#base_god_court_strength{lv = 109,cost = [{255,36255098,1033}],attr = [{1,2975},{3,1547},{2,89250},{4,2261}]};

get_court_strength(110) ->
	#base_god_court_strength{lv = 110,cost = [{255,36255098,1051}],attr = [{1,3000},{3,1560},{2,90000},{4,2280}]};

get_court_strength(111) ->
	#base_god_court_strength{lv = 111,cost = [{255,36255098,1069}],attr = [{1,3025},{3,1573},{2,90750},{4,2299}]};

get_court_strength(112) ->
	#base_god_court_strength{lv = 112,cost = [{255,36255098,1087}],attr = [{1,3050},{3,1586},{2,91500},{4,2318}]};

get_court_strength(113) ->
	#base_god_court_strength{lv = 113,cost = [{255,36255098,1105}],attr = [{1,3075},{3,1599},{2,92250},{4,2337}]};

get_court_strength(114) ->
	#base_god_court_strength{lv = 114,cost = [{255,36255098,1123}],attr = [{1,3100},{3,1612},{2,93000},{4,2356}]};

get_court_strength(115) ->
	#base_god_court_strength{lv = 115,cost = [{255,36255098,1141}],attr = [{1,3125},{3,1625},{2,93750},{4,2375}]};

get_court_strength(116) ->
	#base_god_court_strength{lv = 116,cost = [{255,36255098,1159}],attr = [{1,3150},{3,1638},{2,94500},{4,2394}]};

get_court_strength(117) ->
	#base_god_court_strength{lv = 117,cost = [{255,36255098,1178}],attr = [{1,3175},{3,1651},{2,95250},{4,2413}]};

get_court_strength(118) ->
	#base_god_court_strength{lv = 118,cost = [{255,36255098,1198}],attr = [{1,3200},{3,1664},{2,96000},{4,2432}]};

get_court_strength(119) ->
	#base_god_court_strength{lv = 119,cost = [{255,36255098,1217}],attr = [{1,3225},{3,1677},{2,96750},{4,2451}]};

get_court_strength(120) ->
	#base_god_court_strength{lv = 120,cost = [{255,36255098,1222}],attr = [{1,3250},{3,1690},{2,97500},{4,2470}]};

get_court_strength(121) ->
	#base_god_court_strength{lv = 121,cost = [{255,36255098,1226}],attr = [{1,3275},{3,1703},{2,98250},{4,2489}]};

get_court_strength(122) ->
	#base_god_court_strength{lv = 122,cost = [{255,36255098,1231}],attr = [{1,3300},{3,1716},{2,99000},{4,2508}]};

get_court_strength(123) ->
	#base_god_court_strength{lv = 123,cost = [{255,36255098,1236}],attr = [{1,3325},{3,1729},{2,99750},{4,2527}]};

get_court_strength(124) ->
	#base_god_court_strength{lv = 124,cost = [{255,36255098,1241}],attr = [{1,3350},{3,1742},{2,100500},{4,2546}]};

get_court_strength(125) ->
	#base_god_court_strength{lv = 125,cost = [{255,36255098,1246}],attr = [{1,3375},{3,1755},{2,101250},{4,2565}]};

get_court_strength(126) ->
	#base_god_court_strength{lv = 126,cost = [{255,36255098,1250}],attr = [{1,3400},{3,1768},{2,102000},{4,2584}]};

get_court_strength(127) ->
	#base_god_court_strength{lv = 127,cost = [{255,36255098,1255}],attr = [{1,3425},{3,1781},{2,102750},{4,2603}]};

get_court_strength(128) ->
	#base_god_court_strength{lv = 128,cost = [{255,36255098,1260}],attr = [{1,3450},{3,1794},{2,103500},{4,2622}]};

get_court_strength(129) ->
	#base_god_court_strength{lv = 129,cost = [{255,36255098,1265}],attr = [{1,3475},{3,1807},{2,104250},{4,2641}]};

get_court_strength(130) ->
	#base_god_court_strength{lv = 130,cost = [{255,36255098,1270}],attr = [{1,3500},{3,1820},{2,105000},{4,2660}]};

get_court_strength(131) ->
	#base_god_court_strength{lv = 131,cost = [{255,36255098,1274}],attr = [{1,3525},{3,1833},{2,105750},{4,2679}]};

get_court_strength(132) ->
	#base_god_court_strength{lv = 132,cost = [{255,36255098,1279}],attr = [{1,3550},{3,1846},{2,106500},{4,2698}]};

get_court_strength(133) ->
	#base_god_court_strength{lv = 133,cost = [{255,36255098,1284}],attr = [{1,3575},{3,1859},{2,107250},{4,2717}]};

get_court_strength(134) ->
	#base_god_court_strength{lv = 134,cost = [{255,36255098,1289}],attr = [{1,3600},{3,1872},{2,108000},{4,2736}]};

get_court_strength(135) ->
	#base_god_court_strength{lv = 135,cost = [{255,36255098,1294}],attr = [{1,3625},{3,1885},{2,108750},{4,2755}]};

get_court_strength(136) ->
	#base_god_court_strength{lv = 136,cost = [{255,36255098,1298}],attr = [{1,3650},{3,1898},{2,109500},{4,2774}]};

get_court_strength(137) ->
	#base_god_court_strength{lv = 137,cost = [{255,36255098,1303}],attr = [{1,3675},{3,1911},{2,110250},{4,2793}]};

get_court_strength(138) ->
	#base_god_court_strength{lv = 138,cost = [{255,36255098,1308}],attr = [{1,3700},{3,1924},{2,111000},{4,2812}]};

get_court_strength(139) ->
	#base_god_court_strength{lv = 139,cost = [{255,36255098,1313}],attr = [{1,3725},{3,1937},{2,111750},{4,2831}]};

get_court_strength(140) ->
	#base_god_court_strength{lv = 140,cost = [{255,36255098,1318}],attr = [{1,3750},{3,1950},{2,112500},{4,2850}]};

get_court_strength(141) ->
	#base_god_court_strength{lv = 141,cost = [{255,36255098,1322}],attr = [{1,3775},{3,1963},{2,113250},{4,2869}]};

get_court_strength(142) ->
	#base_god_court_strength{lv = 142,cost = [{255,36255098,1327}],attr = [{1,3800},{3,1976},{2,114000},{4,2888}]};

get_court_strength(143) ->
	#base_god_court_strength{lv = 143,cost = [{255,36255098,1332}],attr = [{1,3825},{3,1989},{2,114750},{4,2907}]};

get_court_strength(144) ->
	#base_god_court_strength{lv = 144,cost = [{255,36255098,1337}],attr = [{1,3850},{3,2002},{2,115500},{4,2926}]};

get_court_strength(145) ->
	#base_god_court_strength{lv = 145,cost = [{255,36255098,1342}],attr = [{1,3875},{3,2015},{2,116250},{4,2945}]};

get_court_strength(146) ->
	#base_god_court_strength{lv = 146,cost = [{255,36255098,1346}],attr = [{1,3900},{3,2028},{2,117000},{4,2964}]};

get_court_strength(147) ->
	#base_god_court_strength{lv = 147,cost = [{255,36255098,1351}],attr = [{1,3925},{3,2041},{2,117750},{4,2983}]};

get_court_strength(148) ->
	#base_god_court_strength{lv = 148,cost = [{255,36255098,1356}],attr = [{1,3950},{3,2054},{2,118500},{4,3002}]};

get_court_strength(149) ->
	#base_god_court_strength{lv = 149,cost = [{255,36255098,1361}],attr = [{1,3975},{3,2067},{2,119250},{4,3021}]};

get_court_strength(150) ->
	#base_god_court_strength{lv = 150,cost = [{255,36255098,1366}],attr = [{1,4000},{3,2080},{2,120000},{4,3040}]};

get_court_strength(151) ->
	#base_god_court_strength{lv = 151,cost = [{255,36255098,1370}],attr = [{1,4025},{3,2093},{2,120750},{4,3059}]};

get_court_strength(152) ->
	#base_god_court_strength{lv = 152,cost = [{255,36255098,1375}],attr = [{1,4050},{3,2106},{2,121500},{4,3078}]};

get_court_strength(153) ->
	#base_god_court_strength{lv = 153,cost = [{255,36255098,1380}],attr = [{1,4075},{3,2119},{2,122250},{4,3097}]};

get_court_strength(154) ->
	#base_god_court_strength{lv = 154,cost = [{255,36255098,1385}],attr = [{1,4100},{3,2132},{2,123000},{4,3116}]};

get_court_strength(155) ->
	#base_god_court_strength{lv = 155,cost = [{255,36255098,1390}],attr = [{1,4125},{3,2145},{2,123750},{4,3135}]};

get_court_strength(156) ->
	#base_god_court_strength{lv = 156,cost = [{255,36255098,1394}],attr = [{1,4150},{3,2158},{2,124500},{4,3154}]};

get_court_strength(157) ->
	#base_god_court_strength{lv = 157,cost = [{255,36255098,1399}],attr = [{1,4175},{3,2171},{2,125250},{4,3173}]};

get_court_strength(158) ->
	#base_god_court_strength{lv = 158,cost = [{255,36255098,1404}],attr = [{1,4200},{3,2184},{2,126000},{4,3192}]};

get_court_strength(159) ->
	#base_god_court_strength{lv = 159,cost = [{255,36255098,1409}],attr = [{1,4225},{3,2197},{2,126750},{4,3211}]};

get_court_strength(160) ->
	#base_god_court_strength{lv = 160,cost = [{255,36255098,1414}],attr = [{1,4250},{3,2210},{2,127500},{4,3230}]};

get_court_strength(161) ->
	#base_god_court_strength{lv = 161,cost = [{255,36255098,1418}],attr = [{1,4275},{3,2223},{2,128250},{4,3249}]};

get_court_strength(162) ->
	#base_god_court_strength{lv = 162,cost = [{255,36255098,1423}],attr = [{1,4300},{3,2236},{2,129000},{4,3268}]};

get_court_strength(163) ->
	#base_god_court_strength{lv = 163,cost = [{255,36255098,1428}],attr = [{1,4325},{3,2249},{2,129750},{4,3287}]};

get_court_strength(164) ->
	#base_god_court_strength{lv = 164,cost = [{255,36255098,1433}],attr = [{1,4350},{3,2262},{2,130500},{4,3306}]};

get_court_strength(165) ->
	#base_god_court_strength{lv = 165,cost = [{255,36255098,1438}],attr = [{1,4375},{3,2275},{2,131250},{4,3325}]};

get_court_strength(166) ->
	#base_god_court_strength{lv = 166,cost = [{255,36255098,1442}],attr = [{1,4400},{3,2288},{2,132000},{4,3344}]};

get_court_strength(167) ->
	#base_god_court_strength{lv = 167,cost = [{255,36255098,1447}],attr = [{1,4425},{3,2301},{2,132750},{4,3363}]};

get_court_strength(168) ->
	#base_god_court_strength{lv = 168,cost = [{255,36255098,1452}],attr = [{1,4450},{3,2314},{2,133500},{4,3382}]};

get_court_strength(169) ->
	#base_god_court_strength{lv = 169,cost = [{255,36255098,1457}],attr = [{1,4475},{3,2327},{2,134250},{4,3401}]};

get_court_strength(170) ->
	#base_god_court_strength{lv = 170,cost = [{255,36255098,1462}],attr = [{1,4500},{3,2340},{2,135000},{4,3420}]};

get_court_strength(171) ->
	#base_god_court_strength{lv = 171,cost = [{255,36255098,1466}],attr = [{1,4525},{3,2353},{2,135750},{4,3439}]};

get_court_strength(172) ->
	#base_god_court_strength{lv = 172,cost = [{255,36255098,1471}],attr = [{1,4550},{3,2366},{2,136500},{4,3458}]};

get_court_strength(173) ->
	#base_god_court_strength{lv = 173,cost = [{255,36255098,1476}],attr = [{1,4575},{3,2379},{2,137250},{4,3477}]};

get_court_strength(174) ->
	#base_god_court_strength{lv = 174,cost = [{255,36255098,1481}],attr = [{1,4600},{3,2392},{2,138000},{4,3496}]};

get_court_strength(175) ->
	#base_god_court_strength{lv = 175,cost = [{255,36255098,1486}],attr = [{1,4625},{3,2405},{2,138750},{4,3515}]};

get_court_strength(176) ->
	#base_god_court_strength{lv = 176,cost = [{255,36255098,1490}],attr = [{1,4650},{3,2418},{2,139500},{4,3534}]};

get_court_strength(177) ->
	#base_god_court_strength{lv = 177,cost = [{255,36255098,1495}],attr = [{1,4675},{3,2431},{2,140250},{4,3553}]};

get_court_strength(178) ->
	#base_god_court_strength{lv = 178,cost = [{255,36255098,1500}],attr = [{1,4700},{3,2444},{2,141000},{4,3572}]};

get_court_strength(179) ->
	#base_god_court_strength{lv = 179,cost = [{255,36255098,1505}],attr = [{1,4725},{3,2457},{2,141750},{4,3591}]};

get_court_strength(180) ->
	#base_god_court_strength{lv = 180,cost = [{255,36255098,1510}],attr = [{1,4750},{3,2470},{2,142500},{4,3610}]};

get_court_strength(181) ->
	#base_god_court_strength{lv = 181,cost = [{255,36255098,1514}],attr = [{1,4775},{3,2483},{2,143250},{4,3629}]};

get_court_strength(182) ->
	#base_god_court_strength{lv = 182,cost = [{255,36255098,1519}],attr = [{1,4800},{3,2496},{2,144000},{4,3648}]};

get_court_strength(183) ->
	#base_god_court_strength{lv = 183,cost = [{255,36255098,1524}],attr = [{1,4825},{3,2509},{2,144750},{4,3667}]};

get_court_strength(184) ->
	#base_god_court_strength{lv = 184,cost = [{255,36255098,1529}],attr = [{1,4850},{3,2522},{2,145500},{4,3686}]};

get_court_strength(185) ->
	#base_god_court_strength{lv = 185,cost = [{255,36255098,1534}],attr = [{1,4875},{3,2535},{2,146250},{4,3705}]};

get_court_strength(186) ->
	#base_god_court_strength{lv = 186,cost = [{255,36255098,1538}],attr = [{1,4900},{3,2548},{2,147000},{4,3724}]};

get_court_strength(187) ->
	#base_god_court_strength{lv = 187,cost = [{255,36255098,1543}],attr = [{1,4925},{3,2561},{2,147750},{4,3743}]};

get_court_strength(188) ->
	#base_god_court_strength{lv = 188,cost = [{255,36255098,1548}],attr = [{1,4950},{3,2574},{2,148500},{4,3762}]};

get_court_strength(189) ->
	#base_god_court_strength{lv = 189,cost = [{255,36255098,1553}],attr = [{1,4975},{3,2587},{2,149250},{4,3781}]};

get_court_strength(190) ->
	#base_god_court_strength{lv = 190,cost = [{255,36255098,1558}],attr = [{1,5000},{3,2600},{2,150000},{4,3800}]};

get_court_strength(191) ->
	#base_god_court_strength{lv = 191,cost = [{255,36255098,1562}],attr = [{1,5025},{3,2613},{2,150750},{4,3819}]};

get_court_strength(192) ->
	#base_god_court_strength{lv = 192,cost = [{255,36255098,1567}],attr = [{1,5050},{3,2626},{2,151500},{4,3838}]};

get_court_strength(193) ->
	#base_god_court_strength{lv = 193,cost = [{255,36255098,1572}],attr = [{1,5075},{3,2639},{2,152250},{4,3857}]};

get_court_strength(194) ->
	#base_god_court_strength{lv = 194,cost = [{255,36255098,1577}],attr = [{1,5100},{3,2652},{2,153000},{4,3876}]};

get_court_strength(195) ->
	#base_god_court_strength{lv = 195,cost = [{255,36255098,1582}],attr = [{1,5125},{3,2665},{2,153750},{4,3895}]};

get_court_strength(196) ->
	#base_god_court_strength{lv = 196,cost = [{255,36255098,1586}],attr = [{1,5150},{3,2678},{2,154500},{4,3914}]};

get_court_strength(197) ->
	#base_god_court_strength{lv = 197,cost = [{255,36255098,1591}],attr = [{1,5175},{3,2691},{2,155250},{4,3933}]};

get_court_strength(198) ->
	#base_god_court_strength{lv = 198,cost = [{255,36255098,1596}],attr = [{1,5200},{3,2704},{2,156000},{4,3952}]};

get_court_strength(199) ->
	#base_god_court_strength{lv = 199,cost = [{255,36255098,1601}],attr = [{1,5225},{3,2717},{2,156750},{4,3971}]};

get_court_strength(200) ->
	#base_god_court_strength{lv = 200,cost = [],attr = [{1,5250},{3,2730},{2,157500},{4,3990}]};

get_court_strength(_Lv) ->
	[].

get_equip_stage(0) ->
	#base_god_court_equip_stage{stage = 0,cost = [{0,801704,1}],attr = [],suit_attr = []};

get_equip_stage(1) ->
	#base_god_court_equip_stage{stage = 1,cost = [{0,801704,1}],attr = [{331,2400}],suit_attr = [{3,[{54,80},{56,80}]},{5,[{27,12},{28,12}]},{8,[{13,4},{14,4}]}]};

get_equip_stage(2) ->
	#base_god_court_equip_stage{stage = 2,cost = [{0,801704,2}],attr = [{331,4600}],suit_attr = [{3,[{54,240},{56,240}]},{5,[{27,36},{28,36}]},{8,[{13,12},{14,12}]}]};

get_equip_stage(3) ->
	#base_god_court_equip_stage{stage = 3,cost = [{0,801704,2}],attr = [{331,6800}],suit_attr = [{3,[{54,460},{56,460}]},{5,[{27,69},{28,69}]},{8,[{13,23},{14,23}]}]};

get_equip_stage(4) ->
	#base_god_court_equip_stage{stage = 4,cost = [{0,801704,2}],attr = [{331,9000}],suit_attr = [{3,[{54,640},{56,640}]},{5,[{27,96},{28,96}]},{8,[{13,32},{14,32}]}]};

get_equip_stage(5) ->
	#base_god_court_equip_stage{stage = 5,cost = [{0,801704,3}],attr = [{331,11200}],suit_attr = [{3,[{54,840},{56,840}]},{5,[{27,126},{28,126}]},{8,[{13,42},{14,42}]}]};

get_equip_stage(6) ->
	#base_god_court_equip_stage{stage = 6,cost = [{0,801704,3}],attr = [{331,13400}],suit_attr = [{3,[{54,1000},{56,1000}]},{5,[{27,150},{28,150}]},{8,[{13,50},{14,50}]}]};

get_equip_stage(7) ->
	#base_god_court_equip_stage{stage = 7,cost = [{0,801704,4}],attr = [{331,15600}],suit_attr = [{3,[{54,1200},{56,1200}]},{5,[{27,180},{28,180}]},{8,[{13,60},{14,60}]}]};

get_equip_stage(8) ->
	#base_god_court_equip_stage{stage = 8,cost = [{0,801704,5}],attr = [{331,17800}],suit_attr = [{3,[{54,1500},{56,1500}]},{5,[{27,225},{28,225}]},{8,[{13,75},{14,75}]}]};

get_equip_stage(9) ->
	#base_god_court_equip_stage{stage = 9,cost = [],attr = [{331,20000}],suit_attr = [{3,[{54,2000},{56,2000}]},{5,[{27,300},{28,300}]},{8,[{13,100},{14,100}]}]};

get_equip_stage(_Stage) ->
	[].

get_house_lv(1) ->
	#base_god_house_lv{lv = 1,exp = 0};

get_house_lv(2) ->
	#base_god_house_lv{lv = 2,exp = 900};

get_house_lv(3) ->
	#base_god_house_lv{lv = 3,exp = 1270};

get_house_lv(4) ->
	#base_god_house_lv{lv = 4,exp = 1680};

get_house_lv(5) ->
	#base_god_house_lv{lv = 5,exp = 1910};

get_house_lv(6) ->
	#base_god_house_lv{lv = 6,exp = 3840};

get_house_lv(7) ->
	#base_god_house_lv{lv = 7,exp = 6400};

get_house_lv(8) ->
	#base_god_house_lv{lv = 8,exp = 8960};

get_house_lv(_Lv) ->
	[].

get_house_crystal(1) ->
	#base_god_house_crystal{color = 1,exp = 10,weight = [{down,0},{up,100}],origin_cost = [{1,0,80}],must_reward = [{255,36255099,10}],random_reward = [{0,800110,1,125},{0,800210,1,125},{0,800310,1,125},{0,800410,1,125},{0,800510,1,125},{0,800610,1,125},{0,800710,1,125},{0,800810,1,125}],random_reward2 = [{0,801701,1,1000}]};

get_house_crystal(2) ->
	#base_god_house_crystal{color = 2,exp = 15,weight = [{down,40},{up,60}],origin_cost = [{1,0,70}],must_reward = [{255,36255099,10}],random_reward = [{0,800110,1,25},{0,800210,1,25},{0,800310,1,25},{0,800410,1,25},{0,800510,1,25},{0,800610,1,25},{0,800710,1,25},{0,800810,1,25},{0,800120,1,100},{0,800220,1,100},{0,800320,1,100},{0,800420,1,100},{0,800520,1,100},{0,800620,1,100},{0,800720,1,100},{0,800820,1,100}],random_reward2 = [{0,801701,1,1000}]};

get_house_crystal(3) ->
	#base_god_house_crystal{color = 3,exp = 20,weight = [{down,95},{up,5}],origin_cost = [{1,0,50}],must_reward = [{255,36255099,10}],random_reward = [{0,800120,1,38},{0,800220,1,38},{0,800320,1,38},{0,800420,1,38},{0,800520,1,38},{0,800620,1,38},{0,800720,1,38},{0,800820,1,38},{0,800130,1,88},{0,800230,1,88},{0,800330,1,88},{0,800430,1,88},{0,800530,1,88},{0,800630,1,88},{0,800730,1,88},{0,800830,1,88}],random_reward2 = [{0,801702,1,800},{0,801704,1,200}]};

get_house_crystal(4) ->
	#base_god_house_crystal{color = 4,exp = 40,weight = [{down,80},{up,20}],origin_cost = [],must_reward = [{255,36255099,10}],random_reward = [{0,800130,1,50},{0,800230,1,50},{0,800330,1,50},{0,800430,1,50},{0,800530,1,50},{0,800630,1,50},{0,800730,1,50},{0,800830,1,50},{0,800140,1,75},{0,800240,1,75},{0,800340,1,75},{0,800440,1,75},{0,800540,1,75},{0,800640,1,75},{0,800740,1,75},{0,800840,1,75}],random_reward2 = [{0,801702,1,800},{0,801704,1,200}]};

get_house_crystal(5) ->
	#base_god_house_crystal{color = 5,exp = 60,weight = [{down,100},{up,0}],origin_cost = [],must_reward = [{255,36255099,10}],random_reward = [{0,800130,1,6},{0,800230,1,6},{0,800330,1,6},{0,800430,1,6},{0,800530,1,6},{0,800630,1,6},{0,800730,1,6},{0,800830,1,6},{0,800140,1,81},{0,800240,1,81},{0,800340,1,81},{0,800440,1,81},{0,800540,1,81},{0,800640,1,81},{0,800740,1,81},{0,800840,1,81},{0,800150,1,38},{0,800250,1,38},{0,800350,1,38},{0,800450,1,38},{0,800550,1,38},{0,800650,1,38},{0,800750,1,38},{0,800850,1,38}],random_reward2 = [{0,801703,1,750},{0,801704,1,200},{0,801706,1,50}]};

get_house_crystal(_Color) ->
	[].

get_house_reward(1) ->
	#base_god_house_reward{lv = 1,down_num = 0,up_num = 24,reweard_pool = [{0,800950,1,1000}]};

get_house_reward(2) ->
	#base_god_house_reward{lv = 2,down_num = 25,up_num = 49,reweard_pool = [{0,800950,1,400},{0,801050,1,600}]};

get_house_reward(3) ->
	#base_god_house_reward{lv = 3,down_num = 50,up_num = 79,reweard_pool = [{0,800950,1,100},{0,801050,1,300},{0,801150,1,600}]};

get_house_reward(4) ->
	#base_god_house_reward{lv = 4,down_num = 80,up_num = 119,reweard_pool = [{0,801050,1,200},{0,801150,1,200},{0,801250,1,600}]};

get_house_reward(5) ->
	#base_god_house_reward{lv = 5,down_num = 120,up_num = 199,reweard_pool = [{0,801050,1,150},{0,801150,1,150},{0,801250,1,200},{0,801350,1,500}]};

get_house_reward(6) ->
	#base_god_house_reward{lv = 6,down_num = 200,up_num = 319,reweard_pool = [{0,801150,1,150},{0,801250,1,150},{0,801350,1,200},{0,801450,1,500}]};

get_house_reward(7) ->
	#base_god_house_reward{lv = 7,down_num = 320,up_num = 499,reweard_pool = [{0,801250,1,150},{0,801350,1,150},{0,801450,1,200},{0,801550,1,500}]};

get_house_reward(8) ->
	#base_god_house_reward{lv = 8,down_num = 500,up_num = 749,reweard_pool = [{0,801350,1,150},{0,801450,1,150},{0,801550,1,200},{0,801650,1,500}]};

get_house_reward(9) ->
	#base_god_house_reward{lv = 9,down_num = 750,up_num = 9999,reweard_pool = [{0,34010463,1,1000}]};

get_house_reward(_Lv) ->
	[].

get_house_reward_lvs() ->
[1,2,3,4,5,6,7,8,9].


get(1) ->
500;


get(2) ->
[{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,11},{12,12},{13,13},{14,14},{15,15},{16,16}];


get(3) ->
[3,6,9,12,15,18,21,24,27,30];


get(4) ->
4;


get(5) ->
[{0,801707,1}];


get(6) ->
[1,2,3,4,5,6,7,8];


get(7) ->
2;


get(8) ->
[{0,800140,1,100},{0,800240,1,100},{0,800340,1,100},{0,800440,1,100},{0,800540,1,100},{0,800640,1,100},{0,800740,1,100},{0,800840,1,100}];

get(_Id) ->
	[].

