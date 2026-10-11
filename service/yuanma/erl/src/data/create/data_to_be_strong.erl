%%%---------------------------------------
%%% module      : data_to_be_strong
%%% description : 我要变强配置
%%%
%%%---------------------------------------
-module(data_to_be_strong).
-compile(export_all).
-include("strong.hrl").



get_cfg(1001) ->
	#to_be_strong_cfg{id = 1001,mod_id = 610,type = 1,lv = 70,day_limit = 1};

get_cfg(1002) ->
	#to_be_strong_cfg{id = 1002,mod_id = 300,type = 1,lv = 65,day_limit = 1};

get_cfg(1003) ->
	#to_be_strong_cfg{id = 1003,mod_id = 300,type = 1,lv = 130,day_limit = 1};

get_cfg(1004) ->
	#to_be_strong_cfg{id = 1004,mod_id = 132,type = 1,lv = 1,day_limit = 0};

get_cfg(1005) ->
	#to_be_strong_cfg{id = 1005,mod_id = 415,type = 1,lv = 130,day_limit = 1};

get_cfg(1006) ->
	#to_be_strong_cfg{id = 1006,mod_id = 402,type = 1,lv = 100,day_limit = 1};

get_cfg(1007) ->
	#to_be_strong_cfg{id = 1007,mod_id = 300,type = 1,lv = 1,day_limit = 0};

get_cfg(1008) ->
	#to_be_strong_cfg{id = 1008,mod_id = 280,type = 1,lv = 50,day_limit = 1};

get_cfg(1010) ->
	#to_be_strong_cfg{id = 1010,mod_id = 505,type = 1,lv = 125,day_limit = 1};

get_cfg(1011) ->
	#to_be_strong_cfg{id = 1011,mod_id = 135,type = 1,lv = 100,day_limit = 1};

get_cfg(1012) ->
	#to_be_strong_cfg{id = 1012,mod_id = 189,type = 1,lv = 200,day_limit = 1};

get_cfg(2001) ->
	#to_be_strong_cfg{id = 2001,mod_id = 505,type = 2,lv = 125,day_limit = 1};

get_cfg(2003) ->
	#to_be_strong_cfg{id = 2003,mod_id = 280,type = 2,lv = 50,day_limit = 1};

get_cfg(2004) ->
	#to_be_strong_cfg{id = 2004,mod_id = 409,type = 2,lv = 50,day_limit = 0};

get_cfg(2006) ->
	#to_be_strong_cfg{id = 2006,mod_id = 137,type = 2,lv = 100,day_limit = 1};

get_cfg(2007) ->
	#to_be_strong_cfg{id = 2007,mod_id = 189,type = 2,lv = 200,day_limit = 1};

get_cfg(3001) ->
	#to_be_strong_cfg{id = 3001,mod_id = 460,type = 3,lv = 78,day_limit = 0};

get_cfg(3002) ->
	#to_be_strong_cfg{id = 3002,mod_id = 283,type = 3,lv = 160,day_limit = 0};

get_cfg(3003) ->
	#to_be_strong_cfg{id = 3003,mod_id = 460,type = 3,lv = 78,day_limit = 0};

get_cfg(3004) ->
	#to_be_strong_cfg{id = 3004,mod_id = 460,type = 3,lv = 120,day_limit = 1};

get_cfg(3005) ->
	#to_be_strong_cfg{id = 3005,mod_id = 460,type = 3,lv = 240,day_limit = 1};

get_cfg(3006) ->
	#to_be_strong_cfg{id = 3006,mod_id = 402,type = 3,lv = 100,day_limit = 1};

get_cfg(4001) ->
	#to_be_strong_cfg{id = 4001,mod_id = 152,type = 4,lv = 1,day_limit = 0};

get_cfg(4002) ->
	#to_be_strong_cfg{id = 4002,mod_id = 160,type = 4,lv = 1,day_limit = 0};

get_cfg(4004) ->
	#to_be_strong_cfg{id = 4004,mod_id = 460,type = 4,lv = 1,day_limit = 0};

get_cfg(5001) ->
	#to_be_strong_cfg{id = 5001,mod_id = 183,type = 5,lv = 520,day_limit = 0};

get_cfg(_Id) ->
	[].

get_all_id() ->
[1001,1002,1003,1004,1005,1006,1007,1008,1010,1011,1012,2001,2003,2004,2006,2007,3001,3002,3003,3004,3005,3006,4001,4002,4004,5001].

get_all_limit_lv() ->
[1,50,65,70,78,100,120,125,130,160,200,240,520].


get_is_day_limit(1001) ->
1;


get_is_day_limit(1002) ->
1;


get_is_day_limit(1003) ->
1;


get_is_day_limit(1004) ->
0;


get_is_day_limit(1005) ->
1;


get_is_day_limit(1006) ->
1;


get_is_day_limit(1007) ->
0;


get_is_day_limit(1008) ->
1;


get_is_day_limit(1010) ->
1;


get_is_day_limit(1011) ->
1;


get_is_day_limit(1012) ->
1;


get_is_day_limit(2001) ->
1;


get_is_day_limit(2003) ->
1;


get_is_day_limit(2004) ->
0;


get_is_day_limit(2006) ->
1;


get_is_day_limit(2007) ->
1;


get_is_day_limit(3001) ->
0;


get_is_day_limit(3002) ->
0;


get_is_day_limit(3003) ->
0;


get_is_day_limit(3004) ->
1;


get_is_day_limit(3005) ->
1;


get_is_day_limit(3006) ->
1;


get_is_day_limit(4001) ->
0;


get_is_day_limit(4002) ->
0;


get_is_day_limit(4004) ->
0;


get_is_day_limit(5001) ->
0;

get_is_day_limit(_Id) ->
	[].

