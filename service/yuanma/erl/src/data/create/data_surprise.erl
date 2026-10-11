%%%---------------------------------------
%%% module      : data_surprise
%%% description : 惊喜礼包配置
%%%
%%%---------------------------------------
-module(data_surprise).
-compile(export_all).
-include("surprise_gift.hrl").




get_surprise_kv(1) ->
4;


get_surprise_kv(2) ->
1;


get_surprise_kv(3) ->
100;


get_surprise_kv(4) ->
[{0,12010007,1}];


get_surprise_kv(5) ->
[{0,17030105,30}];


get_surprise_kv(6) ->
[{0,18030108,30}];


get_surprise_kv(7) ->
[{0,16030108,30}];


get_surprise_kv(8) ->
60;


get_surprise_kv(9) ->
120;

get_surprise_kv(_Key) ->
	[].

get_surprise_gift(1) ->
	#surprise_gift_cfg{gift_id = 1,gift_dec = "超帅时装",gift_price = [{1,0,2880},{1,0,1880}],gift_reward = [{1,[{0,12010007,1}]},{2,[{0,12010007,1}]}],return_gold = [{1,0,12}],return_day = 158,model_id = {0,1107,1},model_power = 9000};

get_surprise_gift(2) ->
	#surprise_gift_cfg{gift_id = 2,gift_dec = "斗花魁",gift_price = [{1,0,8888},{1,0,5888}],gift_reward = [{1,[{0,17030105,30}]},{2,[{0,17030105,30}]}],return_gold = [{1,0,35}],return_day = 169,model_id = {7,1014,1},model_power = 15000};

get_surprise_gift(3) ->
	#surprise_gift_cfg{gift_id = 3,gift_dec = "流鸢之羽",gift_price = [{1,0,13888},{1,0,8888}],gift_reward = [{1,[{0,18030108,30}]},{2,[{0,18030108,30}]}],return_gold = [{1,0,50}],return_day = 178,model_id = {3,1027,1},model_power = 24000};

get_surprise_gift(4) ->
	#surprise_gift_cfg{gift_id = 4,gift_dec = "蓝鹊秋千",gift_price = [{1,0,18888},{1,0,12888}],gift_reward = [{1,[{0,16030108,30}]},{2,[{0,16030108,30}]}],return_gold = [{1,0,75}],return_day = 172,model_id = {2,1018,1},model_power = 30000};

get_surprise_gift(_Giftid) ->
	[].

get_max_gift_num() -> 4.

get_surprise_gift_draw(1,1) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 1,reward_weigh = 120000,reward_list = [{0,19030002,1}],is_tv = 1};

get_surprise_gift_draw(1,2) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 2,reward_weigh = 200,reward_list = [{0,37010003,1}],is_tv = 0};

get_surprise_gift_draw(1,3) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 3,reward_weigh = 500,reward_list = [{0,12010003,1}],is_tv = 0};

get_surprise_gift_draw(1,4) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 4,reward_weigh = 500,reward_list = [{0,12020003,1}],is_tv = 0};

get_surprise_gift_draw(1,5) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 5,reward_weigh = 20,reward_list = [{0,7120101,30}],is_tv = 0};

get_surprise_gift_draw(1,6) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 6,reward_weigh = 800,reward_list = [{0,16010001,1}],is_tv = 0};

get_surprise_gift_draw(1,7) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 7,reward_weigh = 800,reward_list = [{0,16010002,1}],is_tv = 0};

get_surprise_gift_draw(1,8) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 8,reward_weigh = 1000,reward_list = [{0,36255006,10}],is_tv = 0};

get_surprise_gift_draw(1,9) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 9,reward_weigh = 1000,reward_list = [{0,20010001,1}],is_tv = 0};

get_surprise_gift_draw(1,10) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 10,reward_weigh = 1000,reward_list = [{0,20010002,1}],is_tv = 0};

get_surprise_gift_draw(1,11) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 11,reward_weigh = 1000,reward_list = [{0,39050502,1}],is_tv = 0};

get_surprise_gift_draw(1,12) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 12,reward_weigh = 1000,reward_list = [{0,20020002,1}],is_tv = 0};

get_surprise_gift_draw(1,13) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 13,reward_weigh = 1000,reward_list = [{0,38240301,5}],is_tv = 0};

get_surprise_gift_draw(1,14) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 14,reward_weigh = 1000,reward_list = [{0,32010185,1}],is_tv = 0};

get_surprise_gift_draw(1,15) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 15,reward_weigh = 1500,reward_list = [{0,36255006,1}],is_tv = 0};

get_surprise_gift_draw(1,16) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 16,reward_weigh = 1500,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(1,17) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 17,reward_weigh = 1500,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(1,18) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 18,reward_weigh = 1500,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(1,19) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 19,reward_weigh = 1500,reward_list = [{0,32010185,1}],is_tv = 0};

get_surprise_gift_draw(1,20) ->
	#surprise_gift_draw{turn_id = 1,gift_id = 20,reward_weigh = 1500,reward_list = [{0,36255007,10}],is_tv = 0};

get_surprise_gift_draw(2,1) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 1,reward_weigh = 100,reward_list = [{0,17030105,30}],is_tv = 1};

get_surprise_gift_draw(2,2) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 2,reward_weigh = 100,reward_list = [{0,12010006,1}],is_tv = 0};

get_surprise_gift_draw(2,3) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 3,reward_weigh = 400,reward_list = [{0,12020006,1}],is_tv = 0};

get_surprise_gift_draw(2,4) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 4,reward_weigh = 400,reward_list = [{0,5901001,1}],is_tv = 0};

get_surprise_gift_draw(2,5) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 5,reward_weigh = 400,reward_list = [{0,5902001,1}],is_tv = 0};

get_surprise_gift_draw(2,6) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 6,reward_weigh = 800,reward_list = [{0,39040502,1}],is_tv = 0};

get_surprise_gift_draw(2,7) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 7,reward_weigh = 800,reward_list = [{0,36255006,10}],is_tv = 0};

get_surprise_gift_draw(2,8) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 8,reward_weigh = 1000,reward_list = [{0,16010001,1}],is_tv = 0};

get_surprise_gift_draw(2,9) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 9,reward_weigh = 1000,reward_list = [{0,16010002,1}],is_tv = 0};

get_surprise_gift_draw(2,10) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 10,reward_weigh = 1000,reward_list = [{0,19020002,1}],is_tv = 0};

get_surprise_gift_draw(2,11) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 11,reward_weigh = 1000,reward_list = [{0,19020001,1}],is_tv = 0};

get_surprise_gift_draw(2,12) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 12,reward_weigh = 1000,reward_list = [{0,23020001,10}],is_tv = 0};

get_surprise_gift_draw(2,13) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255006,1}],is_tv = 0};

get_surprise_gift_draw(2,14) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(2,15) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 15,reward_weigh = 1500,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(2,16) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 16,reward_weigh = 1500,reward_list = [{0,36255007,1}],is_tv = 0};

get_surprise_gift_draw(2,17) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 17,reward_weigh = 1500,reward_list = [{0,37020002,1}],is_tv = 0};

get_surprise_gift_draw(2,18) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 18,reward_weigh = 1500,reward_list = [{0,22020001,30}],is_tv = 0};

get_surprise_gift_draw(2,19) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 19,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(2,20) ->
	#surprise_gift_draw{turn_id = 2,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,188}],is_tv = 0};

get_surprise_gift_draw(3,1) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 1,reward_weigh = 100,reward_list = [{0,20030008,1}],is_tv = 1};

get_surprise_gift_draw(3,2) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 2,reward_weigh = 100,reward_list = [{0,38240027,1}],is_tv = 0};

get_surprise_gift_draw(3,3) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 3,reward_weigh = 400,reward_list = [{0,7120102,30}],is_tv = 0};

get_surprise_gift_draw(3,4) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 4,reward_weigh = 400,reward_list = [{0,12010003,1}],is_tv = 0};

get_surprise_gift_draw(3,5) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 5,reward_weigh = 400,reward_list = [{0,12020003,1}],is_tv = 0};

get_surprise_gift_draw(3,6) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 6,reward_weigh = 800,reward_list = [{0,39020503,1}],is_tv = 0};

get_surprise_gift_draw(3,7) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 7,reward_weigh = 800,reward_list = [{0,32010185,1}],is_tv = 0};

get_surprise_gift_draw(3,8) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 8,reward_weigh = 1000,reward_list = [{0,18010001,1}],is_tv = 0};

get_surprise_gift_draw(3,9) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 9,reward_weigh = 1000,reward_list = [{0,18010002,1}],is_tv = 0};

get_surprise_gift_draw(3,10) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 10,reward_weigh = 1000,reward_list = [{0,18020003,1}],is_tv = 0};

get_surprise_gift_draw(3,11) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 11,reward_weigh = 1000,reward_list = [{0,36255006,1}],is_tv = 0};

get_surprise_gift_draw(3,12) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 12,reward_weigh = 1000,reward_list = [{0,37020002,1}],is_tv = 0};

get_surprise_gift_draw(3,13) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(3,14) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(3,15) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 15,reward_weigh = 1500,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(3,16) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 16,reward_weigh = 1500,reward_list = [{0,18020002,1}],is_tv = 0};

get_surprise_gift_draw(3,17) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 17,reward_weigh = 1500,reward_list = [{0,16020002,1}],is_tv = 0};

get_surprise_gift_draw(3,18) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 18,reward_weigh = 1500,reward_list = [{0,17020002,1}],is_tv = 0};

get_surprise_gift_draw(3,19) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 19,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(3,20) ->
	#surprise_gift_draw{turn_id = 3,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,188}],is_tv = 0};

get_surprise_gift_draw(4,1) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 1,reward_weigh = 100,reward_list = [{0,18030108,30}],is_tv = 1};

get_surprise_gift_draw(4,2) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 2,reward_weigh = 100,reward_list = [{0,12010006,1}],is_tv = 0};

get_surprise_gift_draw(4,3) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 3,reward_weigh = 400,reward_list = [{0,12020006,1}],is_tv = 0};

get_surprise_gift_draw(4,4) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 4,reward_weigh = 400,reward_list = [{0,5901002,1}],is_tv = 0};

get_surprise_gift_draw(4,5) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 5,reward_weigh = 400,reward_list = [{0,5902003,1}],is_tv = 0};

get_surprise_gift_draw(4,6) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 6,reward_weigh = 800,reward_list = [{0,39010503,1}],is_tv = 0};

get_surprise_gift_draw(4,7) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 7,reward_weigh = 800,reward_list = [{0,32010185,1}],is_tv = 0};

get_surprise_gift_draw(4,8) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 8,reward_weigh = 1000,reward_list = [{0,17010001,1}],is_tv = 0};

get_surprise_gift_draw(4,9) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 9,reward_weigh = 1000,reward_list = [{0,17010002,1}],is_tv = 0};

get_surprise_gift_draw(4,10) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 10,reward_weigh = 1000,reward_list = [{0,20020002,1}],is_tv = 0};

get_surprise_gift_draw(4,11) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 11,reward_weigh = 1000,reward_list = [{0,36255006,1}],is_tv = 0};

get_surprise_gift_draw(4,12) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(4,13) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(4,14) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(4,15) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 15,reward_weigh = 1500,reward_list = [{0,23020001,10}],is_tv = 0};

get_surprise_gift_draw(4,16) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 16,reward_weigh = 1500,reward_list = [{0,38040043,1}],is_tv = 0};

get_surprise_gift_draw(4,17) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 17,reward_weigh = 1500,reward_list = [{0,16020002,1}],is_tv = 0};

get_surprise_gift_draw(4,18) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 18,reward_weigh = 1500,reward_list = [{0,18020002,1}],is_tv = 0};

get_surprise_gift_draw(4,19) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 19,reward_weigh = 1500,reward_list = [{0,18020001,50}],is_tv = 0};

get_surprise_gift_draw(4,20) ->
	#surprise_gift_draw{turn_id = 4,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(5,1) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 1,reward_weigh = 100,reward_list = [{0,68010005,30}],is_tv = 1};

get_surprise_gift_draw(5,2) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 2,reward_weigh = 100,reward_list = [{0,68010006,30}],is_tv = 0};

get_surprise_gift_draw(5,3) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 3,reward_weigh = 400,reward_list = [{0,7120102,30}],is_tv = 0};

get_surprise_gift_draw(5,4) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 4,reward_weigh = 400,reward_list = [{0,32070025,5}],is_tv = 0};

get_surprise_gift_draw(5,5) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 5,reward_weigh = 400,reward_list = [{0,32070026,2}],is_tv = 0};

get_surprise_gift_draw(5,6) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 6,reward_weigh = 800,reward_list = [{0,38240027,1}],is_tv = 0};

get_surprise_gift_draw(5,7) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 7,reward_weigh = 800,reward_list = [{0,22030004,50}],is_tv = 0};

get_surprise_gift_draw(5,8) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 8,reward_weigh = 1000,reward_list = [{0,19010001,1}],is_tv = 0};

get_surprise_gift_draw(5,9) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 9,reward_weigh = 1000,reward_list = [{0,19010002,1}],is_tv = 0};

get_surprise_gift_draw(5,10) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 10,reward_weigh = 1000,reward_list = [{0,20020002,1}],is_tv = 0};

get_surprise_gift_draw(5,11) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 11,reward_weigh = 1000,reward_list = [{0,32010185,1}],is_tv = 0};

get_surprise_gift_draw(5,12) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255006,1}],is_tv = 0};

get_surprise_gift_draw(5,13) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(5,14) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(5,15) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 15,reward_weigh = 1500,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(5,16) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 16,reward_weigh = 1500,reward_list = [{0,17020002,1}],is_tv = 0};

get_surprise_gift_draw(5,17) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 17,reward_weigh = 1500,reward_list = [{0,38040043,1}],is_tv = 0};

get_surprise_gift_draw(5,18) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 18,reward_weigh = 1500,reward_list = [{0,38040030,30}],is_tv = 0};

get_surprise_gift_draw(5,19) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 19,reward_weigh = 1500,reward_list = [{0,38040043,1}],is_tv = 0};

get_surprise_gift_draw(5,20) ->
	#surprise_gift_draw{turn_id = 5,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(6,1) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 1,reward_weigh = 100,reward_list = [{0,38240301,10}],is_tv = 1};

get_surprise_gift_draw(6,2) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 2,reward_weigh = 100,reward_list = [{0,32070027,1}],is_tv = 0};

get_surprise_gift_draw(6,3) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 3,reward_weigh = 400,reward_list = [{0,38240027,1}],is_tv = 0};

get_surprise_gift_draw(6,4) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 4,reward_weigh = 400,reward_list = [{0,7302002,30}],is_tv = 0};

get_surprise_gift_draw(6,5) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 5,reward_weigh = 400,reward_list = [{0,5902001,1}],is_tv = 0};

get_surprise_gift_draw(6,6) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 6,reward_weigh = 800,reward_list = [{0,32010205,1}],is_tv = 0};

get_surprise_gift_draw(6,7) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 7,reward_weigh = 800,reward_list = [{0,32010206,1}],is_tv = 0};

get_surprise_gift_draw(6,8) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 8,reward_weigh = 1000,reward_list = [{0,36255006,10}],is_tv = 0};

get_surprise_gift_draw(6,9) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 9,reward_weigh = 1000,reward_list = [{0,16010001,1}],is_tv = 0};

get_surprise_gift_draw(6,10) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 10,reward_weigh = 1000,reward_list = [{0,16010002,1}],is_tv = 0};

get_surprise_gift_draw(6,11) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 11,reward_weigh = 1000,reward_list = [{0,36255006,1}],is_tv = 0};

get_surprise_gift_draw(6,12) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(6,13) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(6,14) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(6,15) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 15,reward_weigh = 1500,reward_list = [{0,17020002,1}],is_tv = 0};

get_surprise_gift_draw(6,16) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 16,reward_weigh = 1500,reward_list = [{0,18020002,1}],is_tv = 0};

get_surprise_gift_draw(6,17) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 17,reward_weigh = 1500,reward_list = [{0,7110002,1}],is_tv = 0};

get_surprise_gift_draw(6,18) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 18,reward_weigh = 1500,reward_list = [{0,7110001,10}],is_tv = 0};

get_surprise_gift_draw(6,19) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 19,reward_weigh = 1500,reward_list = [{0,38040043,1}],is_tv = 0};

get_surprise_gift_draw(6,20) ->
	#surprise_gift_draw{turn_id = 6,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(7,1) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 1,reward_weigh = 100,reward_list = [{0,12020007,1}],is_tv = 1};

get_surprise_gift_draw(7,2) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 2,reward_weigh = 100,reward_list = [{0,38040017,1}],is_tv = 0};

get_surprise_gift_draw(7,3) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 3,reward_weigh = 400,reward_list = [{0,7130111,1}],is_tv = 0};

get_surprise_gift_draw(7,4) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 4,reward_weigh = 400,reward_list = [{0,19030003,1}],is_tv = 0};

get_surprise_gift_draw(7,5) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 5,reward_weigh = 400,reward_list = [{0,68010006,30}],is_tv = 0};

get_surprise_gift_draw(7,6) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 6,reward_weigh = 800,reward_list = [{0,7120102,30}],is_tv = 0};

get_surprise_gift_draw(7,7) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 7,reward_weigh = 800,reward_list = [{0,36255006,10}],is_tv = 0};

get_surprise_gift_draw(7,8) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 8,reward_weigh = 1000,reward_list = [{0,32070028,1}],is_tv = 0};

get_surprise_gift_draw(7,9) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 9,reward_weigh = 1000,reward_list = [{0,19010001,1}],is_tv = 0};

get_surprise_gift_draw(7,10) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 10,reward_weigh = 1000,reward_list = [{0,19010002,1}],is_tv = 0};

get_surprise_gift_draw(7,11) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 11,reward_weigh = 1000,reward_list = [{0,36255031,888}],is_tv = 0};

get_surprise_gift_draw(7,12) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(7,13) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(7,14) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(7,15) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 15,reward_weigh = 1500,reward_list = [{0,23020001,10}],is_tv = 0};

get_surprise_gift_draw(7,16) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 16,reward_weigh = 1500,reward_list = [{0,20020002,1}],is_tv = 0};

get_surprise_gift_draw(7,17) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 17,reward_weigh = 1500,reward_list = [{0,17020002,1}],is_tv = 0};

get_surprise_gift_draw(7,18) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 18,reward_weigh = 1500,reward_list = [{0,16020002,1}],is_tv = 0};

get_surprise_gift_draw(7,19) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 19,reward_weigh = 1500,reward_list = [{0,7110002,1}],is_tv = 0};

get_surprise_gift_draw(7,20) ->
	#surprise_gift_draw{turn_id = 7,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(8,1) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 1,reward_weigh = 100,reward_list = [{0,7120103,40}],is_tv = 1};

get_surprise_gift_draw(8,2) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 2,reward_weigh = 100,reward_list = [{0,12010003,1}],is_tv = 0};

get_surprise_gift_draw(8,3) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 3,reward_weigh = 400,reward_list = [{0,12020003,1}],is_tv = 0};

get_surprise_gift_draw(8,4) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 4,reward_weigh = 400,reward_list = [{0,5901004,1}],is_tv = 0};

get_surprise_gift_draw(8,5) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 5,reward_weigh = 400,reward_list = [{0,5902002,1}],is_tv = 0};

get_surprise_gift_draw(8,6) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 6,reward_weigh = 800,reward_list = [{0,38240027,1}],is_tv = 0};

get_surprise_gift_draw(8,7) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 7,reward_weigh = 800,reward_list = [{0,39010603,1}],is_tv = 0};

get_surprise_gift_draw(8,8) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 8,reward_weigh = 1000,reward_list = [{0,6102001,1}],is_tv = 0};

get_surprise_gift_draw(8,9) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 9,reward_weigh = 1000,reward_list = [{0,20010001,1}],is_tv = 0};

get_surprise_gift_draw(8,10) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 10,reward_weigh = 1000,reward_list = [{0,20010002,1}],is_tv = 0};

get_surprise_gift_draw(8,11) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 11,reward_weigh = 1000,reward_list = [{0,36255031,888}],is_tv = 0};

get_surprise_gift_draw(8,12) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(8,13) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(8,14) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(8,15) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 15,reward_weigh = 1500,reward_list = [{0,7002106,1}],is_tv = 0};

get_surprise_gift_draw(8,16) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 16,reward_weigh = 1500,reward_list = [{0,7001106,1}],is_tv = 0};

get_surprise_gift_draw(8,17) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 17,reward_weigh = 1500,reward_list = [{0,38240301,5}],is_tv = 0};

get_surprise_gift_draw(8,18) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 18,reward_weigh = 1500,reward_list = [{0,38240301,5}],is_tv = 0};

get_surprise_gift_draw(8,19) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 19,reward_weigh = 1500,reward_list = [{0,7110002,1}],is_tv = 0};

get_surprise_gift_draw(8,20) ->
	#surprise_gift_draw{turn_id = 8,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(9,1) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 1,reward_weigh = 100,reward_list = [{0,19030003,1}],is_tv = 1};

get_surprise_gift_draw(9,2) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 2,reward_weigh = 100,reward_list = [{0,16010003,1}],is_tv = 0};

get_surprise_gift_draw(9,3) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 3,reward_weigh = 400,reward_list = [{0,38040020,1}],is_tv = 0};

get_surprise_gift_draw(9,4) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 4,reward_weigh = 400,reward_list = [{0,12010006,1}],is_tv = 0};

get_surprise_gift_draw(9,5) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 5,reward_weigh = 400,reward_list = [{0,12020006,1}],is_tv = 0};

get_surprise_gift_draw(9,6) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 6,reward_weigh = 800,reward_list = [{0,32070029,1}],is_tv = 0};

get_surprise_gift_draw(9,7) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 7,reward_weigh = 800,reward_list = [{0,38300101,30}],is_tv = 0};

get_surprise_gift_draw(9,8) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 8,reward_weigh = 1000,reward_list = [{0,39510010,1}],is_tv = 0};

get_surprise_gift_draw(9,9) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 9,reward_weigh = 1000,reward_list = [{0,17010001,1}],is_tv = 0};

get_surprise_gift_draw(9,10) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 10,reward_weigh = 1000,reward_list = [{0,17010002,1}],is_tv = 0};

get_surprise_gift_draw(9,11) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 11,reward_weigh = 1000,reward_list = [{0,36255031,888}],is_tv = 0};

get_surprise_gift_draw(9,12) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(9,13) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(9,14) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(9,15) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 15,reward_weigh = 1500,reward_list = [{0,18020002,1}],is_tv = 0};

get_surprise_gift_draw(9,16) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 16,reward_weigh = 1500,reward_list = [{0,38040043,1}],is_tv = 0};

get_surprise_gift_draw(9,17) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 17,reward_weigh = 1500,reward_list = [{0,38040030,30}],is_tv = 0};

get_surprise_gift_draw(9,18) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 18,reward_weigh = 1500,reward_list = [{0,32010185,1}],is_tv = 0};

get_surprise_gift_draw(9,19) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 19,reward_weigh = 1500,reward_list = [{0,32010187,1}],is_tv = 0};

get_surprise_gift_draw(9,20) ->
	#surprise_gift_draw{turn_id = 9,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(10,1) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 1,reward_weigh = 100,reward_list = [{0,19030004,1}],is_tv = 1};

get_surprise_gift_draw(10,2) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 2,reward_weigh = 100,reward_list = [{0,68010005,30}],is_tv = 0};

get_surprise_gift_draw(10,3) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 3,reward_weigh = 400,reward_list = [{0,18030004,1}],is_tv = 0};

get_surprise_gift_draw(10,4) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 4,reward_weigh = 400,reward_list = [{0,16030108,30}],is_tv = 0};

get_surprise_gift_draw(10,5) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 5,reward_weigh = 400,reward_list = [{0,35,8888}],is_tv = 0};

get_surprise_gift_draw(10,6) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 6,reward_weigh = 800,reward_list = [{0,32070030,1}],is_tv = 0};

get_surprise_gift_draw(10,7) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 7,reward_weigh = 800,reward_list = [{0,39020603,1}],is_tv = 0};

get_surprise_gift_draw(10,8) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 8,reward_weigh = 1000,reward_list = [{0,68010006,30}],is_tv = 0};

get_surprise_gift_draw(10,9) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 9,reward_weigh = 1000,reward_list = [{0,18010001,1}],is_tv = 0};

get_surprise_gift_draw(10,10) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 10,reward_weigh = 1000,reward_list = [{0,18010002,1}],is_tv = 0};

get_surprise_gift_draw(10,11) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 11,reward_weigh = 1000,reward_list = [{0,7002106,1}],is_tv = 0};

get_surprise_gift_draw(10,12) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 12,reward_weigh = 1000,reward_list = [{0,36255031,2888}],is_tv = 0};

get_surprise_gift_draw(10,13) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 13,reward_weigh = 1000,reward_list = [{0,36255031,1888}],is_tv = 0};

get_surprise_gift_draw(10,14) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 14,reward_weigh = 1000,reward_list = [{0,36255031,888}],is_tv = 0};

get_surprise_gift_draw(10,15) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 15,reward_weigh = 1500,reward_list = [{0,36255031,688}],is_tv = 0};

get_surprise_gift_draw(10,16) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 16,reward_weigh = 1500,reward_list = [{0,36255031,488}],is_tv = 0};

get_surprise_gift_draw(10,17) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 17,reward_weigh = 1500,reward_list = [{0,36255031,288}],is_tv = 0};

get_surprise_gift_draw(10,18) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 18,reward_weigh = 1500,reward_list = [{0,7110002,1}],is_tv = 0};

get_surprise_gift_draw(10,19) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 19,reward_weigh = 1500,reward_list = [{0,38040043,3}],is_tv = 0};

get_surprise_gift_draw(10,20) ->
	#surprise_gift_draw{turn_id = 10,gift_id = 20,reward_weigh = 1500,reward_list = [{0,35,288}],is_tv = 0};

get_surprise_gift_draw(_Turnid,_Giftid) ->
	[].


get_surp_turn_draw(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(3) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(4) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(5) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(6) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(7) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(8) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(9) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];


get_surp_turn_draw(10) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

get_surp_turn_draw(_Turnid) ->
	[].

get_surp_max_turns() -> 10.

