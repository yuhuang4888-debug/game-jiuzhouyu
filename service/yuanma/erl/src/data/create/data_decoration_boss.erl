%%%---------------------------------------
%%% module      : data_decoration_boss
%%% description : 幻饰boss配置
%%%
%%%---------------------------------------
-module(data_decoration_boss).
-compile(export_all).
-include("decoration_boss.hrl").




get_kv(1) ->
360;


get_kv(2) ->
4500101;


get_kv(3) ->
45003;


get_kv(4) ->
50;


get_kv(5) ->
600;


get_kv(6) ->
[{21,30}];


get_kv(7) ->
{2,20,2};


get_kv(8) ->
[{2,2,1000},{3,3,600},{4,4,300},{5,10,150},{11,20,50}];


get_kv(9) ->
2;


get_kv(10) ->
[{2,0,120}];


get_kv(11) ->
10;


get_kv(12) ->
{1171,546};


get_kv(13) ->
[{0,38040018,80},{0,32010388,1}];


get_kv(14) ->
10;


get_kv(15) ->
[55014201,55014301,55015201,55034201,55034301,55035201,55044201,55044301,55045201,55024201,55024301,55025201,55054201,55054301,55055201,55064201,55064301,55065201,68010005];


get_kv(16) ->
50;


get_kv(17) ->
[{460,1},{460,10},{460,11},{460,13}];


get_kv(18) ->
10;


get_kv(19) ->
[{0,38040018,20}];


get_kv(20) ->
5;


get_kv(21) ->
5;


get_kv(22) ->
false;


get_kv(23) ->
37100001;

get_kv(_Key) ->
	[].

get_boss(4500001) ->
	#base_decoration_boss{boss_id = 4500001,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1200,condition = [{lv,360}],buff_double_ids = []};

get_boss(4500002) ->
	#base_decoration_boss{boss_id = 4500002,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1200,condition = [{lv,360}],buff_double_ids = []};

get_boss(4500003) ->
	#base_decoration_boss{boss_id = 4500003,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 1800,condition = [{lv,360}],buff_double_ids = []};

get_boss(4500004) ->
	#base_decoration_boss{boss_id = 4500004,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1500,condition = [{lv,370},{decoration_rating,150000}],buff_double_ids = []};

get_boss(4500005) ->
	#base_decoration_boss{boss_id = 4500005,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 2100,condition = [{lv,370},{decoration_rating,150000}],buff_double_ids = []};

get_boss(4500006) ->
	#base_decoration_boss{boss_id = 4500006,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1500,condition = [{lv,390},{decoration_rating,300000}],buff_double_ids = []};

get_boss(4500007) ->
	#base_decoration_boss{boss_id = 4500007,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 2400,condition = [{lv,390},{decoration_rating,300000}],buff_double_ids = []};

get_boss(4500008) ->
	#base_decoration_boss{boss_id = 4500008,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1800,condition = [{lv,410},{decoration_rating,650000}],buff_double_ids = []};

get_boss(4500009) ->
	#base_decoration_boss{boss_id = 4500009,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 2700,condition = [{lv,410},{decoration_rating,650000}],buff_double_ids = []};

get_boss(4500010) ->
	#base_decoration_boss{boss_id = 4500010,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1800,condition = [{lv,435},{decoration_rating,850000}],buff_double_ids = []};

get_boss(4500011) ->
	#base_decoration_boss{boss_id = 4500011,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3000,condition = [{lv,435},{decoration_rating,850000}],buff_double_ids = []};

get_boss(4500012) ->
	#base_decoration_boss{boss_id = 4500012,scene_id = 45001,cls_type = 1,boss_type = 2,x = 1497,y = 874,role_num = 10,revive_time = 1800,condition = [{lv,460},{decoration_rating,1150000}],buff_double_ids = []};

get_boss(4500013) ->
	#base_decoration_boss{boss_id = 4500013,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3300,condition = [{lv,460},{decoration_rating,1150000}],buff_double_ids = []};

get_boss(4500014) ->
	#base_decoration_boss{boss_id = 4500014,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,470},{decoration_rating,1450000}],buff_double_ids = []};

get_boss(4500015) ->
	#base_decoration_boss{boss_id = 4500015,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,480},{decoration_rating,1800000}],buff_double_ids = []};

get_boss(4500016) ->
	#base_decoration_boss{boss_id = 4500016,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,580},{decoration_rating,1800000},{constellation_suit, 1, 0},{open_day,60}],buff_double_ids = []};

get_boss(4500017) ->
	#base_decoration_boss{boss_id = 4500017,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,590},{decoration_rating,1800000},{constellation_suit, 1, 2},{open_day,60}],buff_double_ids = []};

get_boss(4500018) ->
	#base_decoration_boss{boss_id = 4500018,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,600},{decoration_rating,1800000},{constellation_suit, 1, 4},{open_day,60}],buff_double_ids = []};

get_boss(4500019) ->
	#base_decoration_boss{boss_id = 4500019,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,610},{decoration_rating,1800000},{constellation_suit, 2, 2},{open_day,60}],buff_double_ids = []};

get_boss(4500020) ->
	#base_decoration_boss{boss_id = 4500020,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,620},{decoration_rating,1800000},{constellation_suit, 2, 4},{open_day,60}],buff_double_ids = []};

get_boss(4500021) ->
	#base_decoration_boss{boss_id = 4500021,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,630},{decoration_rating,1800000},{constellation_suit, 3, 2},{open_day,60}],buff_double_ids = []};

get_boss(4500022) ->
	#base_decoration_boss{boss_id = 4500022,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,640},{decoration_rating,1800000},{constellation_suit, 3, 4},{open_day,60}],buff_double_ids = []};

get_boss(4500023) ->
	#base_decoration_boss{boss_id = 4500023,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,650},{decoration_rating,1800000},{constellation_suit, 4, 2},{open_day,60}],buff_double_ids = []};

get_boss(4500024) ->
	#base_decoration_boss{boss_id = 4500024,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,660},{decoration_rating,1800000},{constellation_suit, 4, 4},{open_day,60}],buff_double_ids = []};

get_boss(4500025) ->
	#base_decoration_boss{boss_id = 4500025,scene_id = 45002,cls_type = 1,boss_type = 1,x = 2906,y = 1571,role_num = 10,revive_time = 3600,condition = [{lv,670},{decoration_rating,1800000},{constellation_suit, 5, 2},{open_day,60}],buff_double_ids = []};

get_boss(_Bossid) ->
	[].

get_boss_id_list() ->
[4500001,4500002,4500003,4500004,4500005,4500006,4500007,4500008,4500009,4500010,4500011,4500012,4500013,4500014,4500015,4500016,4500017,4500018,4500019,4500020,4500021,4500022,4500023,4500024,4500025].

