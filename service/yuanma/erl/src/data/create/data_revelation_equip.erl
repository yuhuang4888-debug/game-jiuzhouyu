%%%---------------------------------------
%%% module      : data_revelation_equip
%%% description : 天启装备配置
%%%
%%%---------------------------------------
-module(data_revelation_equip).
-compile(export_all).
-include("revelation_equip.hrl").



get_equip(72010001) ->
	#revelation_equip_cfg{goods_id = 72010001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{3,1600},{5,640}],other_attr = [{21,100},{27,60}]};

get_equip(72010002) ->
	#revelation_equip_cfg{goods_id = 72010002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{3,6400},{5,2560}],other_attr = [{21,250},{27,150}]};

get_equip(72010003) ->
	#revelation_equip_cfg{goods_id = 72010003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{3,14400},{5,5760}],other_attr = [{21,400},{27,240}]};

get_equip(72010004) ->
	#revelation_equip_cfg{goods_id = 72010004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{3,32000},{5,12800}],other_attr = [{21,800},{27,480}]};

get_equip(72020001) ->
	#revelation_equip_cfg{goods_id = 72020001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{4,1200},{8,960}],other_attr = [{22,100},{39,40}]};

get_equip(72020002) ->
	#revelation_equip_cfg{goods_id = 72020002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{4,4800},{8,3840}],other_attr = [{22,250},{39,100}]};

get_equip(72020003) ->
	#revelation_equip_cfg{goods_id = 72020003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{4,10800},{8,8640}],other_attr = [{22,400},{39,160}]};

get_equip(72020004) ->
	#revelation_equip_cfg{goods_id = 72020004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{4,24000},{8,19200}],other_attr = [{22,800},{39,320}]};

get_equip(72030001) ->
	#revelation_equip_cfg{goods_id = 72030001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{3,1600},{7,800}],other_attr = [{21,100},{43,60}]};

get_equip(72030002) ->
	#revelation_equip_cfg{goods_id = 72030002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{3,6400},{7,3200}],other_attr = [{21,250},{43,150}]};

get_equip(72030003) ->
	#revelation_equip_cfg{goods_id = 72030003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{3,14400},{7,7200}],other_attr = [{21,400},{43,240}]};

get_equip(72030004) ->
	#revelation_equip_cfg{goods_id = 72030004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{3,32000},{7,16000}],other_attr = [{21,800},{43,480}]};

get_equip(72040001) ->
	#revelation_equip_cfg{goods_id = 72040001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{2,30000},{8,800}],other_attr = [{20,40},{53,40}]};

get_equip(72040002) ->
	#revelation_equip_cfg{goods_id = 72040002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{2,120000},{8,3200}],other_attr = [{20,100},{53,100}]};

get_equip(72040003) ->
	#revelation_equip_cfg{goods_id = 72040003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{2,270000},{8,7200}],other_attr = [{20,160},{53,160}]};

get_equip(72040004) ->
	#revelation_equip_cfg{goods_id = 72040004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{2,600000},{8,16000}],other_attr = [{20,320},{53,320}]};

get_equip(72050001) ->
	#revelation_equip_cfg{goods_id = 72050001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{1,2000},{2,40000}],other_attr = [{19,80},{20,60}]};

get_equip(72050002) ->
	#revelation_equip_cfg{goods_id = 72050002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{1,8000},{2,160000}],other_attr = [{19,200},{20,150}]};

get_equip(72050003) ->
	#revelation_equip_cfg{goods_id = 72050003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{1,18000},{2,360000}],other_attr = [{19,320},{20,240}]};

get_equip(72050004) ->
	#revelation_equip_cfg{goods_id = 72050004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{1,40000},{2,800000}],other_attr = [{19,640},{20,480}]};

get_equip(72060001) ->
	#revelation_equip_cfg{goods_id = 72060001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{2,30000},{6,640}],other_attr = [{20,40},{44,60}]};

get_equip(72060002) ->
	#revelation_equip_cfg{goods_id = 72060002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{2,120000},{6,2560}],other_attr = [{20,100},{44,150}]};

get_equip(72060003) ->
	#revelation_equip_cfg{goods_id = 72060003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{2,270000},{6,5760}],other_attr = [{20,160},{44,240}]};

get_equip(72060004) ->
	#revelation_equip_cfg{goods_id = 72060004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{2,600000},{6,12800}],other_attr = [{20,320},{44,480}]};

get_equip(72070001) ->
	#revelation_equip_cfg{goods_id = 72070001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{1,1500},{7,800}],other_attr = [{19,50},{17,60}]};

get_equip(72070002) ->
	#revelation_equip_cfg{goods_id = 72070002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{1,6000},{7,3200}],other_attr = [{19,125},{17,150}]};

get_equip(72070003) ->
	#revelation_equip_cfg{goods_id = 72070003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{1,13500},{7,7200}],other_attr = [{19,200},{17,240}]};

get_equip(72070004) ->
	#revelation_equip_cfg{goods_id = 72070004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{1,30000},{7,16000}],other_attr = [{19,400},{17,480}]};

get_equip(72080001) ->
	#revelation_equip_cfg{goods_id = 72080001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{4,1200},{6,960}],other_attr = [{22,100},{28,60}]};

get_equip(72080002) ->
	#revelation_equip_cfg{goods_id = 72080002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{4,4800},{6,3840}],other_attr = [{22,250},{28,150}]};

get_equip(72080003) ->
	#revelation_equip_cfg{goods_id = 72080003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{4,10800},{6,8640}],other_attr = [{22,400},{28,240}]};

get_equip(72080004) ->
	#revelation_equip_cfg{goods_id = 72080004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{4,24000},{6,19200}],other_attr = [{22,800},{28,480}]};

get_equip(72090001) ->
	#revelation_equip_cfg{goods_id = 72090001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{1,1500},{3,800}],other_attr = [{19,50},{21,80}]};

get_equip(72090002) ->
	#revelation_equip_cfg{goods_id = 72090002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{1,6000},{3,3200}],other_attr = [{19,125},{21,200}]};

get_equip(72090003) ->
	#revelation_equip_cfg{goods_id = 72090003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{1,13500},{3,7200}],other_attr = [{19,200},{21,320}]};

get_equip(72090004) ->
	#revelation_equip_cfg{goods_id = 72090004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{1,30000},{3,16000}],other_attr = [{19,400},{21,640}]};

get_equip(72100001) ->
	#revelation_equip_cfg{goods_id = 72100001,stage = 0,star = 0,base_rating = 0,recommend_attr = [{4,1600},{8,800}],other_attr = [{22,100},{45,60}]};

get_equip(72100002) ->
	#revelation_equip_cfg{goods_id = 72100002,stage = 0,star = 1,base_rating = 0,recommend_attr = [{4,6400},{8,3200}],other_attr = [{22,250},{45,150}]};

get_equip(72100003) ->
	#revelation_equip_cfg{goods_id = 72100003,stage = 0,star = 2,base_rating = 0,recommend_attr = [{4,14400},{8,7200}],other_attr = [{22,400},{45,240}]};

get_equip(72100004) ->
	#revelation_equip_cfg{goods_id = 72100004,stage = 0,star = 3,base_rating = 0,recommend_attr = [{4,32000},{8,16000}],other_attr = [{22,800},{45,480}]};

get_equip(_Goodsid) ->
	[].

get_all_equip_ids() ->
[72010001,72010002,72010003,72010004,72020001,72020002,72020003,72020004,72030001,72030002,72030003,72030004,72040001,72040002,72040003,72040004,72050001,72050002,72050003,72050004,72060001,72060002,72060003,72060004,72070001,72070002,72070003,72070004,72080001,72080002,72080003,72080004,72090001,72090002,72090003,72090004,72100001,72100002,72100003,72100004].

get_suit_list() ->
[{0,3},{0,5},{0,7},{0,10},{1,3},{1,5},{1,7},{1,10},{2,3},{2,5},{2,7},{2,10},{3,3},{3,5},{3,7},{3,10}].

get_suit_attr(0,3) ->
[{4,16000},{12,50}];

get_suit_attr(0,5) ->
[{3,24000},{11,50}];

get_suit_attr(0,7) ->
[{2,400000},{4,16000},{13,100}];

get_suit_attr(0,10) ->
[{1,30000},{3,24000},{14,100}];

get_suit_attr(1,3) ->
[{4,32000},{12,125}];

get_suit_attr(1,5) ->
[{3,48000},{11,125}];

get_suit_attr(1,7) ->
[{2,800000},{4,32000},{13,250}];

get_suit_attr(1,10) ->
[{1,60000},{3,48000},{14,250}];

get_suit_attr(2,3) ->
[{4,64000},{12,200}];

get_suit_attr(2,5) ->
[{3,96000},{11,200}];

get_suit_attr(2,7) ->
[{2,1600000},{4,64000},{13,400}];

get_suit_attr(2,10) ->
[{1,120000},{3,96000},{14,400}];

get_suit_attr(3,3) ->
[{4,128000},{12,400}];

get_suit_attr(3,5) ->
[{3,192000},{11,400}];

get_suit_attr(3,7) ->
[{2,3200000},{4,128000},{13,800}];

get_suit_attr(3,10) ->
[{1,240000},{3,192000},{14,800}];

get_suit_attr(_Star,_Num) ->
	[].

get_suit_figure(0,3) ->
0;

get_suit_figure(0,5) ->
0;

get_suit_figure(0,7) ->
0;

get_suit_figure(0,10) ->
1;

get_suit_figure(1,3) ->
0;

get_suit_figure(1,5) ->
0;

get_suit_figure(1,7) ->
0;

get_suit_figure(1,10) ->
2;

get_suit_figure(2,3) ->
0;

get_suit_figure(2,5) ->
0;

get_suit_figure(2,7) ->
0;

get_suit_figure(2,10) ->
3;

get_suit_figure(3,3) ->
0;

get_suit_figure(3,5) ->
0;

get_suit_figure(3,7) ->
0;

get_suit_figure(3,10) ->
4;

get_suit_figure(_Star,_Num) ->
	[].

get_suit_name(0,3) ->
<<"智·天启"/utf8>>;

get_suit_name(0,5) ->
<<"智·天启"/utf8>>;

get_suit_name(0,7) ->
<<"智·天启"/utf8>>;

get_suit_name(0,10) ->
<<"智·天启"/utf8>>;

get_suit_name(1,3) ->
<<"猎·天启"/utf8>>;

get_suit_name(1,5) ->
<<"猎·天启"/utf8>>;

get_suit_name(1,7) ->
<<"猎·天启"/utf8>>;

get_suit_name(1,10) ->
<<"猎·天启"/utf8>>;

get_suit_name(2,3) ->
<<"惩·天启"/utf8>>;

get_suit_name(2,5) ->
<<"惩·天启"/utf8>>;

get_suit_name(2,7) ->
<<"惩·天启"/utf8>>;

get_suit_name(2,10) ->
<<"惩·天启"/utf8>>;

get_suit_name(3,3) ->
<<"炽·天启"/utf8>>;

get_suit_name(3,5) ->
<<"炽·天启"/utf8>>;

get_suit_name(3,7) ->
<<"炽·天启"/utf8>>;

get_suit_name(3,10) ->
<<"炽·天启"/utf8>>;

get_suit_name(_Star,_Num) ->
	[].


get_figure(1) ->
[{1,1130,0,1130,0},{2,1230,0,1230,0}];


get_figure(2) ->
[{1,1130,1,1130,1},{2,1230,1,1230,1}];


get_figure(3) ->
[{1,1130,2,1130,2},{2,1230,2,1230,2}];


get_figure(4) ->
[{1,1130,3,1130,3},{2,1230,3,1230,3}];

get_figure(_Id) ->
	[].


get_kv(gathering_star) ->
3;

get_kv(_Key) ->
	[].

get_next_lv_exp(1,0) ->
80;

get_next_lv_exp(1,1) ->
90;

get_next_lv_exp(1,2) ->
101;

get_next_lv_exp(1,3) ->
114;

get_next_lv_exp(1,4) ->
128;

get_next_lv_exp(1,5) ->
144;

get_next_lv_exp(1,6) ->
162;

get_next_lv_exp(1,7) ->
182;

get_next_lv_exp(1,8) ->
205;

get_next_lv_exp(1,9) ->
231;

get_next_lv_exp(1,10) ->
260;

get_next_lv_exp(1,11) ->
293;

get_next_lv_exp(1,12) ->
330;

get_next_lv_exp(1,13) ->
371;

get_next_lv_exp(1,14) ->
417;

get_next_lv_exp(1,15) ->
469;

get_next_lv_exp(1,16) ->
528;

get_next_lv_exp(1,17) ->
594;

get_next_lv_exp(1,18) ->
668;

get_next_lv_exp(1,19) ->
752;

get_next_lv_exp(1,20) ->
846;

get_next_lv_exp(1,21) ->
952;

get_next_lv_exp(1,22) ->
1071;

get_next_lv_exp(1,23) ->
1205;

get_next_lv_exp(1,24) ->
1356;

get_next_lv_exp(1,25) ->
1526;

get_next_lv_exp(1,26) ->
1717;

get_next_lv_exp(1,27) ->
1932;

get_next_lv_exp(1,28) ->
2174;

get_next_lv_exp(1,29) ->
2446;

get_next_lv_exp(1,30) ->
0;

get_next_lv_exp(2,0) ->
80;

get_next_lv_exp(2,1) ->
90;

get_next_lv_exp(2,2) ->
101;

get_next_lv_exp(2,3) ->
114;

get_next_lv_exp(2,4) ->
128;

get_next_lv_exp(2,5) ->
144;

get_next_lv_exp(2,6) ->
162;

get_next_lv_exp(2,7) ->
182;

get_next_lv_exp(2,8) ->
205;

get_next_lv_exp(2,9) ->
231;

get_next_lv_exp(2,10) ->
260;

get_next_lv_exp(2,11) ->
293;

get_next_lv_exp(2,12) ->
330;

get_next_lv_exp(2,13) ->
371;

get_next_lv_exp(2,14) ->
417;

get_next_lv_exp(2,15) ->
469;

get_next_lv_exp(2,16) ->
528;

get_next_lv_exp(2,17) ->
594;

get_next_lv_exp(2,18) ->
668;

get_next_lv_exp(2,19) ->
752;

get_next_lv_exp(2,20) ->
846;

get_next_lv_exp(2,21) ->
952;

get_next_lv_exp(2,22) ->
1071;

get_next_lv_exp(2,23) ->
1205;

get_next_lv_exp(2,24) ->
1356;

get_next_lv_exp(2,25) ->
1526;

get_next_lv_exp(2,26) ->
1717;

get_next_lv_exp(2,27) ->
1932;

get_next_lv_exp(2,28) ->
2174;

get_next_lv_exp(2,29) ->
2446;

get_next_lv_exp(2,30) ->
0;

get_next_lv_exp(3,0) ->
80;

get_next_lv_exp(3,1) ->
90;

get_next_lv_exp(3,2) ->
101;

get_next_lv_exp(3,3) ->
114;

get_next_lv_exp(3,4) ->
128;

get_next_lv_exp(3,5) ->
144;

get_next_lv_exp(3,6) ->
162;

get_next_lv_exp(3,7) ->
182;

get_next_lv_exp(3,8) ->
205;

get_next_lv_exp(3,9) ->
231;

get_next_lv_exp(3,10) ->
260;

get_next_lv_exp(3,11) ->
293;

get_next_lv_exp(3,12) ->
330;

get_next_lv_exp(3,13) ->
371;

get_next_lv_exp(3,14) ->
417;

get_next_lv_exp(3,15) ->
469;

get_next_lv_exp(3,16) ->
528;

get_next_lv_exp(3,17) ->
594;

get_next_lv_exp(3,18) ->
668;

get_next_lv_exp(3,19) ->
752;

get_next_lv_exp(3,20) ->
846;

get_next_lv_exp(3,21) ->
952;

get_next_lv_exp(3,22) ->
1071;

get_next_lv_exp(3,23) ->
1205;

get_next_lv_exp(3,24) ->
1356;

get_next_lv_exp(3,25) ->
1526;

get_next_lv_exp(3,26) ->
1717;

get_next_lv_exp(3,27) ->
1932;

get_next_lv_exp(3,28) ->
2174;

get_next_lv_exp(3,29) ->
2446;

get_next_lv_exp(3,30) ->
0;

get_next_lv_exp(4,0) ->
80;

get_next_lv_exp(4,1) ->
90;

get_next_lv_exp(4,2) ->
101;

get_next_lv_exp(4,3) ->
114;

get_next_lv_exp(4,4) ->
128;

get_next_lv_exp(4,5) ->
144;

get_next_lv_exp(4,6) ->
162;

get_next_lv_exp(4,7) ->
182;

get_next_lv_exp(4,8) ->
205;

get_next_lv_exp(4,9) ->
231;

get_next_lv_exp(4,10) ->
260;

get_next_lv_exp(4,11) ->
293;

get_next_lv_exp(4,12) ->
330;

get_next_lv_exp(4,13) ->
371;

get_next_lv_exp(4,14) ->
417;

get_next_lv_exp(4,15) ->
469;

get_next_lv_exp(4,16) ->
528;

get_next_lv_exp(4,17) ->
594;

get_next_lv_exp(4,18) ->
668;

get_next_lv_exp(4,19) ->
752;

get_next_lv_exp(4,20) ->
846;

get_next_lv_exp(4,21) ->
952;

get_next_lv_exp(4,22) ->
1071;

get_next_lv_exp(4,23) ->
1205;

get_next_lv_exp(4,24) ->
1356;

get_next_lv_exp(4,25) ->
1526;

get_next_lv_exp(4,26) ->
1717;

get_next_lv_exp(4,27) ->
1932;

get_next_lv_exp(4,28) ->
2174;

get_next_lv_exp(4,29) ->
2446;

get_next_lv_exp(4,30) ->
0;

get_next_lv_exp(5,0) ->
80;

get_next_lv_exp(5,1) ->
90;

get_next_lv_exp(5,2) ->
101;

get_next_lv_exp(5,3) ->
114;

get_next_lv_exp(5,4) ->
128;

get_next_lv_exp(5,5) ->
144;

get_next_lv_exp(5,6) ->
162;

get_next_lv_exp(5,7) ->
182;

get_next_lv_exp(5,8) ->
205;

get_next_lv_exp(5,9) ->
231;

get_next_lv_exp(5,10) ->
260;

get_next_lv_exp(5,11) ->
293;

get_next_lv_exp(5,12) ->
330;

get_next_lv_exp(5,13) ->
371;

get_next_lv_exp(5,14) ->
417;

get_next_lv_exp(5,15) ->
469;

get_next_lv_exp(5,16) ->
528;

get_next_lv_exp(5,17) ->
594;

get_next_lv_exp(5,18) ->
668;

get_next_lv_exp(5,19) ->
752;

get_next_lv_exp(5,20) ->
846;

get_next_lv_exp(5,21) ->
952;

get_next_lv_exp(5,22) ->
1071;

get_next_lv_exp(5,23) ->
1205;

get_next_lv_exp(5,24) ->
1356;

get_next_lv_exp(5,25) ->
1526;

get_next_lv_exp(5,26) ->
1717;

get_next_lv_exp(5,27) ->
1932;

get_next_lv_exp(5,28) ->
2174;

get_next_lv_exp(5,29) ->
2446;

get_next_lv_exp(5,30) ->
0;

get_next_lv_exp(6,0) ->
80;

get_next_lv_exp(6,1) ->
90;

get_next_lv_exp(6,2) ->
101;

get_next_lv_exp(6,3) ->
114;

get_next_lv_exp(6,4) ->
128;

get_next_lv_exp(6,5) ->
144;

get_next_lv_exp(6,6) ->
162;

get_next_lv_exp(6,7) ->
182;

get_next_lv_exp(6,8) ->
205;

get_next_lv_exp(6,9) ->
231;

get_next_lv_exp(6,10) ->
260;

get_next_lv_exp(6,11) ->
293;

get_next_lv_exp(6,12) ->
330;

get_next_lv_exp(6,13) ->
371;

get_next_lv_exp(6,14) ->
417;

get_next_lv_exp(6,15) ->
469;

get_next_lv_exp(6,16) ->
528;

get_next_lv_exp(6,17) ->
594;

get_next_lv_exp(6,18) ->
668;

get_next_lv_exp(6,19) ->
752;

get_next_lv_exp(6,20) ->
846;

get_next_lv_exp(6,21) ->
952;

get_next_lv_exp(6,22) ->
1071;

get_next_lv_exp(6,23) ->
1205;

get_next_lv_exp(6,24) ->
1356;

get_next_lv_exp(6,25) ->
1526;

get_next_lv_exp(6,26) ->
1717;

get_next_lv_exp(6,27) ->
1932;

get_next_lv_exp(6,28) ->
2174;

get_next_lv_exp(6,29) ->
2446;

get_next_lv_exp(6,30) ->
0;

get_next_lv_exp(7,0) ->
80;

get_next_lv_exp(7,1) ->
90;

get_next_lv_exp(7,2) ->
101;

get_next_lv_exp(7,3) ->
114;

get_next_lv_exp(7,4) ->
128;

get_next_lv_exp(7,5) ->
144;

get_next_lv_exp(7,6) ->
162;

get_next_lv_exp(7,7) ->
182;

get_next_lv_exp(7,8) ->
205;

get_next_lv_exp(7,9) ->
231;

get_next_lv_exp(7,10) ->
260;

get_next_lv_exp(7,11) ->
293;

get_next_lv_exp(7,12) ->
330;

get_next_lv_exp(7,13) ->
371;

get_next_lv_exp(7,14) ->
417;

get_next_lv_exp(7,15) ->
469;

get_next_lv_exp(7,16) ->
528;

get_next_lv_exp(7,17) ->
594;

get_next_lv_exp(7,18) ->
668;

get_next_lv_exp(7,19) ->
752;

get_next_lv_exp(7,20) ->
846;

get_next_lv_exp(7,21) ->
952;

get_next_lv_exp(7,22) ->
1071;

get_next_lv_exp(7,23) ->
1205;

get_next_lv_exp(7,24) ->
1356;

get_next_lv_exp(7,25) ->
1526;

get_next_lv_exp(7,26) ->
1717;

get_next_lv_exp(7,27) ->
1932;

get_next_lv_exp(7,28) ->
2174;

get_next_lv_exp(7,29) ->
2446;

get_next_lv_exp(7,30) ->
0;

get_next_lv_exp(8,0) ->
80;

get_next_lv_exp(8,1) ->
90;

get_next_lv_exp(8,2) ->
101;

get_next_lv_exp(8,3) ->
114;

get_next_lv_exp(8,4) ->
128;

get_next_lv_exp(8,5) ->
144;

get_next_lv_exp(8,6) ->
162;

get_next_lv_exp(8,7) ->
182;

get_next_lv_exp(8,8) ->
205;

get_next_lv_exp(8,9) ->
231;

get_next_lv_exp(8,10) ->
260;

get_next_lv_exp(8,11) ->
293;

get_next_lv_exp(8,12) ->
330;

get_next_lv_exp(8,13) ->
371;

get_next_lv_exp(8,14) ->
417;

get_next_lv_exp(8,15) ->
469;

get_next_lv_exp(8,16) ->
528;

get_next_lv_exp(8,17) ->
594;

get_next_lv_exp(8,18) ->
668;

get_next_lv_exp(8,19) ->
752;

get_next_lv_exp(8,20) ->
846;

get_next_lv_exp(8,21) ->
952;

get_next_lv_exp(8,22) ->
1071;

get_next_lv_exp(8,23) ->
1205;

get_next_lv_exp(8,24) ->
1356;

get_next_lv_exp(8,25) ->
1526;

get_next_lv_exp(8,26) ->
1717;

get_next_lv_exp(8,27) ->
1932;

get_next_lv_exp(8,28) ->
2174;

get_next_lv_exp(8,29) ->
2446;

get_next_lv_exp(8,30) ->
0;

get_next_lv_exp(9,0) ->
80;

get_next_lv_exp(9,1) ->
90;

get_next_lv_exp(9,2) ->
101;

get_next_lv_exp(9,3) ->
114;

get_next_lv_exp(9,4) ->
128;

get_next_lv_exp(9,5) ->
144;

get_next_lv_exp(9,6) ->
162;

get_next_lv_exp(9,7) ->
182;

get_next_lv_exp(9,8) ->
205;

get_next_lv_exp(9,9) ->
231;

get_next_lv_exp(9,10) ->
260;

get_next_lv_exp(9,11) ->
293;

get_next_lv_exp(9,12) ->
330;

get_next_lv_exp(9,13) ->
371;

get_next_lv_exp(9,14) ->
417;

get_next_lv_exp(9,15) ->
469;

get_next_lv_exp(9,16) ->
528;

get_next_lv_exp(9,17) ->
594;

get_next_lv_exp(9,18) ->
668;

get_next_lv_exp(9,19) ->
752;

get_next_lv_exp(9,20) ->
846;

get_next_lv_exp(9,21) ->
952;

get_next_lv_exp(9,22) ->
1071;

get_next_lv_exp(9,23) ->
1205;

get_next_lv_exp(9,24) ->
1356;

get_next_lv_exp(9,25) ->
1526;

get_next_lv_exp(9,26) ->
1717;

get_next_lv_exp(9,27) ->
1932;

get_next_lv_exp(9,28) ->
2174;

get_next_lv_exp(9,29) ->
2446;

get_next_lv_exp(9,30) ->
0;

get_next_lv_exp(10,0) ->
80;

get_next_lv_exp(10,1) ->
90;

get_next_lv_exp(10,2) ->
101;

get_next_lv_exp(10,3) ->
114;

get_next_lv_exp(10,4) ->
128;

get_next_lv_exp(10,5) ->
144;

get_next_lv_exp(10,6) ->
162;

get_next_lv_exp(10,7) ->
182;

get_next_lv_exp(10,8) ->
205;

get_next_lv_exp(10,9) ->
231;

get_next_lv_exp(10,10) ->
260;

get_next_lv_exp(10,11) ->
293;

get_next_lv_exp(10,12) ->
330;

get_next_lv_exp(10,13) ->
371;

get_next_lv_exp(10,14) ->
417;

get_next_lv_exp(10,15) ->
469;

get_next_lv_exp(10,16) ->
528;

get_next_lv_exp(10,17) ->
594;

get_next_lv_exp(10,18) ->
668;

get_next_lv_exp(10,19) ->
752;

get_next_lv_exp(10,20) ->
846;

get_next_lv_exp(10,21) ->
952;

get_next_lv_exp(10,22) ->
1071;

get_next_lv_exp(10,23) ->
1205;

get_next_lv_exp(10,24) ->
1356;

get_next_lv_exp(10,25) ->
1526;

get_next_lv_exp(10,26) ->
1717;

get_next_lv_exp(10,27) ->
1932;

get_next_lv_exp(10,28) ->
2174;

get_next_lv_exp(10,29) ->
2446;

get_next_lv_exp(10,30) ->
0;

get_next_lv_exp(_Pos,_Lv) ->
	[].

get_gathering_attr(1,0) ->
[];

get_gathering_attr(1,1) ->
[{3,640},{5,510}];

get_gathering_attr(1,2) ->
[{3,1280},{5,1020}];

get_gathering_attr(1,3) ->
[{3,1920},{5,1530}];

get_gathering_attr(1,4) ->
[{3,2560},{5,2040}];

get_gathering_attr(1,5) ->
[{3,3200},{5,2550}];

get_gathering_attr(1,6) ->
[{3,3840},{5,3060}];

get_gathering_attr(1,7) ->
[{3,4480},{5,3570}];

get_gathering_attr(1,8) ->
[{3,5120},{5,4080}];

get_gathering_attr(1,9) ->
[{3,5760},{5,4590}];

get_gathering_attr(1,10) ->
[{3,6400},{5,5100}];

get_gathering_attr(1,11) ->
[{3,7040},{5,5610}];

get_gathering_attr(1,12) ->
[{3,7680},{5,6120}];

get_gathering_attr(1,13) ->
[{3,8320},{5,6630}];

get_gathering_attr(1,14) ->
[{3,8960},{5,7140}];

get_gathering_attr(1,15) ->
[{3,9600},{5,7650}];

get_gathering_attr(1,16) ->
[{3,10240},{5,8160}];

get_gathering_attr(1,17) ->
[{3,10880},{5,8670}];

get_gathering_attr(1,18) ->
[{3,11520},{5,9180}];

get_gathering_attr(1,19) ->
[{3,12160},{5,9690}];

get_gathering_attr(1,20) ->
[{3,12800},{5,10200}];

get_gathering_attr(1,21) ->
[{3,13440},{5,10710}];

get_gathering_attr(1,22) ->
[{3,14080},{5,11220}];

get_gathering_attr(1,23) ->
[{3,14720},{5,11730}];

get_gathering_attr(1,24) ->
[{3,15360},{5,12240}];

get_gathering_attr(1,25) ->
[{3,16000},{5,12750}];

get_gathering_attr(1,26) ->
[{3,16640},{5,13260}];

get_gathering_attr(1,27) ->
[{3,17280},{5,13770}];

get_gathering_attr(1,28) ->
[{3,17920},{5,14280}];

get_gathering_attr(1,29) ->
[{3,18560},{5,14790}];

get_gathering_attr(1,30) ->
[{3,19200},{5,15300}];

get_gathering_attr(2,0) ->
[];

get_gathering_attr(2,1) ->
[{4,480},{8,385}];

get_gathering_attr(2,2) ->
[{4,960},{8,770}];

get_gathering_attr(2,3) ->
[{4,1440},{8,1155}];

get_gathering_attr(2,4) ->
[{4,1920},{8,1540}];

get_gathering_attr(2,5) ->
[{4,2400},{8,1925}];

get_gathering_attr(2,6) ->
[{4,2880},{8,2310}];

get_gathering_attr(2,7) ->
[{4,3360},{8,2695}];

get_gathering_attr(2,8) ->
[{4,3840},{8,3080}];

get_gathering_attr(2,9) ->
[{4,4320},{8,3465}];

get_gathering_attr(2,10) ->
[{4,4800},{8,3850}];

get_gathering_attr(2,11) ->
[{4,5280},{8,4235}];

get_gathering_attr(2,12) ->
[{4,5760},{8,4620}];

get_gathering_attr(2,13) ->
[{4,6240},{8,5005}];

get_gathering_attr(2,14) ->
[{4,6720},{8,5390}];

get_gathering_attr(2,15) ->
[{4,7200},{8,5775}];

get_gathering_attr(2,16) ->
[{4,7680},{8,6160}];

get_gathering_attr(2,17) ->
[{4,8160},{8,6545}];

get_gathering_attr(2,18) ->
[{4,8640},{8,6930}];

get_gathering_attr(2,19) ->
[{4,9120},{8,7315}];

get_gathering_attr(2,20) ->
[{4,9600},{8,7700}];

get_gathering_attr(2,21) ->
[{4,10080},{8,8085}];

get_gathering_attr(2,22) ->
[{4,10560},{8,8470}];

get_gathering_attr(2,23) ->
[{4,11040},{8,8855}];

get_gathering_attr(2,24) ->
[{4,11520},{8,9240}];

get_gathering_attr(2,25) ->
[{4,12000},{8,9625}];

get_gathering_attr(2,26) ->
[{4,12480},{8,10010}];

get_gathering_attr(2,27) ->
[{4,12960},{8,10395}];

get_gathering_attr(2,28) ->
[{4,13440},{8,10780}];

get_gathering_attr(2,29) ->
[{4,13920},{8,11165}];

get_gathering_attr(2,30) ->
[{4,14400},{8,11550}];

get_gathering_attr(3,0) ->
[];

get_gathering_attr(3,1) ->
[{3,640},{7,320}];

get_gathering_attr(3,2) ->
[{3,1280},{7,640}];

get_gathering_attr(3,3) ->
[{3,1920},{7,960}];

get_gathering_attr(3,4) ->
[{3,2560},{7,1280}];

get_gathering_attr(3,5) ->
[{3,3200},{7,1600}];

get_gathering_attr(3,6) ->
[{3,3840},{7,1920}];

get_gathering_attr(3,7) ->
[{3,4480},{7,2240}];

get_gathering_attr(3,8) ->
[{3,5120},{7,2560}];

get_gathering_attr(3,9) ->
[{3,5760},{7,2880}];

get_gathering_attr(3,10) ->
[{3,6400},{7,3200}];

get_gathering_attr(3,11) ->
[{3,7040},{7,3520}];

get_gathering_attr(3,12) ->
[{3,7680},{7,3840}];

get_gathering_attr(3,13) ->
[{3,8320},{7,4160}];

get_gathering_attr(3,14) ->
[{3,8960},{7,4480}];

get_gathering_attr(3,15) ->
[{3,9600},{7,4800}];

get_gathering_attr(3,16) ->
[{3,10240},{7,5120}];

get_gathering_attr(3,17) ->
[{3,10880},{7,5440}];

get_gathering_attr(3,18) ->
[{3,11520},{7,5760}];

get_gathering_attr(3,19) ->
[{3,12160},{7,6080}];

get_gathering_attr(3,20) ->
[{3,12800},{7,6400}];

get_gathering_attr(3,21) ->
[{3,13440},{7,6720}];

get_gathering_attr(3,22) ->
[{3,14080},{7,7040}];

get_gathering_attr(3,23) ->
[{3,14720},{7,7360}];

get_gathering_attr(3,24) ->
[{3,15360},{7,7680}];

get_gathering_attr(3,25) ->
[{3,16000},{7,8000}];

get_gathering_attr(3,26) ->
[{3,16640},{7,8320}];

get_gathering_attr(3,27) ->
[{3,17280},{7,8640}];

get_gathering_attr(3,28) ->
[{3,17920},{7,8960}];

get_gathering_attr(3,29) ->
[{3,18560},{7,9280}];

get_gathering_attr(3,30) ->
[{3,19200},{7,9600}];

get_gathering_attr(4,0) ->
[];

get_gathering_attr(4,1) ->
[{2,12000},{8,320}];

get_gathering_attr(4,2) ->
[{2,24000},{8,640}];

get_gathering_attr(4,3) ->
[{2,36000},{8,960}];

get_gathering_attr(4,4) ->
[{2,48000},{8,1280}];

get_gathering_attr(4,5) ->
[{2,60000},{8,1600}];

get_gathering_attr(4,6) ->
[{2,72000},{8,1920}];

get_gathering_attr(4,7) ->
[{2,84000},{8,2240}];

get_gathering_attr(4,8) ->
[{2,96000},{8,2560}];

get_gathering_attr(4,9) ->
[{2,108000},{8,2880}];

get_gathering_attr(4,10) ->
[{2,120000},{8,3200}];

get_gathering_attr(4,11) ->
[{2,132000},{8,3520}];

get_gathering_attr(4,12) ->
[{2,144000},{8,3840}];

get_gathering_attr(4,13) ->
[{2,156000},{8,4160}];

get_gathering_attr(4,14) ->
[{2,168000},{8,4480}];

get_gathering_attr(4,15) ->
[{2,180000},{8,4800}];

get_gathering_attr(4,16) ->
[{2,192000},{8,5120}];

get_gathering_attr(4,17) ->
[{2,204000},{8,5440}];

get_gathering_attr(4,18) ->
[{2,216000},{8,5760}];

get_gathering_attr(4,19) ->
[{2,228000},{8,6080}];

get_gathering_attr(4,20) ->
[{2,240000},{8,6400}];

get_gathering_attr(4,21) ->
[{2,252000},{8,6720}];

get_gathering_attr(4,22) ->
[{2,264000},{8,7040}];

get_gathering_attr(4,23) ->
[{2,276000},{8,7360}];

get_gathering_attr(4,24) ->
[{2,288000},{8,7680}];

get_gathering_attr(4,25) ->
[{2,300000},{8,8000}];

get_gathering_attr(4,26) ->
[{2,312000},{8,8320}];

get_gathering_attr(4,27) ->
[{2,324000},{8,8640}];

get_gathering_attr(4,28) ->
[{2,336000},{8,8960}];

get_gathering_attr(4,29) ->
[{2,348000},{8,9280}];

get_gathering_attr(4,30) ->
[{2,360000},{8,9600}];

get_gathering_attr(5,0) ->
[];

get_gathering_attr(5,1) ->
[{1,800},{2,16000}];

get_gathering_attr(5,2) ->
[{1,1600},{2,32000}];

get_gathering_attr(5,3) ->
[{1,2400},{2,48000}];

get_gathering_attr(5,4) ->
[{1,3200},{2,64000}];

get_gathering_attr(5,5) ->
[{1,4000},{2,80000}];

get_gathering_attr(5,6) ->
[{1,4800},{2,96000}];

get_gathering_attr(5,7) ->
[{1,5600},{2,112000}];

get_gathering_attr(5,8) ->
[{1,6400},{2,128000}];

get_gathering_attr(5,9) ->
[{1,7200},{2,144000}];

get_gathering_attr(5,10) ->
[{1,8000},{2,160000}];

get_gathering_attr(5,11) ->
[{1,8800},{2,176000}];

get_gathering_attr(5,12) ->
[{1,9600},{2,192000}];

get_gathering_attr(5,13) ->
[{1,10400},{2,208000}];

get_gathering_attr(5,14) ->
[{1,11200},{2,224000}];

get_gathering_attr(5,15) ->
[{1,12000},{2,240000}];

get_gathering_attr(5,16) ->
[{1,12800},{2,256000}];

get_gathering_attr(5,17) ->
[{1,13600},{2,272000}];

get_gathering_attr(5,18) ->
[{1,14400},{2,288000}];

get_gathering_attr(5,19) ->
[{1,15200},{2,304000}];

get_gathering_attr(5,20) ->
[{1,16000},{2,320000}];

get_gathering_attr(5,21) ->
[{1,16800},{2,336000}];

get_gathering_attr(5,22) ->
[{1,17600},{2,352000}];

get_gathering_attr(5,23) ->
[{1,18400},{2,368000}];

get_gathering_attr(5,24) ->
[{1,19200},{2,384000}];

get_gathering_attr(5,25) ->
[{1,20000},{2,400000}];

get_gathering_attr(5,26) ->
[{1,20800},{2,416000}];

get_gathering_attr(5,27) ->
[{1,21600},{2,432000}];

get_gathering_attr(5,28) ->
[{1,22400},{2,448000}];

get_gathering_attr(5,29) ->
[{1,23200},{2,464000}];

get_gathering_attr(5,30) ->
[{1,24000},{2,480000}];

get_gathering_attr(6,0) ->
[];

get_gathering_attr(6,1) ->
[{2,12000},{6,255}];

get_gathering_attr(6,2) ->
[{2,24000},{6,510}];

get_gathering_attr(6,3) ->
[{2,36000},{6,765}];

get_gathering_attr(6,4) ->
[{2,48000},{6,1020}];

get_gathering_attr(6,5) ->
[{2,60000},{6,1275}];

get_gathering_attr(6,6) ->
[{2,72000},{6,1530}];

get_gathering_attr(6,7) ->
[{2,84000},{6,1785}];

get_gathering_attr(6,8) ->
[{2,96000},{6,2040}];

get_gathering_attr(6,9) ->
[{2,108000},{6,2295}];

get_gathering_attr(6,10) ->
[{2,120000},{6,2550}];

get_gathering_attr(6,11) ->
[{2,132000},{6,2805}];

get_gathering_attr(6,12) ->
[{2,144000},{6,3060}];

get_gathering_attr(6,13) ->
[{2,156000},{6,3315}];

get_gathering_attr(6,14) ->
[{2,168000},{6,3570}];

get_gathering_attr(6,15) ->
[{2,180000},{6,3825}];

get_gathering_attr(6,16) ->
[{2,192000},{6,4080}];

get_gathering_attr(6,17) ->
[{2,204000},{6,4335}];

get_gathering_attr(6,18) ->
[{2,216000},{6,4590}];

get_gathering_attr(6,19) ->
[{2,228000},{6,4845}];

get_gathering_attr(6,20) ->
[{2,240000},{6,5100}];

get_gathering_attr(6,21) ->
[{2,252000},{6,5355}];

get_gathering_attr(6,22) ->
[{2,264000},{6,5610}];

get_gathering_attr(6,23) ->
[{2,276000},{6,5865}];

get_gathering_attr(6,24) ->
[{2,288000},{6,6120}];

get_gathering_attr(6,25) ->
[{2,300000},{6,6375}];

get_gathering_attr(6,26) ->
[{2,312000},{6,6630}];

get_gathering_attr(6,27) ->
[{2,324000},{6,6885}];

get_gathering_attr(6,28) ->
[{2,336000},{6,7140}];

get_gathering_attr(6,29) ->
[{2,348000},{6,7395}];

get_gathering_attr(6,30) ->
[{2,360000},{6,7650}];

get_gathering_attr(7,0) ->
[];

get_gathering_attr(7,1) ->
[{1,600},{7,640}];

get_gathering_attr(7,2) ->
[{1,1200},{7,1280}];

get_gathering_attr(7,3) ->
[{1,1800},{7,1920}];

get_gathering_attr(7,4) ->
[{1,2400},{7,2560}];

get_gathering_attr(7,5) ->
[{1,3000},{7,3200}];

get_gathering_attr(7,6) ->
[{1,3600},{7,3840}];

get_gathering_attr(7,7) ->
[{1,4200},{7,4480}];

get_gathering_attr(7,8) ->
[{1,4800},{7,5120}];

get_gathering_attr(7,9) ->
[{1,5400},{7,5760}];

get_gathering_attr(7,10) ->
[{1,6000},{7,6400}];

get_gathering_attr(7,11) ->
[{1,6600},{7,7040}];

get_gathering_attr(7,12) ->
[{1,7200},{7,7680}];

get_gathering_attr(7,13) ->
[{1,7800},{7,8320}];

get_gathering_attr(7,14) ->
[{1,8400},{7,8960}];

get_gathering_attr(7,15) ->
[{1,9000},{7,9600}];

get_gathering_attr(7,16) ->
[{1,9600},{7,10240}];

get_gathering_attr(7,17) ->
[{1,10200},{7,10880}];

get_gathering_attr(7,18) ->
[{1,10800},{7,11520}];

get_gathering_attr(7,19) ->
[{1,11400},{7,12160}];

get_gathering_attr(7,20) ->
[{1,12000},{7,12800}];

get_gathering_attr(7,21) ->
[{1,12600},{7,13440}];

get_gathering_attr(7,22) ->
[{1,13200},{7,14080}];

get_gathering_attr(7,23) ->
[{1,13800},{7,14720}];

get_gathering_attr(7,24) ->
[{1,14400},{7,15360}];

get_gathering_attr(7,25) ->
[{1,15000},{7,16000}];

get_gathering_attr(7,26) ->
[{1,15600},{7,16640}];

get_gathering_attr(7,27) ->
[{1,16200},{7,17280}];

get_gathering_attr(7,28) ->
[{1,16800},{7,17920}];

get_gathering_attr(7,29) ->
[{1,17400},{7,18560}];

get_gathering_attr(7,30) ->
[{1,18000},{7,19200}];

get_gathering_attr(8,0) ->
[];

get_gathering_attr(8,1) ->
[{4,480},{6,385}];

get_gathering_attr(8,2) ->
[{4,960},{6,770}];

get_gathering_attr(8,3) ->
[{4,1440},{6,1155}];

get_gathering_attr(8,4) ->
[{4,1920},{6,1540}];

get_gathering_attr(8,5) ->
[{4,2400},{6,1925}];

get_gathering_attr(8,6) ->
[{4,2880},{6,2310}];

get_gathering_attr(8,7) ->
[{4,3360},{6,2695}];

get_gathering_attr(8,8) ->
[{4,3840},{6,3080}];

get_gathering_attr(8,9) ->
[{4,4320},{6,3465}];

get_gathering_attr(8,10) ->
[{4,4800},{6,3850}];

get_gathering_attr(8,11) ->
[{4,5280},{6,4235}];

get_gathering_attr(8,12) ->
[{4,5760},{6,4620}];

get_gathering_attr(8,13) ->
[{4,6240},{6,5005}];

get_gathering_attr(8,14) ->
[{4,6720},{6,5390}];

get_gathering_attr(8,15) ->
[{4,7200},{6,5775}];

get_gathering_attr(8,16) ->
[{4,7680},{6,6160}];

get_gathering_attr(8,17) ->
[{4,8160},{6,6545}];

get_gathering_attr(8,18) ->
[{4,8640},{6,6930}];

get_gathering_attr(8,19) ->
[{4,9120},{6,7315}];

get_gathering_attr(8,20) ->
[{4,9600},{6,7700}];

get_gathering_attr(8,21) ->
[{4,10080},{6,8085}];

get_gathering_attr(8,22) ->
[{4,10560},{6,8470}];

get_gathering_attr(8,23) ->
[{4,11040},{6,8855}];

get_gathering_attr(8,24) ->
[{4,11520},{6,9240}];

get_gathering_attr(8,25) ->
[{4,12000},{6,9625}];

get_gathering_attr(8,26) ->
[{4,12480},{6,10010}];

get_gathering_attr(8,27) ->
[{4,12960},{6,10395}];

get_gathering_attr(8,28) ->
[{4,13440},{6,10780}];

get_gathering_attr(8,29) ->
[{4,13920},{6,11165}];

get_gathering_attr(8,30) ->
[{4,14400},{6,11550}];

get_gathering_attr(9,0) ->
[];

get_gathering_attr(9,1) ->
[{1,600},{3,320}];

get_gathering_attr(9,2) ->
[{1,1200},{3,640}];

get_gathering_attr(9,3) ->
[{1,1800},{3,960}];

get_gathering_attr(9,4) ->
[{1,2400},{3,1280}];

get_gathering_attr(9,5) ->
[{1,3000},{3,1600}];

get_gathering_attr(9,6) ->
[{1,3600},{3,1920}];

get_gathering_attr(9,7) ->
[{1,4200},{3,2240}];

get_gathering_attr(9,8) ->
[{1,4800},{3,2560}];

get_gathering_attr(9,9) ->
[{1,5400},{3,2880}];

get_gathering_attr(9,10) ->
[{1,6000},{3,3200}];

get_gathering_attr(9,11) ->
[{1,6600},{3,3520}];

get_gathering_attr(9,12) ->
[{1,7200},{3,3840}];

get_gathering_attr(9,13) ->
[{1,7800},{3,4160}];

get_gathering_attr(9,14) ->
[{1,8400},{3,4480}];

get_gathering_attr(9,15) ->
[{1,9000},{3,4800}];

get_gathering_attr(9,16) ->
[{1,9600},{3,5120}];

get_gathering_attr(9,17) ->
[{1,10200},{3,5440}];

get_gathering_attr(9,18) ->
[{1,10800},{3,5760}];

get_gathering_attr(9,19) ->
[{1,11400},{3,6080}];

get_gathering_attr(9,20) ->
[{1,12000},{3,6400}];

get_gathering_attr(9,21) ->
[{1,12600},{3,6720}];

get_gathering_attr(9,22) ->
[{1,13200},{3,7040}];

get_gathering_attr(9,23) ->
[{1,13800},{3,7360}];

get_gathering_attr(9,24) ->
[{1,14400},{3,7680}];

get_gathering_attr(9,25) ->
[{1,15000},{3,8000}];

get_gathering_attr(9,26) ->
[{1,15600},{3,8320}];

get_gathering_attr(9,27) ->
[{1,16200},{3,8640}];

get_gathering_attr(9,28) ->
[{1,16800},{3,8960}];

get_gathering_attr(9,29) ->
[{1,17400},{3,9280}];

get_gathering_attr(9,30) ->
[{1,18000},{3,9600}];

get_gathering_attr(10,0) ->
[];

get_gathering_attr(10,1) ->
[{4,640},{8,320}];

get_gathering_attr(10,2) ->
[{4,1280},{8,640}];

get_gathering_attr(10,3) ->
[{4,1920},{8,960}];

get_gathering_attr(10,4) ->
[{4,2560},{8,1280}];

get_gathering_attr(10,5) ->
[{4,3200},{8,1600}];

get_gathering_attr(10,6) ->
[{4,3840},{8,1920}];

get_gathering_attr(10,7) ->
[{4,4480},{8,2240}];

get_gathering_attr(10,8) ->
[{4,5120},{8,2560}];

get_gathering_attr(10,9) ->
[{4,5760},{8,2880}];

get_gathering_attr(10,10) ->
[{4,6400},{8,3200}];

get_gathering_attr(10,11) ->
[{4,7040},{8,3520}];

get_gathering_attr(10,12) ->
[{4,7680},{8,3840}];

get_gathering_attr(10,13) ->
[{4,8320},{8,4160}];

get_gathering_attr(10,14) ->
[{4,8960},{8,4480}];

get_gathering_attr(10,15) ->
[{4,9600},{8,4800}];

get_gathering_attr(10,16) ->
[{4,10240},{8,5120}];

get_gathering_attr(10,17) ->
[{4,10880},{8,5440}];

get_gathering_attr(10,18) ->
[{4,11520},{8,5760}];

get_gathering_attr(10,19) ->
[{4,12160},{8,6080}];

get_gathering_attr(10,20) ->
[{4,12800},{8,6400}];

get_gathering_attr(10,21) ->
[{4,13440},{8,6720}];

get_gathering_attr(10,22) ->
[{4,14080},{8,7040}];

get_gathering_attr(10,23) ->
[{4,14720},{8,7360}];

get_gathering_attr(10,24) ->
[{4,15360},{8,7680}];

get_gathering_attr(10,25) ->
[{4,16000},{8,8000}];

get_gathering_attr(10,26) ->
[{4,16640},{8,8320}];

get_gathering_attr(10,27) ->
[{4,17280},{8,8640}];

get_gathering_attr(10,28) ->
[{4,17920},{8,8960}];

get_gathering_attr(10,29) ->
[{4,18560},{8,9280}];

get_gathering_attr(10,30) ->
[{4,19200},{8,9600}];

get_gathering_attr(_Pos,_Lv) ->
	[].

get_skill_lv_list() ->
[30,20,10,5].


get_skill(5) ->
[{400101,1}];


get_skill(10) ->
[{400101,2}];


get_skill(20) ->
[{400101,3}];


get_skill(30) ->
[{400101,4}];

get_skill(_Lv) ->
	[].


get_exp_by_goods_id(38310001) ->
10;


get_exp_by_goods_id(38310002) ->
10;


get_exp_by_goods_id(38310003) ->
10;


get_exp_by_goods_id(38310004) ->
10;


get_exp_by_goods_id(38310005) ->
10;


get_exp_by_goods_id(38310006) ->
10;


get_exp_by_goods_id(38310007) ->
10;


get_exp_by_goods_id(38310008) ->
10;


get_exp_by_goods_id(38310009) ->
10;


get_exp_by_goods_id(38310010) ->
10;


get_exp_by_goods_id(72010001) ->
50;


get_exp_by_goods_id(72010002) ->
250;


get_exp_by_goods_id(72010003) ->
1000;


get_exp_by_goods_id(72010004) ->
3000;


get_exp_by_goods_id(72020001) ->
50;


get_exp_by_goods_id(72020002) ->
250;


get_exp_by_goods_id(72020003) ->
1000;


get_exp_by_goods_id(72020004) ->
3000;


get_exp_by_goods_id(72030001) ->
50;


get_exp_by_goods_id(72030002) ->
250;


get_exp_by_goods_id(72030003) ->
1000;


get_exp_by_goods_id(72030004) ->
3000;


get_exp_by_goods_id(72040001) ->
50;


get_exp_by_goods_id(72040002) ->
250;


get_exp_by_goods_id(72040003) ->
1000;


get_exp_by_goods_id(72040004) ->
3000;


get_exp_by_goods_id(72050001) ->
50;


get_exp_by_goods_id(72050002) ->
250;


get_exp_by_goods_id(72050003) ->
1000;


get_exp_by_goods_id(72050004) ->
3000;


get_exp_by_goods_id(72060001) ->
50;


get_exp_by_goods_id(72060002) ->
250;


get_exp_by_goods_id(72060003) ->
1000;


get_exp_by_goods_id(72060004) ->
3000;


get_exp_by_goods_id(72070001) ->
50;


get_exp_by_goods_id(72070002) ->
250;


get_exp_by_goods_id(72070003) ->
1000;


get_exp_by_goods_id(72070004) ->
3000;


get_exp_by_goods_id(72080001) ->
50;


get_exp_by_goods_id(72080002) ->
250;


get_exp_by_goods_id(72080003) ->
1000;


get_exp_by_goods_id(72080004) ->
3000;


get_exp_by_goods_id(72090001) ->
50;


get_exp_by_goods_id(72090002) ->
250;


get_exp_by_goods_id(72090003) ->
1000;


get_exp_by_goods_id(72090004) ->
3000;


get_exp_by_goods_id(72100001) ->
50;


get_exp_by_goods_id(72100002) ->
250;


get_exp_by_goods_id(72100003) ->
1000;


get_exp_by_goods_id(72100004) ->
3000;

get_exp_by_goods_id(_Goodsid) ->
	0.

