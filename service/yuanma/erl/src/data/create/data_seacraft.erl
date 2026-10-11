%%%---------------------------------------
%%% module      : data_seacraft
%%% description : 怒海争霸配置
%%%
%%%---------------------------------------
-module(data_seacraft).
-compile(export_all).
-include("seacraft.hrl").



get_rank_reward(_Rank,1) when _Rank >= 1, _Rank =< 1 ->
	#base_seacraft_rank_reward{act_type=1,min=1,max=1,reward=[{0,19020002,5},{0,32010194,2},{0,19010003,1}]};
get_rank_reward(_Rank,1) when _Rank >= 2, _Rank =< 5 ->
	#base_seacraft_rank_reward{act_type=1,min=2,max=5,reward=[{0,19020002,3},{0,32010194,1},{0,19010002,2}]};
get_rank_reward(_Rank,1) when _Rank >= 6, _Rank =< 9 ->
	#base_seacraft_rank_reward{act_type=1,min=6,max=9,reward=[{0,19020002,1},{0,19010002,2}]};
get_rank_reward(_Rank,1) when _Rank >= 10, _Rank =< 999 ->
	#base_seacraft_rank_reward{act_type=1,min=10,max=999,reward=[{0,19020001,8},{0,19010002,1}]};
get_rank_reward(_Rank,2) when _Rank >= 1, _Rank =< 1 ->
	#base_seacraft_rank_reward{act_type=2,min=1,max=1,reward=[{0,38040091,20},{0,32010524,5},{0,38040086,3}]};
get_rank_reward(_Rank,2) when _Rank >= 2, _Rank =< 5 ->
	#base_seacraft_rank_reward{act_type=2,min=2,max=5,reward=[{0,38040091,12},{0,32010524,3},{0,38040086,2}]};
get_rank_reward(_Rank,2) when _Rank >= 6, _Rank =< 9 ->
	#base_seacraft_rank_reward{act_type=2,min=6,max=9,reward=[{0,38040091,8},{0,32010524,2},{0,38040086,1}]};
get_rank_reward(_Rank,2) when _Rank >= 10, _Rank =< 999 ->
	#base_seacraft_rank_reward{act_type=2,min=10,max=999,reward=[{0,38040091,4},{0,32010524,2}]};
get_rank_reward(_Rank,_Act_type) ->
	[].

get_act_reward(1) ->
	#base_seacraft_reward{act_type = 1,success_reward = [{0,38040091,50},{0,19020001,3}],fail_reward = [{0,38040091,30},{0,19020001,2}],auction_reward = []};

get_act_reward(2) ->
	#base_seacraft_reward{act_type = 2,success_reward = [{0,32010458,5},{2,0,50}],fail_reward = [{0,32010458,3},{2,0,30}],auction_reward = []};

get_act_reward(_Acttype) ->
	[].

get_daily_reward(1) ->
	#base_seacraft_daily_reward{level = 1,name = "海域之王",limit = 1,normal = [{0,39510000,5},{0,37020002,1},{0,19020002,2}],special = [],dsgt_id = 801001};

get_daily_reward(2) ->
	#base_seacraft_daily_reward{level = 2,name = "海域统帅",limit = 1,normal = [{0,39510000,3},{0,37020002,1},{0,19020002,1}],special = [],dsgt_id = 801002};

get_daily_reward(3) ->
	#base_seacraft_daily_reward{level = 3,name = "海域元帅",limit = 1,normal = [{0,39510000,3},{0,37020002,1},{0,19020002,1}],special = [],dsgt_id = 801003};

get_daily_reward(4) ->
	#base_seacraft_daily_reward{level = 4,name = "海域指挥",limit = 1,normal = [{0,39510000,3},{0,37020002,1},{0,19020002,1}],special = [],dsgt_id = 801004};

get_daily_reward(5) ->
	#base_seacraft_daily_reward{level = 5,name = "海域禁军",limit = 23,normal = [{0,39510000,2},{0,37020001,1},{0,19020001,5}],special = [],dsgt_id = 801005};

get_daily_reward(6) ->
	#base_seacraft_daily_reward{level = 6,name = "成员",limit = 0,normal = [{0,39510000,1},{0,37020001,1},{0,19020001,2}],special = [],dsgt_id = 0};

get_daily_reward(_Level) ->
	[].

get_all_dsgt_id() ->
[801001,801002,801003,801004,801005,0].

get_win_more_reward(_Rank) ->
	[].

get_mon_info(4900101,49001) ->
	#base_seacraft_construction{id = 4900101,scene = 49001,type = 1,name = <<"哨塔（外）"/utf8>>,x = 2404,y = 4848,list = [4900104],is_be_att = 0,conlect_mon = 4900111,areamark_id = 0,skill = 0};

get_mon_info(4900101,49002) ->
	#base_seacraft_construction{id = 4900101,scene = 49002,type = 1,name = <<"哨塔（外）"/utf8>>,x = 2404,y = 4848,list = [4900104],is_be_att = 0,conlect_mon = 4900111,areamark_id = 0,skill = 0};

get_mon_info(4900101,49003) ->
	#base_seacraft_construction{id = 4900101,scene = 49003,type = 1,name = <<"哨塔（外）"/utf8>>,x = 2404,y = 4848,list = [4900104],is_be_att = 0,conlect_mon = 4900111,areamark_id = 0,skill = 0};

get_mon_info(4900101,49004) ->
	#base_seacraft_construction{id = 4900101,scene = 49004,type = 1,name = <<"哨塔（外）"/utf8>>,x = 2404,y = 4848,list = [4900104],is_be_att = 0,conlect_mon = 4900111,areamark_id = 0,skill = 0};

get_mon_info(4900102,49001) ->
	#base_seacraft_construction{id = 4900102,scene = 49001,type = 1,name = <<"哨塔（中）"/utf8>>,x = 3868,y = 3500,list = [4900105],is_be_att = 0,conlect_mon = 4900112,areamark_id = 0,skill = 4900103};

get_mon_info(4900102,49002) ->
	#base_seacraft_construction{id = 4900102,scene = 49002,type = 1,name = <<"哨塔（中）"/utf8>>,x = 3868,y = 3500,list = [4900105],is_be_att = 0,conlect_mon = 4900112,areamark_id = 0,skill = 4900103};

get_mon_info(4900102,49003) ->
	#base_seacraft_construction{id = 4900102,scene = 49003,type = 1,name = <<"哨塔（中）"/utf8>>,x = 3868,y = 3500,list = [4900105],is_be_att = 0,conlect_mon = 4900112,areamark_id = 0,skill = 4900103};

get_mon_info(4900102,49004) ->
	#base_seacraft_construction{id = 4900102,scene = 49004,type = 1,name = <<"哨塔（中）"/utf8>>,x = 3868,y = 3500,list = [4900105],is_be_att = 0,conlect_mon = 4900112,areamark_id = 0,skill = 4900103};

get_mon_info(4900103,49001) ->
	#base_seacraft_construction{id = 4900103,scene = 49001,type = 1,name = <<"哨塔（内）"/utf8>>,x = 5232,y = 2156,list = [4900106],is_be_att = 0,conlect_mon = 4900113,areamark_id = 0,skill = 4900103};

get_mon_info(4900103,49002) ->
	#base_seacraft_construction{id = 4900103,scene = 49002,type = 1,name = <<"哨塔（内）"/utf8>>,x = 5232,y = 2156,list = [4900106],is_be_att = 0,conlect_mon = 4900113,areamark_id = 0,skill = 4900103};

get_mon_info(4900103,49003) ->
	#base_seacraft_construction{id = 4900103,scene = 49003,type = 1,name = <<"哨塔（内）"/utf8>>,x = 5232,y = 2156,list = [4900106],is_be_att = 0,conlect_mon = 4900113,areamark_id = 0,skill = 4900103};

get_mon_info(4900103,49004) ->
	#base_seacraft_construction{id = 4900103,scene = 49004,type = 1,name = <<"哨塔（内）"/utf8>>,x = 5232,y = 2156,list = [4900106],is_be_att = 0,conlect_mon = 4900113,areamark_id = 0,skill = 4900103};

get_mon_info(4900104,49001) ->
	#base_seacraft_construction{id = 4900104,scene = 49001,type = 2,name = <<"要塞（外）"/utf8>>,x = 3318,y = 4176,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 1,skill = 4900104};

get_mon_info(4900104,49002) ->
	#base_seacraft_construction{id = 4900104,scene = 49002,type = 2,name = <<"要塞（外）"/utf8>>,x = 3318,y = 4176,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 1,skill = 4900104};

get_mon_info(4900104,49003) ->
	#base_seacraft_construction{id = 4900104,scene = 49003,type = 2,name = <<"要塞（外）"/utf8>>,x = 3318,y = 4176,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 1,skill = 4900104};

get_mon_info(4900104,49004) ->
	#base_seacraft_construction{id = 4900104,scene = 49004,type = 2,name = <<"要塞（外）"/utf8>>,x = 3318,y = 4176,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 1,skill = 4900104};

get_mon_info(4900105,49001) ->
	#base_seacraft_construction{id = 4900105,scene = 49001,type = 2,name = <<"要塞（中）"/utf8>>,x = 4637,y = 2869,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 2,skill = 4900104};

get_mon_info(4900105,49002) ->
	#base_seacraft_construction{id = 4900105,scene = 49002,type = 2,name = <<"要塞（中）"/utf8>>,x = 4637,y = 2869,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 2,skill = 4900104};

get_mon_info(4900105,49003) ->
	#base_seacraft_construction{id = 4900105,scene = 49003,type = 2,name = <<"要塞（中）"/utf8>>,x = 4637,y = 2869,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 2,skill = 4900104};

get_mon_info(4900105,49004) ->
	#base_seacraft_construction{id = 4900105,scene = 49004,type = 2,name = <<"要塞（中）"/utf8>>,x = 4637,y = 2869,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 2,skill = 4900104};

get_mon_info(4900106,49001) ->
	#base_seacraft_construction{id = 4900106,scene = 49001,type = 2,name = <<"要塞（内）"/utf8>>,x = 5827,y = 1667,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 3,skill = 4900104};

get_mon_info(4900106,49002) ->
	#base_seacraft_construction{id = 4900106,scene = 49002,type = 2,name = <<"要塞（内）"/utf8>>,x = 5827,y = 1667,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 3,skill = 4900104};

get_mon_info(4900106,49003) ->
	#base_seacraft_construction{id = 4900106,scene = 49003,type = 2,name = <<"要塞（内）"/utf8>>,x = 5827,y = 1667,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 3,skill = 4900104};

get_mon_info(4900106,49004) ->
	#base_seacraft_construction{id = 4900106,scene = 49004,type = 2,name = <<"要塞（内）"/utf8>>,x = 5827,y = 1667,list = [],is_be_att = 1,conlect_mon = 0,areamark_id = 3,skill = 4900104};

get_mon_info(4900107,49001) ->
	#base_seacraft_construction{id = 4900107,scene = 49001,type = 3,name = <<"海神城堡"/utf8>>,x = 6171,y = 939,list = [],is_be_att = 0,conlect_mon = 0,areamark_id = 0,skill = 0};

get_mon_info(4900107,49002) ->
	#base_seacraft_construction{id = 4900107,scene = 49002,type = 3,name = <<"海神城堡"/utf8>>,x = 6171,y = 939,list = [],is_be_att = 0,conlect_mon = 0,areamark_id = 0,skill = 0};

get_mon_info(4900107,49003) ->
	#base_seacraft_construction{id = 4900107,scene = 49003,type = 3,name = <<"海神城堡"/utf8>>,x = 6171,y = 939,list = [],is_be_att = 0,conlect_mon = 0,areamark_id = 0,skill = 0};

get_mon_info(4900107,49004) ->
	#base_seacraft_construction{id = 4900107,scene = 49004,type = 3,name = <<"海神城堡"/utf8>>,x = 6171,y = 939,list = [],is_be_att = 0,conlect_mon = 0,areamark_id = 0,skill = 0};

get_mon_info(_Id,_Scene) ->
	[].


get_all_mon(49001) ->
[4900101,4900102,4900103,4900104,4900105,4900106,4900107];


get_all_mon(49002) ->
[4900101,4900102,4900103,4900104,4900105,4900106,4900107];


get_all_mon(49003) ->
[4900101,4900102,4900103,4900104,4900105,4900106,4900107];


get_all_mon(49004) ->
[4900101,4900102,4900103,4900104,4900105,4900106,4900107];

get_all_mon(_Scene) ->
	[].


get_all_areamark_id(49001) ->
[0,1,2,3];


get_all_areamark_id(49002) ->
[0,1,2,3];


get_all_areamark_id(49003) ->
[0,1,2,3];


get_all_areamark_id(49004) ->
[0,1,2,3];

get_all_areamark_id(_Scene) ->
	[].

get_scene_born_info(49001,1) ->
	#base_seacraft_scene{scene = 49001,point = 1,x = 5628,y = 276};

get_scene_born_info(49001,2) ->
	#base_seacraft_scene{scene = 49001,point = 2,x = 539,y = 4795};

get_scene_born_info(49001,3) ->
	#base_seacraft_scene{scene = 49001,point = 3,x = 1155,y = 6041};

get_scene_born_info(49001,4) ->
	#base_seacraft_scene{scene = 49001,point = 4,x = 3262,y = 6440};

get_scene_born_info(49002,1) ->
	#base_seacraft_scene{scene = 49002,point = 1,x = 5628,y = 276};

get_scene_born_info(49002,2) ->
	#base_seacraft_scene{scene = 49002,point = 2,x = 539,y = 4795};

get_scene_born_info(49002,3) ->
	#base_seacraft_scene{scene = 49002,point = 3,x = 1155,y = 6041};

get_scene_born_info(49002,4) ->
	#base_seacraft_scene{scene = 49002,point = 4,x = 3262,y = 6440};

get_scene_born_info(49003,1) ->
	#base_seacraft_scene{scene = 49003,point = 1,x = 5628,y = 276};

get_scene_born_info(49003,2) ->
	#base_seacraft_scene{scene = 49003,point = 2,x = 539,y = 4795};

get_scene_born_info(49003,3) ->
	#base_seacraft_scene{scene = 49003,point = 3,x = 1155,y = 6041};

get_scene_born_info(49003,4) ->
	#base_seacraft_scene{scene = 49003,point = 4,x = 3262,y = 6440};

get_scene_born_info(49004,1) ->
	#base_seacraft_scene{scene = 49004,point = 1,x = 5628,y = 276};

get_scene_born_info(49004,2) ->
	#base_seacraft_scene{scene = 49004,point = 2,x = 539,y = 4795};

get_scene_born_info(49004,3) ->
	#base_seacraft_scene{scene = 49004,point = 3,x = 1155,y = 6041};

get_scene_born_info(49004,4) ->
	#base_seacraft_scene{scene = 49004,point = 4,x = 3262,y = 6440};

get_scene_born_info(_Scene,_Point) ->
	[].

get_all_camp() ->
[1,2,3,4].


get_camp_name(1) ->
<<"东海之域"/utf8>>;


get_camp_name(2) ->
<<"西海之域"/utf8>>;


get_camp_name(3) ->
<<"南海之域"/utf8>>;


get_camp_name(4) ->
<<"北海之域"/utf8>>;

get_camp_name(_Camp) ->
	[].


get_value(act_change) ->
[{1,2,2},{2,1,1}];


get_value(act_final_boss_skill) ->
[4900107,4900105];


get_value(act_scene) ->
[{1,[{1,49001},{2,49002},{3,49003},{4,49004}]},{2,49001}];


get_value(auction_start_time) ->
120;


get_value(can_be_revive_mon_list) ->
[{4900111,[4900101,4900104]},{4900112,[4900102,4900105]},{4900113,[4900103,4900106]}];


get_value(change_ship_time) ->
60;


get_value(help_kill_player_add_score) ->
5;


get_value(hurt_mon_add_score) ->
1;


get_value(is_open_battle) ->
0;


get_value(job_limit_num) ->
24;


get_value(kill_mon_add_score) ->
100;


get_value(kill_player_add_score) ->
30;


get_value(muted_can_chat_job) ->
[];


get_value(open_day) ->
30;


get_value(open_day_list) ->
[7];


get_value(open_lv) ->
400;


get_value(open_time) ->
[{{20,30},{20,50}}];


get_value(revive_boss_cd) ->
90;


get_value(revive_cost) ->
[{2,0,20}];


get_value(revive_mon_score) ->
100;


get_value(role_score_change_time) ->
5;


get_value(sea_master_dsgt_id) ->
801006;


get_value(sea_master_reward) ->
[];


get_value(sea_part_master) ->
1;


get_value(update_role_info_time) ->
60;

get_value(_Key) ->
	[].


get_ship_skill(1) ->
[{4900101,1},{4900111,1}];


get_ship_skill(2) ->
[{4900102,1},{4900112,1}];

get_ship_skill(_Id) ->
	[].


get_ship_name(1) ->
<<"战列舰"/utf8>>;


get_ship_name(2) ->
<<"攻城舰"/utf8>>;

get_ship_name(_Id) ->
	[].

get_ship_att(_Wlv) when _Wlv >= 450, _Wlv =< 469 ->
		[{2,78336000},{1,2350080}];
get_ship_att(_Wlv) when _Wlv >= 470, _Wlv =< 489 ->
		[{2,88128000},{1,2643840}];
get_ship_att(_Wlv) when _Wlv >= 490, _Wlv =< 509 ->
		[{2,97920000},{1,2937600}];
get_ship_att(_Wlv) when _Wlv >= 510, _Wlv =< 529 ->
		[{2,112608000},{1,3378240}];
get_ship_att(_Wlv) when _Wlv >= 530, _Wlv =< 549 ->
		[{2,132192000},{1,3965760}];
get_ship_att(_Wlv) when _Wlv >= 550, _Wlv =< 569 ->
		[{2,151776000},{1,4553280}];
get_ship_att(_Wlv) when _Wlv >= 570, _Wlv =< 589 ->
		[{2,171360000},{1,5140800}];
get_ship_att(_Wlv) when _Wlv >= 590, _Wlv =< 609 ->
		[{2,190944000},{1,5728320}];
get_ship_att(_Wlv) when _Wlv >= 610, _Wlv =< 629 ->
		[{2,210528000},{1,6315840}];
get_ship_att(_Wlv) when _Wlv >= 630, _Wlv =< 649 ->
		[{2,239904000},{1,7197120}];
get_ship_att(_Wlv) when _Wlv >= 650, _Wlv =< 669 ->
		[{2,279072000},{1,8372160}];
get_ship_att(_Wlv) when _Wlv >= 670, _Wlv =< 689 ->
		[{2,318240000},{1,9547200}];
get_ship_att(_Wlv) when _Wlv >= 690, _Wlv =< 709 ->
		[{2,357408000},{1,10722240}];
get_ship_att(_Wlv) when _Wlv >= 710, _Wlv =< 729 ->
		[{2,396576000},{1,11897280}];
get_ship_att(_Wlv) when _Wlv >= 730, _Wlv =< 749 ->
		[{2,465120000},{1,13953600}];
get_ship_att(_Wlv) when _Wlv >= 750, _Wlv =< 769 ->
		[{2,543456000},{1,16303680}];
get_ship_att(_Wlv) when _Wlv >= 770, _Wlv =< 789 ->
		[{2,621792000},{1,18653760}];
get_ship_att(_Wlv) when _Wlv >= 790, _Wlv =< 809 ->
		[{2,700128000},{1,21003840}];
get_ship_att(_Wlv) when _Wlv >= 810, _Wlv =< 829 ->
		[{2,739296000},{1,22178880}];
get_ship_att(_Wlv) when _Wlv >= 830, _Wlv =< 849 ->
		[{2,813225600},{1,24396768}];
get_ship_att(_Wlv) when _Wlv >= 850, _Wlv =< 869 ->
		[{2,894548200},{1,26836446}];
get_ship_att(_Wlv) when _Wlv >= 870, _Wlv =< 889 ->
		[{2,984003000},{1,29520090}];
get_ship_att(_Wlv) when _Wlv >= 890, _Wlv =< 909 ->
		[{2,1082403200},{1,32472096}];
get_ship_att(_Wlv) when _Wlv >= 910, _Wlv =< 929 ->
		[{2,1190643600},{1,35719308}];
get_ship_att(_Wlv) when _Wlv >= 930, _Wlv =< 949 ->
		[{2,1309707900},{1,39291237}];
get_ship_att(_Wlv) when _Wlv >= 950, _Wlv =< 969 ->
		[{2,1440678800},{1,43220364}];
get_ship_att(_Wlv) when _Wlv >= 970, _Wlv =< 989 ->
		[{2,1584746600},{1,47542398}];
get_ship_att(_Wlv) when _Wlv >= 990, _Wlv =< 999 ->
		[{2,1743221200},{1,52296636}];
get_ship_att(_Wlv) ->
	[].

get_sea_exploit(1) ->
	#base_sea_exploit{military_id = 1,military_name = <<"平民"/utf8>>,need_exploit = [0,999],attr = [],passive_skill = []};

get_sea_exploit(2) ->
	#base_sea_exploit{military_id = 2,military_name = <<"列兵"/utf8>>,need_exploit = [1000,1499],attr = [{1,300},{2,6000},{3,150},{4,150}],passive_skill = [{311,200}]};

get_sea_exploit(3) ->
	#base_sea_exploit{military_id = 3,military_name = <<"上等兵"/utf8>>,need_exploit = [1500,2999],attr = [{1,600},{2,12000},{3,300},{4,300}],passive_skill = [{311,240}]};

get_sea_exploit(4) ->
	#base_sea_exploit{military_id = 4,military_name = <<"下士"/utf8>>,need_exploit = [3000,5999],attr = [{1,900},{2,18000},{3,450},{4,450}],passive_skill = [{311,290}]};

get_sea_exploit(5) ->
	#base_sea_exploit{military_id = 5,military_name = <<"中士"/utf8>>,need_exploit = [6000,10499],attr = [{1,1200},{2,24000},{3,600},{4,600}],passive_skill = [{311,340}]};

get_sea_exploit(6) ->
	#base_sea_exploit{military_id = 6,military_name = <<"上士"/utf8>>,need_exploit = [10500,17999],attr = [{1,1500},{2,30000},{3,750},{4,750}],passive_skill = [{311,390}]};

get_sea_exploit(7) ->
	#base_sea_exploit{military_id = 7,military_name = <<"军士长"/utf8>>,need_exploit = [18000,25499],attr = [{1,1800},{2,36000},{3,900},{4,900}],passive_skill = [{311,440}]};

get_sea_exploit(8) ->
	#base_sea_exploit{military_id = 8,military_name = <<"准尉"/utf8>>,need_exploit = [25500,35999],attr = [{1,2100},{2,42000},{3,1050},{4,1050}],passive_skill = [{311,490}]};

get_sea_exploit(9) ->
	#base_sea_exploit{military_id = 9,military_name = <<"少尉"/utf8>>,need_exploit = [36000,46499],attr = [{1,2400},{2,48000},{3,1200},{4,1200}],passive_skill = [{311,540}]};

get_sea_exploit(10) ->
	#base_sea_exploit{military_id = 10,military_name = <<"中尉"/utf8>>,need_exploit = [46500,59999],attr = [{1,2700},{2,54000},{3,1350},{4,1350}],passive_skill = [{311,590}]};

get_sea_exploit(11) ->
	#base_sea_exploit{military_id = 11,military_name = <<"上尉"/utf8>>,need_exploit = [60000,74999],attr = [{1,3000},{2,60000},{3,1500},{4,1500}],passive_skill = [{311,640}]};

get_sea_exploit(12) ->
	#base_sea_exploit{military_id = 12,military_name = <<"准校"/utf8>>,need_exploit = [75000,97499],attr = [{1,3300},{2,66000},{3,1650},{4,1650}],passive_skill = [{311,690}]};

get_sea_exploit(13) ->
	#base_sea_exploit{military_id = 13,military_name = <<"少校"/utf8>>,need_exploit = [97500,119999],attr = [{1,3600},{2,72000},{3,1800},{4,1800}],passive_skill = [{311,740}]};

get_sea_exploit(14) ->
	#base_sea_exploit{military_id = 14,military_name = <<"中校"/utf8>>,need_exploit = [120000,149999],attr = [{1,3900},{2,78000},{3,1950},{4,1950}],passive_skill = [{311,790}]};

get_sea_exploit(15) ->
	#base_sea_exploit{military_id = 15,military_name = <<"大校"/utf8>>,need_exploit = [150000,179999],attr = [{1,4200},{2,84000},{3,2100},{4,2100}],passive_skill = [{311,840}]};

get_sea_exploit(16) ->
	#base_sea_exploit{military_id = 16,military_name = <<"少将"/utf8>>,need_exploit = [180000,224999],attr = [{1,4500},{2,90000},{3,2250},{4,2250}],passive_skill = [{311,890}]};

get_sea_exploit(17) ->
	#base_sea_exploit{military_id = 17,military_name = <<"中将"/utf8>>,need_exploit = [225000,269999],attr = [{1,4800},{2,96000},{3,2400},{4,2400}],passive_skill = [{311,940}]};

get_sea_exploit(18) ->
	#base_sea_exploit{military_id = 18,military_name = <<"上将"/utf8>>,need_exploit = [270001,999999],attr = [{1,5100},{2,102000},{3,2550},{4,2550}],passive_skill = [{311,990}]};

get_sea_exploit(_Militaryid) ->
	[].

list_sea_exploits() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18].

get_sea_privilege(1) ->
	#base_sea_privilege{privilege_id = 1,privilege_name = <<"禁言"/utf8>>,un_privilege_name = <<"解禁"/utf8>>,privilege_desc = <<"禁止本海域成员在海域频道发言"/utf8>>,un_privilege_desc = <<"解除本海域玩家禁言状态"/utf8>>,need_job = [1],duration = 3600,day_times = 2};

get_sea_privilege(2) ->
	#base_sea_privilege{privilege_id = 2,privilege_name = <<"封锁边境"/utf8>>,un_privilege_name = <<"解除封锁"/utf8>>,privilege_desc = <<"封锁本海域领地，阻止其他海域成员进入"/utf8>>,un_privilege_desc = <<"解除本海域领地封锁状态"/utf8>>,need_job = [1,2],duration = 3600,day_times = 2};

get_sea_privilege(_Privilegeid) ->
	[].

lists_sea_privilege() ->
[1,2].

get_auction_produce(_Type,_Wlv) ->
	[].

