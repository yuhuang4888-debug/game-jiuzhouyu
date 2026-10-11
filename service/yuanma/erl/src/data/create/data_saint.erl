%%%---------------------------------------
%%% module      : data_saint
%%% description : 圣者殿配置
%%%
%%%---------------------------------------
-module(data_saint).
-compile(export_all).
-include("saint.hrl").




get_cfg(open_lv) ->
255;


get_cfg(fight_scene_saint_y) ->
739;


get_cfg(fight_scene_saint_x) ->
1676;


get_cfg(ready_scene) ->
5201;


get_cfg(fight_scene) ->
5202;


get_cfg(cd) ->
300;


get_cfg(turntable_time) ->
10;


get_cfg(battle_time) ->
60;


get_cfg(max_record) ->
15;


get_cfg(success_reward) ->
[{100,48110001,2}];


get_cfg(fail_reward) ->
[{100,48110001,1}];

get_cfg(_Key) ->
	[].

get_stone(5201001) ->
	#base_saint_stone{id = 5201001,name = <<"许珀里翁石像"/utf8>>,born_x = 5162,born_y = 5847,fight_cd = 300,dsgt_id = 400024};

get_stone(5201002) ->
	#base_saint_stone{id = 5201002,name = <<"墨丘利石像"/utf8>>,born_x = 2841,born_y = 4629,fight_cd = 300,dsgt_id = 400025};

get_stone(5201003) ->
	#base_saint_stone{id = 5201003,name = <<"维纳斯石像"/utf8>>,born_x = 7398,born_y = 4629,fight_cd = 300,dsgt_id = 400025};

get_stone(5201004) ->
	#base_saint_stone{id = 5201004,name = <<"厄斯石像"/utf8>>,born_x = 920,born_y = 3810,fight_cd = 300,dsgt_id = 400026};

get_stone(5201005) ->
	#base_saint_stone{id = 5201005,name = <<"玛尔斯石像"/utf8>>,born_x = 9393,born_y = 3862,fight_cd = 300,dsgt_id = 400026};

get_stone(5201006) ->
	#base_saint_stone{id = 5201006,name = <<"朱庇特石像"/utf8>>,born_x = 1476,born_y = 2560,fight_cd = 300,dsgt_id = 400026};

get_stone(5201007) ->
	#base_saint_stone{id = 5201007,name = <<"萨图恩石像"/utf8>>,born_x = 8805,born_y = 2560,fight_cd = 300,dsgt_id = 400027};

get_stone(5201008) ->
	#base_saint_stone{id = 5201008,name = <<"乌拉诺斯石像"/utf8>>,born_x = 2148,born_y = 1132,fight_cd = 300,dsgt_id = 400027};

get_stone(5201009) ->
	#base_saint_stone{id = 5201009,name = <<"尼普顿石像"/utf8>>,born_x = 8165,born_y = 1143,fight_cd = 300,dsgt_id = 400027};

get_stone(5201010) ->
	#base_saint_stone{id = 5201010,name = <<"普鲁托石像"/utf8>>,born_x = 5162,born_y = 1300,fight_cd = 300,dsgt_id = 400027};

get_stone(_Id) ->
	[].

get_all_saint_id() ->
[5201001,5201002,5201003,5201004,5201005,5201006,5201007,5201008,5201009,5201010].

get_turntable(1) ->
	#base_saint_turntable{id = 1,attr = [{19,1000}],prob = 50};

get_turntable(2) ->
	#base_saint_turntable{id = 2,attr = [{20,1000}],prob = 50};

get_turntable(3) ->
	#base_saint_turntable{id = 3,attr = [{19,-1000}],prob = 50};

get_turntable(4) ->
	#base_saint_turntable{id = 4,attr = [{20,-1000}],prob = 50};

get_turntable(5) ->
	#base_saint_turntable{id = 5,attr = [{19,2000},{20,-1000}],prob = 50};

get_turntable(6) ->
	#base_saint_turntable{id = 6,attr = [{20,2000},{19,-1000}],prob = 50};

get_turntable(_Id) ->
	[].

get_turntable_ids() ->
[1,2,3,4,5,6].

get_inspire(1) ->
	#base_saint_inspire{id = 1,name = "狂暴药水",effect = [{attr, [{9,1000}]}, {time,10}],num_limit = 5,type = 2,price = 15};

get_inspire(2) ->
	#base_saint_inspire{id = 2,name = "坚硬药水",effect = [{attr, [{10,1000}]}, {time,10}],num_limit = 5,type = 2,price = 15};

get_inspire(_Id) ->
	[].

