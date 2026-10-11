%%%---------------------------------------
%%% module      : data_chrono_rift
%%% description : 时空裂缝配置
%%%
%%%---------------------------------------
-module(data_chrono_rift).
-compile(export_all).
-include("chrono_rift.hrl").



get_castle(1) ->
	#cfg_chrono_rift_castle{id = 1,lv = 1,connect_castle = [25,26,11],occupa_add = 1000};

get_castle(2) ->
	#cfg_chrono_rift_castle{id = 2,lv = 1,connect_castle = [11,13,12],occupa_add = 1000};

get_castle(3) ->
	#cfg_chrono_rift_castle{id = 3,lv = 1,connect_castle = [12,14,15],occupa_add = 1000};

get_castle(4) ->
	#cfg_chrono_rift_castle{id = 4,lv = 1,connect_castle = [15,16,17],occupa_add = 1000};

get_castle(5) ->
	#cfg_chrono_rift_castle{id = 5,lv = 1,connect_castle = [17,18,19],occupa_add = 1000};

get_castle(6) ->
	#cfg_chrono_rift_castle{id = 6,lv = 1,connect_castle = [19,20,21],occupa_add = 1000};

get_castle(7) ->
	#cfg_chrono_rift_castle{id = 7,lv = 1,connect_castle = [21,22,23],occupa_add = 1000};

get_castle(8) ->
	#cfg_chrono_rift_castle{id = 8,lv = 1,connect_castle = [23,24,25],occupa_add = 1000};

get_castle(11) ->
	#cfg_chrono_rift_castle{id = 11,lv = 2,connect_castle = [1,2],occupa_add = 1000};

get_castle(12) ->
	#cfg_chrono_rift_castle{id = 12,lv = 2,connect_castle = [2,3],occupa_add = 1000};

get_castle(13) ->
	#cfg_chrono_rift_castle{id = 13,lv = 2,connect_castle = [2,101],occupa_add = 1000};

get_castle(14) ->
	#cfg_chrono_rift_castle{id = 14,lv = 2,connect_castle = [3,101],occupa_add = 1000};

get_castle(15) ->
	#cfg_chrono_rift_castle{id = 15,lv = 2,connect_castle = [3,4],occupa_add = 1000};

get_castle(16) ->
	#cfg_chrono_rift_castle{id = 16,lv = 2,connect_castle = [4,102],occupa_add = 1000};

get_castle(17) ->
	#cfg_chrono_rift_castle{id = 17,lv = 2,connect_castle = [4,5],occupa_add = 1000};

get_castle(18) ->
	#cfg_chrono_rift_castle{id = 18,lv = 2,connect_castle = [102,5],occupa_add = 1000};

get_castle(19) ->
	#cfg_chrono_rift_castle{id = 19,lv = 2,connect_castle = [5,6],occupa_add = 1000};

get_castle(20) ->
	#cfg_chrono_rift_castle{id = 20,lv = 2,connect_castle = [104,6],occupa_add = 1000};

get_castle(21) ->
	#cfg_chrono_rift_castle{id = 21,lv = 2,connect_castle = [7,6],occupa_add = 1000};

get_castle(22) ->
	#cfg_chrono_rift_castle{id = 22,lv = 2,connect_castle = [104,7],occupa_add = 1000};

get_castle(23) ->
	#cfg_chrono_rift_castle{id = 23,lv = 2,connect_castle = [7,8],occupa_add = 1000};

get_castle(24) ->
	#cfg_chrono_rift_castle{id = 24,lv = 2,connect_castle = [103,8],occupa_add = 1000};

get_castle(25) ->
	#cfg_chrono_rift_castle{id = 25,lv = 2,connect_castle = [1,8],occupa_add = 1000};

get_castle(26) ->
	#cfg_chrono_rift_castle{id = 26,lv = 2,connect_castle = [1,103],occupa_add = 1000};

get_castle(101) ->
	#cfg_chrono_rift_castle{id = 101,lv = 3,connect_castle = [13,14,1001,1002],occupa_add = 1000};

get_castle(102) ->
	#cfg_chrono_rift_castle{id = 102,lv = 3,connect_castle = [1002,1003,16,18],occupa_add = 1000};

get_castle(103) ->
	#cfg_chrono_rift_castle{id = 103,lv = 3,connect_castle = [1001,1004,24,26],occupa_add = 1000};

get_castle(104) ->
	#cfg_chrono_rift_castle{id = 104,lv = 3,connect_castle = [20,22,1003,1004],occupa_add = 1000};

get_castle(1001) ->
	#cfg_chrono_rift_castle{id = 1001,lv = 4,connect_castle = [103,101,10001],occupa_add = 1000};

get_castle(1002) ->
	#cfg_chrono_rift_castle{id = 1002,lv = 4,connect_castle = [101,102,10001],occupa_add = 1000};

get_castle(1003) ->
	#cfg_chrono_rift_castle{id = 1003,lv = 4,connect_castle = [102,104,10001],occupa_add = 1000};

get_castle(1004) ->
	#cfg_chrono_rift_castle{id = 1004,lv = 4,connect_castle = [103,104,10001],occupa_add = 1000};

get_castle(10001) ->
	#cfg_chrono_rift_castle{id = 10001,lv = 5,connect_castle = [1001,1002,1003,1004],occupa_add = 1000};

get_castle(_Id) ->
	[].

get_castle_ids() ->
[1,2,3,4,5,6,7,8,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,101,102,103,104,1001,1002,1003,1004,10001].


get_castle_reward(1) ->
[{0,32010451,1},{0,801701,2}];


get_castle_reward(2) ->
[{0,32010451,1},{0,801701,2}];


get_castle_reward(3) ->
[{0,32010452,1},{0,801702,2}];


get_castle_reward(4) ->
[{0,32010453,1},{0,801702,3}];


get_castle_reward(5) ->
[{0,32010454,1},{0,801703,3}];

get_castle_reward(_Lv) ->
	[].

get_rank_ratio(_Rank) when _Rank >= 1, _Rank =< 5 ->
		120;
get_rank_ratio(_Rank) when _Rank >= 6, _Rank =< 10 ->
		100;
get_rank_ratio(_Rank) when _Rank >= 11, _Rank =< 20 ->
		80;
get_rank_ratio(_Rank) when _Rank >= 21, _Rank =< 30 ->
		60;
get_rank_ratio(_Rank) when _Rank >= 31, _Rank =< 40 ->
		45;
get_rank_ratio(_Rank) when _Rank >= 41, _Rank =< 50 ->
		30;
get_rank_ratio(_Rank) when _Rank >= 51, _Rank =< 100 ->
		20;
get_rank_ratio(_Rank) when _Rank >= 101, _Rank =< 9999 ->
		0;
get_rank_ratio(_Rank) ->
	0.


get_stage_by_lv(1) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];


get_stage_by_lv(2) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];


get_stage_by_lv(3) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];


get_stage_by_lv(4) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];


get_stage_by_lv(5) ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];

get_stage_by_lv(_Lv) ->
	[].

get_next_scramble_v(1,1) ->
1000;

get_next_scramble_v(1,2) ->
4000;

get_next_scramble_v(1,3) ->
8000;

get_next_scramble_v(1,4) ->
15000;

get_next_scramble_v(1,5) ->
30000;

get_next_scramble_v(2,1) ->
1300;

get_next_scramble_v(2,2) ->
5200;

get_next_scramble_v(2,3) ->
10400;

get_next_scramble_v(2,4) ->
19500;

get_next_scramble_v(2,5) ->
39000;

get_next_scramble_v(3,1) ->
1690;

get_next_scramble_v(3,2) ->
6760;

get_next_scramble_v(3,3) ->
13520;

get_next_scramble_v(3,4) ->
25350;

get_next_scramble_v(3,5) ->
50700;

get_next_scramble_v(4,1) ->
2197;

get_next_scramble_v(4,2) ->
8788;

get_next_scramble_v(4,3) ->
17576;

get_next_scramble_v(4,4) ->
32955;

get_next_scramble_v(4,5) ->
65910;

get_next_scramble_v(5,1) ->
2856;

get_next_scramble_v(5,2) ->
11424;

get_next_scramble_v(5,3) ->
22849;

get_next_scramble_v(5,4) ->
42842;

get_next_scramble_v(5,5) ->
85683;

get_next_scramble_v(6,1) ->
3713;

get_next_scramble_v(6,2) ->
14851;

get_next_scramble_v(6,3) ->
29704;

get_next_scramble_v(6,4) ->
55695;

get_next_scramble_v(6,5) ->
111388;

get_next_scramble_v(7,1) ->
4827;

get_next_scramble_v(7,2) ->
19306;

get_next_scramble_v(7,3) ->
38615;

get_next_scramble_v(7,4) ->
72404;

get_next_scramble_v(7,5) ->
144804;

get_next_scramble_v(8,1) ->
6275;

get_next_scramble_v(8,2) ->
25098;

get_next_scramble_v(8,3) ->
50200;

get_next_scramble_v(8,4) ->
94125;

get_next_scramble_v(8,5) ->
188245;

get_next_scramble_v(9,1) ->
8158;

get_next_scramble_v(9,2) ->
32627;

get_next_scramble_v(9,3) ->
65260;

get_next_scramble_v(9,4) ->
122363;

get_next_scramble_v(9,5) ->
244719;

get_next_scramble_v(10,1) ->
10605;

get_next_scramble_v(10,2) ->
42415;

get_next_scramble_v(10,3) ->
84838;

get_next_scramble_v(10,4) ->
159072;

get_next_scramble_v(10,5) ->
318135;

get_next_scramble_v(11,1) ->
13787;

get_next_scramble_v(11,2) ->
55140;

get_next_scramble_v(11,3) ->
110289;

get_next_scramble_v(11,4) ->
206794;

get_next_scramble_v(11,5) ->
413576;

get_next_scramble_v(12,1) ->
17923;

get_next_scramble_v(12,2) ->
71682;

get_next_scramble_v(12,3) ->
143376;

get_next_scramble_v(12,4) ->
268832;

get_next_scramble_v(12,5) ->
537649;

get_next_scramble_v(13,1) ->
23300;

get_next_scramble_v(13,2) ->
93187;

get_next_scramble_v(13,3) ->
186389;

get_next_scramble_v(13,4) ->
349482;

get_next_scramble_v(13,5) ->
698944;

get_next_scramble_v(14,1) ->
30290;

get_next_scramble_v(14,2) ->
121143;

get_next_scramble_v(14,3) ->
242306;

get_next_scramble_v(14,4) ->
454327;

get_next_scramble_v(14,5) ->
908627;

get_next_scramble_v(15,1) ->
39377;

get_next_scramble_v(15,2) ->
157486;

get_next_scramble_v(15,3) ->
314998;

get_next_scramble_v(15,4) ->
590625;

get_next_scramble_v(15,5) ->
1181215;

get_next_scramble_v(16,1) ->
51190;

get_next_scramble_v(16,2) ->
204732;

get_next_scramble_v(16,3) ->
409497;

get_next_scramble_v(16,4) ->
767813;

get_next_scramble_v(16,5) ->
1535580;

get_next_scramble_v(17,1) ->
66547;

get_next_scramble_v(17,2) ->
266152;

get_next_scramble_v(17,3) ->
532346;

get_next_scramble_v(17,4) ->
998157;

get_next_scramble_v(17,5) ->
1996254;

get_next_scramble_v(18,1) ->
86511;

get_next_scramble_v(18,2) ->
345998;

get_next_scramble_v(18,3) ->
692050;

get_next_scramble_v(18,4) ->
1297604;

get_next_scramble_v(18,5) ->
2595130;

get_next_scramble_v(19,1) ->
112464;

get_next_scramble_v(19,2) ->
449797;

get_next_scramble_v(19,3) ->
899665;

get_next_scramble_v(19,4) ->
1686885;

get_next_scramble_v(19,5) ->
3373669;

get_next_scramble_v(20,1) ->
146203;

get_next_scramble_v(20,2) ->
584736;

get_next_scramble_v(20,3) ->
1169565;

get_next_scramble_v(20,4) ->
2192951;

get_next_scramble_v(20,5) ->
4385770;

get_next_scramble_v(21,1) ->
999999999;

get_next_scramble_v(21,2) ->
999999999;

get_next_scramble_v(21,3) ->
999999999;

get_next_scramble_v(21,4) ->
999999999;

get_next_scramble_v(21,5) ->
999999999;

get_next_scramble_v(_Stage,_Lv) ->
	0.

get_goal_id_by_lv_and_type(1,1) ->
1001;

get_goal_id_by_lv_and_type(1,2) ->
1002;

get_goal_id_by_lv_and_type(1,3) ->
1003;

get_goal_id_by_lv_and_type(1,4) ->
1004;

get_goal_id_by_lv_and_type(1,5) ->
1005;

get_goal_id_by_lv_and_type(2,1) ->
2001;

get_goal_id_by_lv_and_type(2,2) ->
2002;

get_goal_id_by_lv_and_type(2,3) ->
2003;

get_goal_id_by_lv_and_type(2,4) ->
2004;

get_goal_id_by_lv_and_type(2,5) ->
2005;

get_goal_id_by_lv_and_type(3,1) ->
3001;

get_goal_id_by_lv_and_type(3,2) ->
3002;

get_goal_id_by_lv_and_type(3,3) ->
3003;

get_goal_id_by_lv_and_type(3,4) ->
3004;

get_goal_id_by_lv_and_type(3,5) ->
3005;

get_goal_id_by_lv_and_type(_Lv,_Type) ->
	0.


get_goal_value(1001) ->
1;


get_goal_value(1002) ->
1;


get_goal_value(1003) ->
8000;


get_goal_value(1004) ->
1;


get_goal_value(1005) ->
1;


get_goal_value(2001) ->
2;


get_goal_value(2002) ->
2;


get_goal_value(2003) ->
12000;


get_goal_value(2004) ->
1;


get_goal_value(2005) ->
2;


get_goal_value(3001) ->
3;


get_goal_value(3002) ->
4;


get_goal_value(3003) ->
20000;


get_goal_value(3004) ->
1;


get_goal_value(3005) ->
3;

get_goal_value(_Id) ->
	0.


get_goal_msg(1001) ->
{1,1};


get_goal_msg(1002) ->
{2,1};


get_goal_msg(1003) ->
{3,8000};


get_goal_msg(1004) ->
{4,1};


get_goal_msg(1005) ->
{5,1};


get_goal_msg(2001) ->
{1,2};


get_goal_msg(2002) ->
{2,2};


get_goal_msg(2003) ->
{3,12000};


get_goal_msg(2004) ->
{4,1};


get_goal_msg(2005) ->
{5,2};


get_goal_msg(3001) ->
{1,3};


get_goal_msg(3002) ->
{2,4};


get_goal_msg(3003) ->
{3,20000};


get_goal_msg(3004) ->
{4,1};


get_goal_msg(3005) ->
{5,3};

get_goal_msg(_Id) ->
	[].


get_goal_reward(1001) ->
[{0,801707,1},{0,35,80},{0,801702,2}];


get_goal_reward(1002) ->
[{0,801707,1},{0,35,50},{0,801702,1}];


get_goal_reward(1003) ->
[{0,801707,1},{0,35,50},{0,801702,1}];


get_goal_reward(1004) ->
[{0,801707,1},{0,35,80},{0,801702,2}];


get_goal_reward(1005) ->
[{0,801707,1},{0,35,100},{0,801704,1},{0,801703,1}];


get_goal_reward(2001) ->
[{0,801707,1},{0,35,80},{0,801702,2}];


get_goal_reward(2002) ->
[{0,801707,1},{0,35,50},{0,801702,1}];


get_goal_reward(2003) ->
[{0,801707,1},{0,35,50},{0,801702,1}];


get_goal_reward(2004) ->
[{0,801707,1},{0,35,80},{0,801702,2}];


get_goal_reward(2005) ->
[{0,801707,1},{0,35,100},{0,801704,1},{0,801703,1}];


get_goal_reward(3001) ->
[{0,801707,1},{0,35,80},{0,801702,2}];


get_goal_reward(3002) ->
[{0,801707,1},{0,35,50},{0,801702,1}];


get_goal_reward(3003) ->
[{0,801707,1},{0,35,50},{0,801702,1}];


get_goal_reward(3004) ->
[{0,801707,1},{0,35,80},{0,801702,2}];


get_goal_reward(3005) ->
[{0,801707,1},{0,35,100},{0,801704,1},{0,801703,1}];

get_goal_reward(_Id) ->
	[].

get_act(150,1) ->
	#chrono_act_cfg{mod = 150,sub_mod = 1,type = 3,count = 300,value = 200,max_value = 200};

get_act(150,2) ->
	#chrono_act_cfg{mod = 150,sub_mod = 2,type = 3,count = 980,value = 300,max_value = 300};

get_act(150,3) ->
	#chrono_act_cfg{mod = 150,sub_mod = 3,type = 3,count = 1980,value = 400,max_value = 400};

get_act(158,1) ->
	#chrono_act_cfg{mod = 158,sub_mod = 1,type = 3,count = 100,value = 100,max_value = 5000};

get_act(233,1) ->
	#chrono_act_cfg{mod = 233,sub_mod = 1,type = 3,count = 1,value = 150,max_value = 1500};

get_act(233,2) ->
	#chrono_act_cfg{mod = 233,sub_mod = 2,type = 3,count = 1,value = 150,max_value = 1500};

get_act(416,0) ->
	#chrono_act_cfg{mod = 416,sub_mod = 0,type = 3,count = 200,value = 100,max_value = 9999999};

get_act(460,2) ->
	#chrono_act_cfg{mod = 460,sub_mod = 2,type = 1,count = 1,value = 200,max_value = 200};

get_act(460,4) ->
	#chrono_act_cfg{mod = 460,sub_mod = 4,type = 1,count = 2,value = 300,max_value = 300};

get_act(460,7) ->
	#chrono_act_cfg{mod = 460,sub_mod = 7,type = 1,count = 6,value = 200,max_value = 200};

get_act(460,12) ->
	#chrono_act_cfg{mod = 460,sub_mod = 12,type = 1,count = 3,value = 200,max_value = 200};

get_act(460,20) ->
	#chrono_act_cfg{mod = 460,sub_mod = 20,type = 1,count = 3,value = 200,max_value = 200};

get_act(470,10) ->
	#chrono_act_cfg{mod = 470,sub_mod = 10,type = 1,count = 3,value = 200,max_value = 200};

get_act(471,1) ->
	#chrono_act_cfg{mod = 471,sub_mod = 1,type = 1,count = 2,value = 200,max_value = 200};

get_act(651,0) ->
	#chrono_act_cfg{mod = 651,sub_mod = 0,type = 1,count = 1,value = 200,max_value = 200};

get_act(_Mod,_Submod) ->
	[].

get_all_act() ->
[{150,1},{150,2},{150,3},{158,1},{233,1},{233,2},{416,0},{460,2},{460,4},{460,7},{460,12},{460,20},{470,10},{471,1},{651,0}].

get_stage_list() ->
[{1,500},{2,1000},{3,1500},{4,2000},{5,3000},{6,5000},{7,7000},{8,10000}].


get_stage_reward(1) ->
[{0,801707,1}];


get_stage_reward(2) ->
[{0,801707,1}];


get_stage_reward(3) ->
[{0,801707,1}];


get_stage_reward(4) ->
[{0,801707,1}];


get_stage_reward(5) ->
[{0,801707,2}];


get_stage_reward(6) ->
[{0,801707,2}];


get_stage_reward(7) ->
[{0,801707,2}];


get_stage_reward(8) ->
[{0,801707,2}];

get_stage_reward(_Id) ->
	[].

get_role_rank_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
		[{0,34010288,35},{0,801706,2},{0,801703,3},{0,801704,10}];
get_role_rank_reward(_Rank) when _Rank >= 2, _Rank =< 2 ->
		[{0,34010288,32},{0,801706,1},{0,801703,2},{0,801704,9}];
get_role_rank_reward(_Rank) when _Rank >= 3, _Rank =< 3 ->
		[{0,34010288,30},{0,801706,1},{0,801702,5},{0,801704,9}];
get_role_rank_reward(_Rank) when _Rank >= 4, _Rank =< 6 ->
		[{0,34010288,25},{0,801702,4},{0,801704,8}];
get_role_rank_reward(_Rank) when _Rank >= 7, _Rank =< 10 ->
		[{0,34010288,20},{0,801702,3},{0,801704,6}];
get_role_rank_reward(_Rank) when _Rank >= 11, _Rank =< 20 ->
		[{0,34010288,15},{0,801701,5},{0,801704,5}];
get_role_rank_reward(_Rank) when _Rank >= 21, _Rank =< 50 ->
		[{0,34010288,10},{0,801701,3},{0,801704,3}];
get_role_rank_reward(_Rank) ->
	[].


get_kv(goal_lv_list) ->
[{1, 2, 3}, {3, 5, 2}, {6, 8, 1}];


get_kv(lv_limit) ->
500;


get_kv(need_world_lv) ->
500;


get_kv(open_day) ->
50;


get_kv(rank_length) ->
50;


get_kv(rank_value_limit) ->
1;

get_kv(_Key) ->
	[].

