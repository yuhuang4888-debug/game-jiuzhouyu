%%%---------------------------------------
%%% module      : data_armour
%%% description : 战甲配置
%%%
%%%---------------------------------------
-module(data_armour).
-compile(export_all).
-include("armour.hrl").




get(1) ->
[[1,2,3,4,5]];


get(2) ->
[[6,7,8,9,10]];

get(_Key) ->
	[].

get_armour_suit(1,1) ->
	#base_armour_suit{stage = 1,type = 1,open_lv = 450,attr = [{1,600},{2,6000},{20,30},{21,50},{14,30}]};

get_armour_suit(1,2) ->
	#base_armour_suit{stage = 1,type = 2,open_lv = 450,attr = [{1,1200},{2,12000},{19,50},{22,100},{13,50}]};

get_armour_suit(2,1) ->
	#base_armour_suit{stage = 2,type = 1,open_lv = 470,attr = [{1,700},{2,7000},{20,30},{21,50},{14,30}]};

get_armour_suit(2,2) ->
	#base_armour_suit{stage = 2,type = 2,open_lv = 470,attr = [{1,1400},{2,14000},{19,50},{22,100},{13,50}]};

get_armour_suit(3,1) ->
	#base_armour_suit{stage = 3,type = 1,open_lv = 490,attr = [{1,800},{2,8000},{20,30},{21,50},{14,30}]};

get_armour_suit(3,2) ->
	#base_armour_suit{stage = 3,type = 2,open_lv = 490,attr = [{1,1600},{2,16000},{19,50},{22,100},{13,50}]};

get_armour_suit(4,1) ->
	#base_armour_suit{stage = 4,type = 1,open_lv = 520,attr = [{1,900},{2,9000},{20,30},{21,50},{14,30}]};

get_armour_suit(4,2) ->
	#base_armour_suit{stage = 4,type = 2,open_lv = 520,attr = [{1,1800},{2,18000},{19,50},{22,100},{13,50}]};

get_armour_suit(5,1) ->
	#base_armour_suit{stage = 5,type = 1,open_lv = 550,attr = [{1,1000},{2,10000},{20,30},{21,50},{14,30}]};

get_armour_suit(5,2) ->
	#base_armour_suit{stage = 5,type = 2,open_lv = 550,attr = [{1,2000},{2,20000},{19,50},{22,100},{13,50}]};

get_armour_suit(6,1) ->
	#base_armour_suit{stage = 6,type = 1,open_lv = 580,attr = [{1,1100},{2,11000},{20,30},{21,50},{14,30}]};

get_armour_suit(6,2) ->
	#base_armour_suit{stage = 6,type = 2,open_lv = 580,attr = [{1,2200},{2,22000},{19,50},{22,100},{13,50}]};

get_armour_suit(7,1) ->
	#base_armour_suit{stage = 7,type = 1,open_lv = 610,attr = [{1,1200},{2,12000},{20,30},{21,50},{14,30}]};

get_armour_suit(7,2) ->
	#base_armour_suit{stage = 7,type = 2,open_lv = 610,attr = [{1,2400},{2,24000},{19,50},{22,100},{13,50}]};

get_armour_suit(8,1) ->
	#base_armour_suit{stage = 8,type = 1,open_lv = 640,attr = [{1,1300},{2,13000},{20,30},{21,50},{14,30}]};

get_armour_suit(8,2) ->
	#base_armour_suit{stage = 8,type = 2,open_lv = 640,attr = [{1,2600},{2,26000},{19,50},{22,100},{13,50}]};

get_armour_suit(9,1) ->
	#base_armour_suit{stage = 9,type = 1,open_lv = 670,attr = [{1,1400},{2,14000},{20,30},{21,50},{14,30}]};

get_armour_suit(9,2) ->
	#base_armour_suit{stage = 9,type = 2,open_lv = 670,attr = [{1,2800},{2,28000},{19,50},{22,100},{13,50}]};

get_armour_suit(_Stage,_Type) ->
	[].

get_all_stage() ->
[1,2,3,4,5,6,7,8,9].


get_all_type(1) ->
[1,2];


get_all_type(2) ->
[1,2];


get_all_type(3) ->
[1,2];


get_all_type(4) ->
[1,2];


get_all_type(5) ->
[1,2];


get_all_type(6) ->
[1,2];


get_all_type(7) ->
[1,2];


get_all_type(8) ->
[1,2];


get_all_type(9) ->
[1,2];

get_all_type(_Stage) ->
	[].

get_armour_equipment(1,1,1) ->
	#base_armour_equipment{id = 82010001,stage = 1,type = 1,pos = 1,pre_stage = 0,consume = [{0,82110101,5}],attr = [{4,300},{2,6000}]};

get_armour_equipment(2,1,1) ->
	#base_armour_equipment{id = 82010002,stage = 2,type = 1,pos = 1,pre_stage = 1,consume = [{0,82110101,8},{0,82010001,1}],attr = [{4,350},{2,7000}]};

get_armour_equipment(3,1,1) ->
	#base_armour_equipment{id = 82010003,stage = 3,type = 1,pos = 1,pre_stage = 2,consume = [{0,82110101,12},{0,82010002,1}],attr = [{4,400},{2,8000}]};

get_armour_equipment(4,1,1) ->
	#base_armour_equipment{id = 82010004,stage = 4,type = 1,pos = 1,pre_stage = 3,consume = [{0,82110101,20},{0,82010003,1}],attr = [{4,450},{2,9000}]};

get_armour_equipment(5,1,1) ->
	#base_armour_equipment{id = 82010005,stage = 5,type = 1,pos = 1,pre_stage = 4,consume = [{0,82110101,30},{0,82010004,1}],attr = [{4,500},{2,10000}]};

get_armour_equipment(6,1,1) ->
	#base_armour_equipment{id = 82010006,stage = 6,type = 1,pos = 1,pre_stage = 5,consume = [{0,82110101,40},{0,82010005,1}],attr = [{4,550},{2,11000}]};

get_armour_equipment(7,1,1) ->
	#base_armour_equipment{id = 82010007,stage = 7,type = 1,pos = 1,pre_stage = 6,consume = [{0,82110101,50},{0,82010006,1}],attr = [{4,600},{2,12000}]};

get_armour_equipment(8,1,1) ->
	#base_armour_equipment{id = 82010008,stage = 8,type = 1,pos = 1,pre_stage = 7,consume = [{0,82110101,60},{0,82010007,1}],attr = [{4,650},{2,13000}]};

get_armour_equipment(9,1,1) ->
	#base_armour_equipment{id = 82010009,stage = 9,type = 1,pos = 1,pre_stage = 8,consume = [{0,82110101,80},{0,82010008,1}],attr = [{4,700},{2,14000}]};

get_armour_equipment(1,1,2) ->
	#base_armour_equipment{id = 82020001,stage = 1,type = 1,pos = 2,pre_stage = 0,consume = [{0,82110101,5}],attr = [{4,300},{2,6000}]};

get_armour_equipment(2,1,2) ->
	#base_armour_equipment{id = 82020002,stage = 2,type = 1,pos = 2,pre_stage = 1,consume = [{0,82110101,8},{0,82020001,1}],attr = [{4,350},{2,7000}]};

get_armour_equipment(3,1,2) ->
	#base_armour_equipment{id = 82020003,stage = 3,type = 1,pos = 2,pre_stage = 2,consume = [{0,82110101,12},{0,82020002,1}],attr = [{4,400},{2,8000}]};

get_armour_equipment(4,1,2) ->
	#base_armour_equipment{id = 82020004,stage = 4,type = 1,pos = 2,pre_stage = 3,consume = [{0,82110101,20},{0,82020003,1}],attr = [{4,450},{2,9000}]};

get_armour_equipment(5,1,2) ->
	#base_armour_equipment{id = 82020005,stage = 5,type = 1,pos = 2,pre_stage = 4,consume = [{0,82110101,30},{0,82020004,1}],attr = [{4,500},{2,10000}]};

get_armour_equipment(6,1,2) ->
	#base_armour_equipment{id = 82020006,stage = 6,type = 1,pos = 2,pre_stage = 5,consume = [{0,82110101,40},{0,82020005,1}],attr = [{4,550},{2,11000}]};

get_armour_equipment(7,1,2) ->
	#base_armour_equipment{id = 82020007,stage = 7,type = 1,pos = 2,pre_stage = 6,consume = [{0,82110101,50},{0,82020006,1}],attr = [{4,600},{2,12000}]};

get_armour_equipment(8,1,2) ->
	#base_armour_equipment{id = 82020008,stage = 8,type = 1,pos = 2,pre_stage = 7,consume = [{0,82110101,60},{0,82020007,1}],attr = [{4,650},{2,13000}]};

get_armour_equipment(9,1,2) ->
	#base_armour_equipment{id = 82020009,stage = 9,type = 1,pos = 2,pre_stage = 8,consume = [{0,82110101,80},{0,82020008,1}],attr = [{4,700},{2,14000}]};

get_armour_equipment(1,1,3) ->
	#base_armour_equipment{id = 82030001,stage = 1,type = 1,pos = 3,pre_stage = 0,consume = [{0,82110101,5}],attr = [{4,300},{2,6000}]};

get_armour_equipment(2,1,3) ->
	#base_armour_equipment{id = 82030002,stage = 2,type = 1,pos = 3,pre_stage = 1,consume = [{0,82110101,8},{0,82030001,1}],attr = [{4,350},{2,7000}]};

get_armour_equipment(3,1,3) ->
	#base_armour_equipment{id = 82030003,stage = 3,type = 1,pos = 3,pre_stage = 2,consume = [{0,82110101,12},{0,82030002,1}],attr = [{4,400},{2,8000}]};

get_armour_equipment(4,1,3) ->
	#base_armour_equipment{id = 82030004,stage = 4,type = 1,pos = 3,pre_stage = 3,consume = [{0,82110101,20},{0,82030003,1}],attr = [{4,450},{2,9000}]};

get_armour_equipment(5,1,3) ->
	#base_armour_equipment{id = 82030005,stage = 5,type = 1,pos = 3,pre_stage = 4,consume = [{0,82110101,30},{0,82030004,1}],attr = [{4,500},{2,10000}]};

get_armour_equipment(6,1,3) ->
	#base_armour_equipment{id = 82030006,stage = 6,type = 1,pos = 3,pre_stage = 5,consume = [{0,82110101,40},{0,82030005,1}],attr = [{4,550},{2,11000}]};

get_armour_equipment(7,1,3) ->
	#base_armour_equipment{id = 82030007,stage = 7,type = 1,pos = 3,pre_stage = 6,consume = [{0,82110101,50},{0,82030006,1}],attr = [{4,600},{2,12000}]};

get_armour_equipment(8,1,3) ->
	#base_armour_equipment{id = 82030008,stage = 8,type = 1,pos = 3,pre_stage = 7,consume = [{0,82110101,60},{0,82030007,1}],attr = [{4,650},{2,13000}]};

get_armour_equipment(9,1,3) ->
	#base_armour_equipment{id = 82030009,stage = 9,type = 1,pos = 3,pre_stage = 8,consume = [{0,82110101,80},{0,82030008,1}],attr = [{4,700},{2,14000}]};

get_armour_equipment(1,1,4) ->
	#base_armour_equipment{id = 82040001,stage = 1,type = 1,pos = 4,pre_stage = 0,consume = [{0,82110101,5}],attr = [{4,300},{2,6000}]};

get_armour_equipment(2,1,4) ->
	#base_armour_equipment{id = 82040002,stage = 2,type = 1,pos = 4,pre_stage = 1,consume = [{0,82110101,8},{0,82040001,1}],attr = [{4,350},{2,7000}]};

get_armour_equipment(3,1,4) ->
	#base_armour_equipment{id = 82040003,stage = 3,type = 1,pos = 4,pre_stage = 2,consume = [{0,82110101,12},{0,82040002,1}],attr = [{4,400},{2,8000}]};

get_armour_equipment(4,1,4) ->
	#base_armour_equipment{id = 82040004,stage = 4,type = 1,pos = 4,pre_stage = 3,consume = [{0,82110101,20},{0,82040003,1}],attr = [{4,450},{2,9000}]};

get_armour_equipment(5,1,4) ->
	#base_armour_equipment{id = 82040005,stage = 5,type = 1,pos = 4,pre_stage = 4,consume = [{0,82110101,30},{0,82040004,1}],attr = [{4,500},{2,10000}]};

get_armour_equipment(6,1,4) ->
	#base_armour_equipment{id = 82040006,stage = 6,type = 1,pos = 4,pre_stage = 5,consume = [{0,82110101,40},{0,82040005,1}],attr = [{4,550},{2,11000}]};

get_armour_equipment(7,1,4) ->
	#base_armour_equipment{id = 82040007,stage = 7,type = 1,pos = 4,pre_stage = 6,consume = [{0,82110101,50},{0,82040006,1}],attr = [{4,600},{2,12000}]};

get_armour_equipment(8,1,4) ->
	#base_armour_equipment{id = 82040008,stage = 8,type = 1,pos = 4,pre_stage = 7,consume = [{0,82110101,60},{0,82040007,1}],attr = [{4,650},{2,13000}]};

get_armour_equipment(9,1,4) ->
	#base_armour_equipment{id = 82040009,stage = 9,type = 1,pos = 4,pre_stage = 8,consume = [{0,82110101,80},{0,82040008,1}],attr = [{4,700},{2,14000}]};

get_armour_equipment(1,1,5) ->
	#base_armour_equipment{id = 82050001,stage = 1,type = 1,pos = 5,pre_stage = 0,consume = [{0,82110101,5}],attr = [{4,300},{2,6000}]};

get_armour_equipment(2,1,5) ->
	#base_armour_equipment{id = 82050002,stage = 2,type = 1,pos = 5,pre_stage = 1,consume = [{0,82110101,8},{0,82050001,1}],attr = [{4,350},{2,7000}]};

get_armour_equipment(3,1,5) ->
	#base_armour_equipment{id = 82050003,stage = 3,type = 1,pos = 5,pre_stage = 2,consume = [{0,82110101,12},{0,82050002,1}],attr = [{4,400},{2,8000}]};

get_armour_equipment(4,1,5) ->
	#base_armour_equipment{id = 82050004,stage = 4,type = 1,pos = 5,pre_stage = 3,consume = [{0,82110101,20},{0,82050003,1}],attr = [{4,450},{2,9000}]};

get_armour_equipment(5,1,5) ->
	#base_armour_equipment{id = 82050005,stage = 5,type = 1,pos = 5,pre_stage = 4,consume = [{0,82110101,30},{0,82050004,1}],attr = [{4,500},{2,10000}]};

get_armour_equipment(6,1,5) ->
	#base_armour_equipment{id = 82050006,stage = 6,type = 1,pos = 5,pre_stage = 5,consume = [{0,82110101,40},{0,82050005,1}],attr = [{4,550},{2,11000}]};

get_armour_equipment(7,1,5) ->
	#base_armour_equipment{id = 82050007,stage = 7,type = 1,pos = 5,pre_stage = 6,consume = [{0,82110101,50},{0,82050006,1}],attr = [{4,600},{2,12000}]};

get_armour_equipment(8,1,5) ->
	#base_armour_equipment{id = 82050008,stage = 8,type = 1,pos = 5,pre_stage = 7,consume = [{0,82110101,60},{0,82050007,1}],attr = [{4,650},{2,13000}]};

get_armour_equipment(9,1,5) ->
	#base_armour_equipment{id = 82050009,stage = 9,type = 1,pos = 5,pre_stage = 8,consume = [{0,82110101,80},{0,82050008,1}],attr = [{4,700},{2,14000}]};

get_armour_equipment(1,2,6) ->
	#base_armour_equipment{id = 82060001,stage = 1,type = 2,pos = 6,pre_stage = 0,consume = [{0,82110201,1}],attr = [{1,600},{3,600}]};

get_armour_equipment(2,2,6) ->
	#base_armour_equipment{id = 82060002,stage = 2,type = 2,pos = 6,pre_stage = 1,consume = [{0,82110201,2},{0,82060001,1}],attr = [{1,700},{3,700}]};

get_armour_equipment(3,2,6) ->
	#base_armour_equipment{id = 82060003,stage = 3,type = 2,pos = 6,pre_stage = 2,consume = [{0,82110201,3},{0,82060002,1}],attr = [{1,800},{3,800}]};

get_armour_equipment(4,2,6) ->
	#base_armour_equipment{id = 82060004,stage = 4,type = 2,pos = 6,pre_stage = 3,consume = [{0,82110201,5},{0,82060003,1}],attr = [{1,900},{3,900}]};

get_armour_equipment(5,2,6) ->
	#base_armour_equipment{id = 82060005,stage = 5,type = 2,pos = 6,pre_stage = 4,consume = [{0,82110201,8},{0,82060004,1}],attr = [{1,1000},{3,1000}]};

get_armour_equipment(6,2,6) ->
	#base_armour_equipment{id = 82060006,stage = 6,type = 2,pos = 6,pre_stage = 5,consume = [{0,82110201,12},{0,82060005,1}],attr = [{1,1100},{3,1100}]};

get_armour_equipment(7,2,6) ->
	#base_armour_equipment{id = 82060007,stage = 7,type = 2,pos = 6,pre_stage = 6,consume = [{0,82110201,16},{0,82060006,1}],attr = [{1,1200},{3,1200}]};

get_armour_equipment(8,2,6) ->
	#base_armour_equipment{id = 82060008,stage = 8,type = 2,pos = 6,pre_stage = 7,consume = [{0,82110201,20},{0,82060007,1}],attr = [{1,1300},{3,1300}]};

get_armour_equipment(9,2,6) ->
	#base_armour_equipment{id = 82060009,stage = 9,type = 2,pos = 6,pre_stage = 8,consume = [{0,82110201,24},{0,82060008,1}],attr = [{1,1400},{3,1400}]};

get_armour_equipment(1,2,7) ->
	#base_armour_equipment{id = 82070001,stage = 1,type = 2,pos = 7,pre_stage = 0,consume = [{0,82110201,1}],attr = [{1,600},{3,600}]};

get_armour_equipment(2,2,7) ->
	#base_armour_equipment{id = 82070002,stage = 2,type = 2,pos = 7,pre_stage = 1,consume = [{0,82110201,2},{0,82070001,1}],attr = [{1,700},{3,700}]};

get_armour_equipment(3,2,7) ->
	#base_armour_equipment{id = 82070003,stage = 3,type = 2,pos = 7,pre_stage = 2,consume = [{0,82110201,3},{0,82070002,1}],attr = [{1,800},{3,800}]};

get_armour_equipment(4,2,7) ->
	#base_armour_equipment{id = 82070004,stage = 4,type = 2,pos = 7,pre_stage = 3,consume = [{0,82110201,5},{0,82070003,1}],attr = [{1,900},{3,900}]};

get_armour_equipment(5,2,7) ->
	#base_armour_equipment{id = 82070005,stage = 5,type = 2,pos = 7,pre_stage = 4,consume = [{0,82110201,8},{0,82070004,1}],attr = [{1,1000},{3,1000}]};

get_armour_equipment(6,2,7) ->
	#base_armour_equipment{id = 82070006,stage = 6,type = 2,pos = 7,pre_stage = 5,consume = [{0,82110201,12},{0,82070005,1}],attr = [{1,1100},{3,1100}]};

get_armour_equipment(7,2,7) ->
	#base_armour_equipment{id = 82070007,stage = 7,type = 2,pos = 7,pre_stage = 6,consume = [{0,82110201,16},{0,82070006,1}],attr = [{1,1200},{3,1200}]};

get_armour_equipment(8,2,7) ->
	#base_armour_equipment{id = 82070008,stage = 8,type = 2,pos = 7,pre_stage = 7,consume = [{0,82110201,20},{0,82070007,1}],attr = [{1,1300},{3,1300}]};

get_armour_equipment(9,2,7) ->
	#base_armour_equipment{id = 82070009,stage = 9,type = 2,pos = 7,pre_stage = 8,consume = [{0,82110201,24},{0,82070008,1}],attr = [{1,1400},{3,1400}]};

get_armour_equipment(1,2,8) ->
	#base_armour_equipment{id = 82080001,stage = 1,type = 2,pos = 8,pre_stage = 0,consume = [{0,82110201,1}],attr = [{1,600},{3,600}]};

get_armour_equipment(2,2,8) ->
	#base_armour_equipment{id = 82080002,stage = 2,type = 2,pos = 8,pre_stage = 1,consume = [{0,82110201,2},{0,82080001,1}],attr = [{1,700},{3,700}]};

get_armour_equipment(3,2,8) ->
	#base_armour_equipment{id = 82080003,stage = 3,type = 2,pos = 8,pre_stage = 2,consume = [{0,82110201,3},{0,82080002,1}],attr = [{1,800},{3,800}]};

get_armour_equipment(4,2,8) ->
	#base_armour_equipment{id = 82080004,stage = 4,type = 2,pos = 8,pre_stage = 3,consume = [{0,82110201,5},{0,82080003,1}],attr = [{1,900},{3,900}]};

get_armour_equipment(5,2,8) ->
	#base_armour_equipment{id = 82080005,stage = 5,type = 2,pos = 8,pre_stage = 4,consume = [{0,82110201,8},{0,82080004,1}],attr = [{1,1000},{3,1000}]};

get_armour_equipment(6,2,8) ->
	#base_armour_equipment{id = 82080006,stage = 6,type = 2,pos = 8,pre_stage = 5,consume = [{0,82110201,12},{0,82080005,1}],attr = [{1,1100},{3,1100}]};

get_armour_equipment(7,2,8) ->
	#base_armour_equipment{id = 82080007,stage = 7,type = 2,pos = 8,pre_stage = 6,consume = [{0,82110201,16},{0,82080006,1}],attr = [{1,1200},{3,1200}]};

get_armour_equipment(8,2,8) ->
	#base_armour_equipment{id = 82080008,stage = 8,type = 2,pos = 8,pre_stage = 7,consume = [{0,82110201,20},{0,82080007,1}],attr = [{1,1300},{3,1300}]};

get_armour_equipment(9,2,8) ->
	#base_armour_equipment{id = 82080009,stage = 9,type = 2,pos = 8,pre_stage = 8,consume = [{0,82110201,24},{0,82080008,1}],attr = [{1,1400},{3,1400}]};

get_armour_equipment(1,2,9) ->
	#base_armour_equipment{id = 82090001,stage = 1,type = 2,pos = 9,pre_stage = 0,consume = [{0,82110201,1}],attr = [{1,600},{3,600}]};

get_armour_equipment(2,2,9) ->
	#base_armour_equipment{id = 82090002,stage = 2,type = 2,pos = 9,pre_stage = 1,consume = [{0,82110201,2},{0,82090001,1}],attr = [{1,700},{3,700}]};

get_armour_equipment(3,2,9) ->
	#base_armour_equipment{id = 82090003,stage = 3,type = 2,pos = 9,pre_stage = 2,consume = [{0,82110201,3},{0,82090002,1}],attr = [{1,800},{3,800}]};

get_armour_equipment(4,2,9) ->
	#base_armour_equipment{id = 82090004,stage = 4,type = 2,pos = 9,pre_stage = 3,consume = [{0,82110201,5},{0,82090003,1}],attr = [{1,900},{3,900}]};

get_armour_equipment(5,2,9) ->
	#base_armour_equipment{id = 82090005,stage = 5,type = 2,pos = 9,pre_stage = 4,consume = [{0,82110201,8},{0,82090004,1}],attr = [{1,1000},{3,1000}]};

get_armour_equipment(6,2,9) ->
	#base_armour_equipment{id = 82090006,stage = 6,type = 2,pos = 9,pre_stage = 5,consume = [{0,82110201,12},{0,82090005,1}],attr = [{1,1100},{3,1100}]};

get_armour_equipment(7,2,9) ->
	#base_armour_equipment{id = 82090007,stage = 7,type = 2,pos = 9,pre_stage = 6,consume = [{0,82110201,16},{0,82090006,1}],attr = [{1,1200},{3,1200}]};

get_armour_equipment(8,2,9) ->
	#base_armour_equipment{id = 82090008,stage = 8,type = 2,pos = 9,pre_stage = 7,consume = [{0,82110201,20},{0,82090007,1}],attr = [{1,1300},{3,1300}]};

get_armour_equipment(9,2,9) ->
	#base_armour_equipment{id = 82090009,stage = 9,type = 2,pos = 9,pre_stage = 8,consume = [{0,82110201,24},{0,82090008,1}],attr = [{1,1400},{3,1400}]};

get_armour_equipment(1,2,10) ->
	#base_armour_equipment{id = 82100001,stage = 1,type = 2,pos = 10,pre_stage = 0,consume = [{0,82110201,1}],attr = [{1,600},{3,600}]};

get_armour_equipment(2,2,10) ->
	#base_armour_equipment{id = 82100002,stage = 2,type = 2,pos = 10,pre_stage = 1,consume = [{0,82110201,2},{0,82100001,1}],attr = [{1,700},{3,700}]};

get_armour_equipment(3,2,10) ->
	#base_armour_equipment{id = 82100003,stage = 3,type = 2,pos = 10,pre_stage = 2,consume = [{0,82110201,3},{0,82100002,1}],attr = [{1,800},{3,800}]};

get_armour_equipment(4,2,10) ->
	#base_armour_equipment{id = 82100004,stage = 4,type = 2,pos = 10,pre_stage = 3,consume = [{0,82110201,5},{0,82100003,1}],attr = [{1,900},{3,900}]};

get_armour_equipment(5,2,10) ->
	#base_armour_equipment{id = 82100005,stage = 5,type = 2,pos = 10,pre_stage = 4,consume = [{0,82110201,8},{0,82100004,1}],attr = [{1,1000},{3,1000}]};

get_armour_equipment(6,2,10) ->
	#base_armour_equipment{id = 82100006,stage = 6,type = 2,pos = 10,pre_stage = 5,consume = [{0,82110201,12},{0,82100005,1}],attr = [{1,1100},{3,1100}]};

get_armour_equipment(7,2,10) ->
	#base_armour_equipment{id = 82100007,stage = 7,type = 2,pos = 10,pre_stage = 6,consume = [{0,82110201,16},{0,82100006,1}],attr = [{1,1200},{3,1200}]};

get_armour_equipment(8,2,10) ->
	#base_armour_equipment{id = 82100008,stage = 8,type = 2,pos = 10,pre_stage = 7,consume = [{0,82110201,20},{0,82100007,1}],attr = [{1,1300},{3,1300}]};

get_armour_equipment(9,2,10) ->
	#base_armour_equipment{id = 82100009,stage = 9,type = 2,pos = 10,pre_stage = 8,consume = [{0,82110201,24},{0,82100008,1}],attr = [{1,1400},{3,1400}]};

get_armour_equipment(_Stage,_Type,_Pos) ->
	[].


get_pos_list(1) ->
[1,2,3,4,5];


get_pos_list(2) ->
[6,7,8,9,10];

get_pos_list(_Type) ->
	[].

