%%%---------------------------------------
%%% module      : data_escort
%%% description : 矿石护送配置
%%%
%%%---------------------------------------
-module(data_escort).
-compile(export_all).
-include("escort.hrl").



get_all_escort_type() ->
[1,2,3].

get_escort_reward(1,_Hp) when _Hp >= 0, _Hp =< 0 ->
	#base_escort_reward{type=1,hp_min=0,hp_max=0,score=30,guild_reward=[],person_reward=[{0,22030109,4},{0,81010041,1},{0,18010001,1},{0,22020001,40}],escort_type=0,escort_name= <<"严重受损"/utf8>>};
get_escort_reward(1,_Hp) when _Hp >= 1, _Hp =< 80 ->
	#base_escort_reward{type=1,hp_min=1,hp_max=80,score=40,guild_reward=[],person_reward=[{0,22030109,5},{0,81010041,1},{0,18010001,2},{0,22020001,50}],escort_type=1,escort_name= <<"普通护送"/utf8>>};
get_escort_reward(1,_Hp) when _Hp >= 81, _Hp =< 100 ->
	#base_escort_reward{type=1,hp_min=81,hp_max=100,score=40,guild_reward=[],person_reward=[{0,22030109,6},{0,81010041,1},{0,18010001,2},{0,22020001,60}],escort_type=2,escort_name= <<"完美护送"/utf8>>};
get_escort_reward(2,_Hp) when _Hp >= 0, _Hp =< 0 ->
	#base_escort_reward{type=2,hp_min=0,hp_max=0,score=60,guild_reward=[],person_reward=[{0,22030109,6},{0,81010041,2},{0,18010001,2},{0,22020001,50}],escort_type=0,escort_name= <<"严重受损"/utf8>>};
get_escort_reward(2,_Hp) when _Hp >= 1, _Hp =< 80 ->
	#base_escort_reward{type=2,hp_min=1,hp_max=80,score=80,guild_reward=[],person_reward=[{0,22030109,7},{0,81010041,2},{0,18010001,3},{0,22020001,65}],escort_type=1,escort_name= <<"普通护送"/utf8>>};
get_escort_reward(2,_Hp) when _Hp >= 81, _Hp =< 100 ->
	#base_escort_reward{type=2,hp_min=81,hp_max=100,score=80,guild_reward=[],person_reward=[{0,22030109,10},{0,81010041,2},{0,18010001,4},{0,22020001,80},{0,5901005,1}],escort_type=2,escort_name= <<"完美护送"/utf8>>};
get_escort_reward(3,_Hp) when _Hp >= 0, _Hp =< 0 ->
	#base_escort_reward{type=3,hp_min=0,hp_max=0,score=90,guild_reward=[],person_reward=[{0,22030109,8},{0,81010041,2},{0,18010001,3},{0,22020001,70}],escort_type=0,escort_name= <<"严重受损"/utf8>>};
get_escort_reward(3,_Hp) when _Hp >= 1, _Hp =< 80 ->
	#base_escort_reward{type=3,hp_min=1,hp_max=80,score=120,guild_reward=[],person_reward=[{0,22030109,12},{0,81010041,2},{0,18010001,4},{0,22020001,80}],escort_type=1,escort_name= <<"普通护送"/utf8>>};
get_escort_reward(3,_Hp) when _Hp >= 81, _Hp =< 100 ->
	#base_escort_reward{type=3,hp_min=81,hp_max=100,score=120,guild_reward=[],person_reward=[{0,22030109,15},{0,81010041,2},{0,18010001,6},{0,22020001,100},{0,5901005,1}],escort_type=2,escort_name= <<"完美护送"/utf8>>};
get_escort_reward(_Type,_Hp) ->
	#base_escort_reward{}.

get_rob_reward(1) ->
	#base_escort_rob_reward{type = 1,kill_score = 20,score = 1,guild_reward = [],person_reward = [{0,22030109,1},{0,22020001,10}]};

get_rob_reward(2) ->
	#base_escort_rob_reward{type = 2,kill_score = 40,score = 2,guild_reward = [],person_reward = [{0,22030109,2},{0,22020001,20}]};

get_rob_reward(3) ->
	#base_escort_rob_reward{type = 3,kill_score = 60,score = 3,guild_reward = [],person_reward = [{0,22030109,4},{0,22020001,40}]};

get_rob_reward(_Type) ->
	#base_escort_rob_reward{}.

get_rank_reward(_Rank) when _Rank >= 1, _Rank =< 1 ->
	#base_escort_rank_reward{rank_min=1,rank_max=1,guild_reward=[],person_reward=[{0,38065111,1},{0,22020001,100}]};
get_rank_reward(_Rank) when _Rank >= 2, _Rank =< 2 ->
	#base_escort_rank_reward{rank_min=2,rank_max=2,guild_reward=[],person_reward=[{0,38065112,1},{0,22020001,85}]};
get_rank_reward(_Rank) when _Rank >= 3, _Rank =< 3 ->
	#base_escort_rank_reward{rank_min=3,rank_max=3,guild_reward=[],person_reward=[{0,38065112,1},{0,22020001,70}]};
get_rank_reward(_Rank) ->
	#base_escort_rank_reward{}.


get_escort_value(dsgt_show_id) ->
305111;


get_escort_value(npc_pos) ->
{480001,1900,730};


get_escort_value(open_day) ->
7;


get_escort_value(open_lv) ->
300;


get_escort_value(open_time) ->
[];


get_escort_value(px_of_rob_reward) ->
350;


get_escort_value(revive_cost) ->
[{2,0,20}];


get_escort_value(rob_max_times) ->
2;


get_escort_value(update_position_time) ->
2;


get_escort_value(update_time) ->
5;

get_escort_value(_Key) ->
	[].

get_mon_type(1) ->
	#base_escort_mon{type = 1,name = <<"秩序水晶"/utf8>>,star = 2,cost = [{3,0,50000}],scene = 48001,monid = 480001,x = 2613,y = 608};

get_mon_type(2) ->
	#base_escort_mon{type = 2,name = <<"干扰水晶"/utf8>>,star = 3,cost = [{2,0,500}],scene = 48001,monid = 480002,x = 2613,y = 608};

get_mon_type(3) ->
	#base_escort_mon{type = 3,name = <<"神谕水晶"/utf8>>,star = 5,cost = [{1,0,300}],scene = 48002,monid = 480003,x = 2613,y = 608};

get_mon_type(_Type) ->
	[].

get_all_scene() ->
[48001,48002].


get_escort_mon_type(480001) ->
1;


get_escort_mon_type(480002) ->
2;


get_escort_mon_type(480003) ->
3;

get_escort_mon_type(_Monid) ->
	[].


get_escort_mon_id(1) ->
480001;


get_escort_mon_id(2) ->
480002;


get_escort_mon_id(3) ->
480003;

get_escort_mon_id(_Type) ->
	[].

