%%%---------------------------------------
%%% module      : data_invite
%%% description : 邀请配置
%%%
%%%---------------------------------------
-module(data_invite).
-compile(export_all).
-include("invite.hrl").




get_kv_value(1) ->
[{2,0,20},{3,0,20000},{0,38040002,50}];


get_kv_value(2) ->
15;


get_kv_value(3) ->
300;


get_kv_value(4) ->
3;


get_kv_value(5) ->
3;


get_kv_value(6) ->
10;


get_kv_value(7) ->
[{10,0},{180,0},{60,1}];


get_kv_value(8) ->
10;


get_kv_value(9) ->
180;


get_kv_value(10) ->
300;


get_kv_value(11) ->
1800;


get_kv_value(12) ->
1800;


get_kv_value(13) ->
[{255,36255001,0.1}];


get_kv_value(14) ->
20;


get_kv_value(15) ->
[10,20,50,60,100,200];


get_kv_value(16) ->
50;

get_kv_value(_Key) ->
	[].

get_box_reward(_Num) when _Num =< 1 ->
		[{0,38040005,10},{0,38040005,10},{2,0,10}];
get_box_reward(_Num) when _Num =< 2 ->
		[{0,38040005,10},{0,38040005,10},{2,0,10}];
get_box_reward(_Num) when _Num =< 3 ->
		[{0,38040005,10},{0,38040005,10},{2,0,10}];
get_box_reward(_Num) when _Num =< 4 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 5 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 6 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 7 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 8 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 9 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 10 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 11 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 12 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 13 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 14 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) when _Num =< 15 ->
		[{0,38040005,5},{0,38040005,5},{3,0,10000}];
get_box_reward(_Num) ->
	[].

get_reward(1,1) ->
	#base_invite_reward{type = 1,reward_id = 1,num = 3,reward = [{3,0,10000},{0,18020001,2},{0,35,5}]};

get_reward(1,2) ->
	#base_invite_reward{type = 1,reward_id = 2,num = 6,reward = [{0,17020001,1},{0,32010001,1},{0,38040005,30}]};

get_reward(1,3) ->
	#base_invite_reward{type = 1,reward_id = 3,num = 9,reward = [{0,18020001,2},{0,16020001,2},{0,38040027,1}]};

get_reward(1,4) ->
	#base_invite_reward{type = 1,reward_id = 4,num = 12,reward = [{0,32010001,1},{0,18020002,1},{0,38040005,40}]};

get_reward(1,5) ->
	#base_invite_reward{type = 1,reward_id = 5,num = 15,reward = [{0,16020001,1},{3,0,30000},{0,38040002,2}]};

get_reward(1,6) ->
	#base_invite_reward{type = 1,reward_id = 6,num = 18,reward = [{0,18020001,5},{0,32010001,1},{3,0,10000}]};

get_reward(1,7) ->
	#base_invite_reward{type = 1,reward_id = 7,num = 21,reward = [{0,17020001,5},{0,32010120,2},{0,38040005,35}]};

get_reward(1,8) ->
	#base_invite_reward{type = 1,reward_id = 8,num = 24,reward = [{0,38061002,1},{0,38040005,40},{0,38040002,1}]};

get_reward(1,9) ->
	#base_invite_reward{type = 1,reward_id = 9,num = 27,reward = [{3,0,40000},{0,16020001,5},{0,38040005,45}]};

get_reward(1,10) ->
	#base_invite_reward{type = 1,reward_id = 10,num = 30,reward = [{0,16010001,1},{0,16020001,5},{0,32010129,2}]};

get_reward(1,11) ->
	#base_invite_reward{type = 1,reward_id = 11,num = 33,reward = [{3,0,20000},{0,18020001,5},{0,35,5}]};

get_reward(1,12) ->
	#base_invite_reward{type = 1,reward_id = 12,num = 36,reward = [{0,17020002,1},{0,32010001,1},{0,38040005,30}]};

get_reward(1,13) ->
	#base_invite_reward{type = 1,reward_id = 13,num = 39,reward = [{0,18020001,5},{0,16020001,5},{0,38040027,1}]};

get_reward(1,14) ->
	#base_invite_reward{type = 1,reward_id = 14,num = 42,reward = [{0,32010001,1},{0,18020002,1},{0,38040005,40}]};

get_reward(1,15) ->
	#base_invite_reward{type = 1,reward_id = 15,num = 45,reward = [{0,16020002,1},{3,0,30000},{0,38040002,2}]};

get_reward(1,16) ->
	#base_invite_reward{type = 1,reward_id = 16,num = 48,reward = [{0,18020001,5},{0,32010001,1},{3,0,10000}]};

get_reward(1,17) ->
	#base_invite_reward{type = 1,reward_id = 17,num = 51,reward = [{0,17020001,5},{0,32010120,2},{0,38040005,35}]};

get_reward(1,18) ->
	#base_invite_reward{type = 1,reward_id = 18,num = 54,reward = [{0,38061002,1},{0,38040005,40},{0,38040002,1}]};

get_reward(1,19) ->
	#base_invite_reward{type = 1,reward_id = 19,num = 57,reward = [{3,0,40000},{0,16020001,5},{0,38040005,45}]};

get_reward(1,20) ->
	#base_invite_reward{type = 1,reward_id = 20,num = 60,reward = [{0,16010001,1},{0,16020001,5},{0,32010129,2}]};

get_reward(1,21) ->
	#base_invite_reward{type = 1,reward_id = 21,num = 63,reward = [{3,0,20000},{0,18020001,5},{0,35,5}]};

get_reward(1,22) ->
	#base_invite_reward{type = 1,reward_id = 22,num = 66,reward = [{0,17020002,1},{0,32010001,1},{0,38040005,30}]};

get_reward(1,23) ->
	#base_invite_reward{type = 1,reward_id = 23,num = 69,reward = [{0,18020001,5},{0,16020001,5},{0,38040027,1}]};

get_reward(1,24) ->
	#base_invite_reward{type = 1,reward_id = 24,num = 72,reward = [{0,32010001,1},{0,18020002,1},{0,38040005,40}]};

get_reward(1,25) ->
	#base_invite_reward{type = 1,reward_id = 25,num = 75,reward = [{0,16020002,1},{3,0,30000},{0,38040002,2}]};

get_reward(1,26) ->
	#base_invite_reward{type = 1,reward_id = 26,num = 78,reward = [{0,18020001,5},{0,32010001,1},{3,0,10000}]};

get_reward(1,27) ->
	#base_invite_reward{type = 1,reward_id = 27,num = 81,reward = [{0,17020001,5},{0,32010120,2},{0,38040005,35}]};

get_reward(1,28) ->
	#base_invite_reward{type = 1,reward_id = 28,num = 84,reward = [{0,38061002,1},{0,38040005,40},{0,38040002,1}]};

get_reward(1,29) ->
	#base_invite_reward{type = 1,reward_id = 29,num = 87,reward = [{3,0,40000},{0,16020001,5},{0,38040005,45}]};

get_reward(1,30) ->
	#base_invite_reward{type = 1,reward_id = 30,num = 90,reward = [{0,16010001,1},{0,16020001,5},{0,32010129,2}]};

get_reward(1,31) ->
	#base_invite_reward{type = 1,reward_id = 31,num = 93,reward = [{3,0,20000},{0,18020001,5},{0,35,5}]};

get_reward(1,32) ->
	#base_invite_reward{type = 1,reward_id = 32,num = 96,reward = [{0,17020002,1},{0,32010001,1},{0,38040005,30}]};

get_reward(1,33) ->
	#base_invite_reward{type = 1,reward_id = 33,num = 99,reward = [{0,18020001,5},{0,16020001,5},{0,38040027,1}]};

get_reward(1,34) ->
	#base_invite_reward{type = 1,reward_id = 34,num = 102,reward = [{0,32010001,1},{0,18020002,1},{0,38040005,40}]};

get_reward(1,35) ->
	#base_invite_reward{type = 1,reward_id = 35,num = 105,reward = [{0,16020002,1},{3,0,30000},{0,38040002,2}]};

get_reward(2,1) ->
	#base_invite_reward{type = 2,reward_id = 1,num = 2,reward = [{255,36255001,500}]};

get_reward(2,2) ->
	#base_invite_reward{type = 2,reward_id = 2,num = 4,reward = [{255,36255001,500}]};

get_reward(2,3) ->
	#base_invite_reward{type = 2,reward_id = 3,num = 6,reward = [{255,36255001,700}]};

get_reward(2,4) ->
	#base_invite_reward{type = 2,reward_id = 4,num = 8,reward = [{255,36255001,1000}]};

get_reward(3,1) ->
	#base_invite_reward{type = 3,reward_id = 1,num = 1,reward = [{0,38061002,1},{0,32010069,1},{2,0,10},{3,0,10000},{0,38040005,10}]};

get_reward(_Type,_Rewardid) ->
	[].

get_reward_key_list() ->
[{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{1,8},{1,9},{1,10},{1,11},{1,12},{1,13},{1,14},{1,15},{1,16},{1,17},{1,18},{1,19},{1,20},{1,21},{1,22},{1,23},{1,24},{1,25},{1,26},{1,27},{1,28},{1,29},{1,30},{1,31},{1,32},{1,33},{1,34},{1,35},{2,1},{2,2},{2,3},{2,4},{3,1}].


get_reward_id_list(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35];


get_reward_id_list(2) ->
[1,2,3,4];


get_reward_id_list(3) ->
[1];

get_reward_id_list(_Type) ->
	[].

get_lv_reward() ->
[10,60,180].


get_lv_reward(10) ->
[2,4,6,8];


get_lv_reward(60) ->
[200];


get_lv_reward(180) ->
[8];

get_lv_reward(_Lv) ->
	[].

get_lv_reward(10,_Pos) when _Pos >= 1, _Pos =< 2 ->
		[{255,36255001,300}];
get_lv_reward(10,_Pos) when _Pos >= 3, _Pos =< 4 ->
		[{255,36255001,400}];
get_lv_reward(10,_Pos) when _Pos >= 5, _Pos =< 6 ->
		[{255,36255001,500}];
get_lv_reward(10,_Pos) when _Pos >= 7, _Pos =< 8 ->
		[{255,36255001,600}];
get_lv_reward(60,_Pos) when _Pos >= 1, _Pos =< 200 ->
		[{255,36255002,100}];
get_lv_reward(180,_Pos) when _Pos >= 1, _Pos =< 8 ->
		[{255,36255001,500}];
get_lv_reward(_Lv,_Pos) ->
	[].

