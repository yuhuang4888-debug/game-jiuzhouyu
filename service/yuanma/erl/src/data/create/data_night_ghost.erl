%%%---------------------------------------
%%% module      : data_night_ghost
%%% description : 百鬼夜行配置
%%%
%%%---------------------------------------
-module(data_night_ghost).
-compile(export_all).
-include("night_ghost.hrl").




get(1) ->
130;


get(2) ->
1800;


get(4) ->
[{0,5902011,0},{0,5901005,0},{255,36255115,0},{0,32060119,0},{2,0,0},{3,0,0}];


get(5) ->
300;


get(6) ->
180;


get(7) ->
2101;


get(8) ->
[{1, [{3,0,12581}]}, {2, [{3,0,12581}]}, {4, [{3,0,12581}]}, {8, [{3,0,12580}]}];

get(_Key) ->
	[].

get_ng_boss(1,57001) ->
	#base_night_ghost_boss{ser_mod = 1,mon_id = 570001001,scene_id = 57001,loc_list = [{{2316,1328},"青道竹苑1"},{{6176,2140},"青道竹苑2"},{{4656,3212},"青道竹苑3"},{{6504,4568},"青道竹苑4"},{{1020,4180},"青道竹苑5"},{{2448,5568},"青道竹苑6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(1,57002) ->
	#base_night_ghost_boss{ser_mod = 1,mon_id = 570001002,scene_id = 57002,loc_list = [{{2128,2135},"红枫幻城1"},{{1174,3962},"红枫幻城2"},{{4522,5627},"红枫幻城3"},{{6143,3990},"红枫幻城4"},{{6247,1313},"红枫幻城5"},{{4458,796},"红枫幻城6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(1,57003) ->
	#base_night_ghost_boss{ser_mod = 1,mon_id = 570001003,scene_id = 57003,loc_list = [{{5032,967},"竹苑后山1"},{{1513,1401},"竹苑后山2"},{{3893,2922},"竹苑后山3"},{{6630,3135},"竹苑后山4"},{{6188,6297},"竹苑后山5"},{{2745,5183},"竹苑后山6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(2,57011) ->
	#base_night_ghost_boss{ser_mod = 2,mon_id = 570001005,scene_id = 57011,loc_list = [{{2316,1328},"青道竹苑1"},{{6176,2140},"青道竹苑2"},{{4656,3212},"青道竹苑3"},{{6504,4568},"青道竹苑4"},{{1020,4180},"青道竹苑5"},{{2448,5568},"青道竹苑6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(2,57012) ->
	#base_night_ghost_boss{ser_mod = 2,mon_id = 570001006,scene_id = 57012,loc_list = [{{2128,2135},"红枫幻城1"},{{1174,3962},"红枫幻城2"},{{4522,5627},"红枫幻城3"},{{6143,3990},"红枫幻城4"},{{6247,1313},"红枫幻城5"},{{4458,796},"红枫幻城6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(2,57013) ->
	#base_night_ghost_boss{ser_mod = 2,mon_id = 570001007,scene_id = 57013,loc_list = [{{5032,967},"竹苑后山1"},{{1513,1401},"竹苑后山2"},{{3893,2922},"竹苑后山3"},{{6630,3135},"竹苑后山4"},{{6188,6297},"竹苑后山5"},{{2745,5183},"竹苑后山6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(4,57011) ->
	#base_night_ghost_boss{ser_mod = 4,mon_id = 570001005,scene_id = 57011,loc_list = [{{2316,1328},"青道竹苑1"},{{6176,2140},"青道竹苑2"},{{4656,3212},"青道竹苑3"},{{6504,4568},"青道竹苑4"},{{1020,4180},"青道竹苑5"},{{2448,5568},"青道竹苑6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(4,57012) ->
	#base_night_ghost_boss{ser_mod = 4,mon_id = 570001006,scene_id = 57012,loc_list = [{{2128,2135},"红枫幻城1"},{{1174,3962},"红枫幻城2"},{{4522,5627},"红枫幻城3"},{{6143,3990},"红枫幻城4"},{{6247,1313},"红枫幻城5"},{{4458,796},"红枫幻城6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(4,57013) ->
	#base_night_ghost_boss{ser_mod = 4,mon_id = 570001007,scene_id = 57013,loc_list = [{{5032,967},"竹苑后山1"},{{1513,1401},"竹苑后山2"},{{3893,2922},"竹苑后山3"},{{6630,3135},"竹苑后山4"},{{6188,6297},"竹苑后山5"},{{2745,5183},"竹苑后山6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(8,57011) ->
	#base_night_ghost_boss{ser_mod = 8,mon_id = 570001005,scene_id = 57011,loc_list = [{{2316,1328},"青道竹苑1"},{{6176,2140},"青道竹苑2"},{{4656,3212},"青道竹苑3"},{{6504,4568},"青道竹苑4"},{{1020,4180},"青道竹苑5"},{{2448,5568},"青道竹苑6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(8,57012) ->
	#base_night_ghost_boss{ser_mod = 8,mon_id = 570001006,scene_id = 57012,loc_list = [{{2128,2135},"红枫幻城1"},{{1174,3962},"红枫幻城2"},{{4522,5627},"红枫幻城3"},{{6143,3990},"红枫幻城4"},{{6247,1313},"红枫幻城5"},{{4458,796},"红枫幻城6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(8,57013) ->
	#base_night_ghost_boss{ser_mod = 8,mon_id = 570001007,scene_id = 57013,loc_list = [{{5032,967},"竹苑后山1"},{{1513,1401},"竹苑后山2"},{{3893,2922},"竹苑后山3"},{{6630,3135},"竹苑后山4"},{{6188,6297},"竹苑后山5"},{{2745,5183},"竹苑后山6"}],liveness_num = [{{0,800},2},{{801,1200},3},{{1201,1800},4},{{1801,2100},5},{{2101,9999999},6}]};

get_ng_boss(_Sermod,_Sceneid) ->
	[].


get_scene_list(1) ->
[57001,57002,57003];


get_scene_list(2) ->
[57011,57012,57013];


get_scene_list(4) ->
[57011,57012,57013];


get_scene_list(8) ->
[57011,57012,57013];

get_scene_list(_Sermod) ->
	[].

get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 0, Opday =< 1 ->
		[{255,36255115,1000},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 0, Opday =< 1 ->
		[{255,36255115,800},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 0, Opday =< 1 ->
		[{255,36255115,600},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 0, Opday =< 1 ->
		[{255,36255115,550},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 0, Opday =< 1 ->
		[{255,36255115,500},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 0, Opday =< 1 ->
		[{255,36255115,450},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 0, Opday =< 1 ->
		[{255,36255115,400},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 0, Opday =< 1 ->
		[{255,36255115,400},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 0, Opday =< 1 ->
		[{255,36255115,350},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 0, Opday =< 1 ->
		[{255,36255115,300},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 0, Opday =< 1 ->
		[{255,36255115,250},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 0, Opday =< 1 ->
		[{255,36255115,200},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 0, Opday =< 1 ->
		[{255,36255115,150},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 0, Opday =< 1 ->
		[{255,36255115,100},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 2, Opday =< 2 ->
		[{255,36255115,1200},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 2, Opday =< 2 ->
		[{255,36255115,960},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 2, Opday =< 2 ->
		[{255,36255115,720},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 2, Opday =< 2 ->
		[{255,36255115,660},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 2, Opday =< 2 ->
		[{255,36255115,600},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 2, Opday =< 2 ->
		[{255,36255115,540},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 2, Opday =< 2 ->
		[{255,36255115,480},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 2, Opday =< 2 ->
		[{255,36255115,480},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 2, Opday =< 2 ->
		[{255,36255115,420},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 2, Opday =< 2 ->
		[{255,36255115,360},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 2, Opday =< 2 ->
		[{255,36255115,300},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 2, Opday =< 2 ->
		[{255,36255115,240},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 2, Opday =< 2 ->
		[{255,36255115,180},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 2, Opday =< 2 ->
		[{255,36255115,120},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 3, Opday =< 5 ->
		[{255,36255115,1400},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 3, Opday =< 5 ->
		[{255,36255115,1120},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 3, Opday =< 5 ->
		[{255,36255115,840},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 3, Opday =< 5 ->
		[{255,36255115,770},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 3, Opday =< 5 ->
		[{255,36255115,700},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 3, Opday =< 5 ->
		[{255,36255115,630},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 3, Opday =< 5 ->
		[{255,36255115,560},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 3, Opday =< 5 ->
		[{255,36255115,560},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 3, Opday =< 5 ->
		[{255,36255115,490},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 3, Opday =< 5 ->
		[{255,36255115,420},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 3, Opday =< 5 ->
		[{255,36255115,350},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 3, Opday =< 5 ->
		[{255,36255115,280},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 3, Opday =< 5 ->
		[{255,36255115,210},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 3, Opday =< 5 ->
		[{255,36255115,140},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 6, Opday =< 15 ->
		[{255,36255115,1600},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 6, Opday =< 15 ->
		[{255,36255115,1280},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 6, Opday =< 15 ->
		[{255,36255115,960},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 6, Opday =< 15 ->
		[{255,36255115,880},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 6, Opday =< 15 ->
		[{255,36255115,800},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 6, Opday =< 15 ->
		[{255,36255115,720},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 6, Opday =< 15 ->
		[{255,36255115,640},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 6, Opday =< 15 ->
		[{255,36255115,640},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 6, Opday =< 15 ->
		[{255,36255115,560},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 6, Opday =< 15 ->
		[{255,36255115,480},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 6, Opday =< 15 ->
		[{255,36255115,400},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 6, Opday =< 15 ->
		[{255,36255115,320},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 6, Opday =< 15 ->
		[{255,36255115,240},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 6, Opday =< 15 ->
		[{255,36255115,160},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 16, Opday =< 25 ->
		[{255,36255115,1800},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 16, Opday =< 25 ->
		[{255,36255115,1440},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 16, Opday =< 25 ->
		[{255,36255115,1080},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 16, Opday =< 25 ->
		[{255,36255115,990},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 16, Opday =< 25 ->
		[{255,36255115,900},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 16, Opday =< 25 ->
		[{255,36255115,810},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 16, Opday =< 25 ->
		[{255,36255115,720},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 16, Opday =< 25 ->
		[{255,36255115,720},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 16, Opday =< 25 ->
		[{255,36255115,630},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 16, Opday =< 25 ->
		[{255,36255115,540},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 16, Opday =< 25 ->
		[{255,36255115,450},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 16, Opday =< 25 ->
		[{255,36255115,360},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 16, Opday =< 25 ->
		[{255,36255115,270},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 16, Opday =< 25 ->
		[{255,36255115,180},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 26, Opday =< 45 ->
		[{255,36255115,1950},{0,32060119,12}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 26, Opday =< 45 ->
		[{255,36255115,1560},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 26, Opday =< 45 ->
		[{255,36255115,1170},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 26, Opday =< 45 ->
		[{255,36255115,1070},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 26, Opday =< 45 ->
		[{255,36255115,980},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 26, Opday =< 45 ->
		[{255,36255115,880},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 26, Opday =< 45 ->
		[{255,36255115,780},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 26, Opday =< 45 ->
		[{255,36255115,780},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 26, Opday =< 45 ->
		[{255,36255115,680},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 26, Opday =< 45 ->
		[{255,36255115,590},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 26, Opday =< 45 ->
		[{255,36255115,490},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 26, Opday =< 45 ->
		[{255,36255115,390},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 26, Opday =< 45 ->
		[{255,36255115,290},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 26, Opday =< 45 ->
		[{255,36255115,200},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 46, Opday =< 75 ->
		[{255,36255115,2100},{0,32060119,12}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 46, Opday =< 75 ->
		[{255,36255115,1680},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 46, Opday =< 75 ->
		[{255,36255115,1260},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 46, Opday =< 75 ->
		[{255,36255115,1160},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 46, Opday =< 75 ->
		[{255,36255115,1050},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 46, Opday =< 75 ->
		[{255,36255115,950},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 46, Opday =< 75 ->
		[{255,36255115,840},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 46, Opday =< 75 ->
		[{255,36255115,840},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 46, Opday =< 75 ->
		[{255,36255115,740},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 46, Opday =< 75 ->
		[{255,36255115,630},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 46, Opday =< 75 ->
		[{255,36255115,530},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 46, Opday =< 75 ->
		[{255,36255115,420},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 46, Opday =< 75 ->
		[{255,36255115,320},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 46, Opday =< 75 ->
		[{255,36255115,210},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 76, Opday =< 115 ->
		[{255,36255115,2200},{0,32060119,13}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 76, Opday =< 115 ->
		[{255,36255115,1760},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 76, Opday =< 115 ->
		[{255,36255115,1320},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 76, Opday =< 115 ->
		[{255,36255115,1210},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 76, Opday =< 115 ->
		[{255,36255115,1100},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 76, Opday =< 115 ->
		[{255,36255115,990},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 76, Opday =< 115 ->
		[{255,36255115,880},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 76, Opday =< 115 ->
		[{255,36255115,880},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 76, Opday =< 115 ->
		[{255,36255115,770},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 76, Opday =< 115 ->
		[{255,36255115,660},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 76, Opday =< 115 ->
		[{255,36255115,550},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 76, Opday =< 115 ->
		[{255,36255115,440},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 76, Opday =< 115 ->
		[{255,36255115,330},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 76, Opday =< 115 ->
		[{255,36255115,220},{0,32060119,1}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 116, Opday =< 155 ->
		[{255,36255115,2300},{0,32060119,15}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 116, Opday =< 155 ->
		[{255,36255115,1840},{0,32060119,11}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 116, Opday =< 155 ->
		[{255,36255115,1380},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 116, Opday =< 155 ->
		[{255,36255115,1270},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 116, Opday =< 155 ->
		[{255,36255115,1150},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 116, Opday =< 155 ->
		[{255,36255115,1040},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 116, Opday =< 155 ->
		[{255,36255115,920},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 116, Opday =< 155 ->
		[{255,36255115,920},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 116, Opday =< 155 ->
		[{255,36255115,810},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 116, Opday =< 155 ->
		[{255,36255115,690},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 116, Opday =< 155 ->
		[{255,36255115,580},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 116, Opday =< 155 ->
		[{255,36255115,460},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 116, Opday =< 155 ->
		[{255,36255115,350},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 116, Opday =< 155 ->
		[{255,36255115,230},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 156, Opday =< 195 ->
		[{255,36255115,2400},{0,32060119,16}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 156, Opday =< 195 ->
		[{255,36255115,1920},{0,32060119,11}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 156, Opday =< 195 ->
		[{255,36255115,1440},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 156, Opday =< 195 ->
		[{255,36255115,1320},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 156, Opday =< 195 ->
		[{255,36255115,1200},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 156, Opday =< 195 ->
		[{255,36255115,1080},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 156, Opday =< 195 ->
		[{255,36255115,960},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 156, Opday =< 195 ->
		[{255,36255115,960},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 156, Opday =< 195 ->
		[{255,36255115,840},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 156, Opday =< 195 ->
		[{255,36255115,720},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 156, Opday =< 195 ->
		[{255,36255115,600},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 156, Opday =< 195 ->
		[{255,36255115,480},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 156, Opday =< 195 ->
		[{255,36255115,360},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 156, Opday =< 195 ->
		[{255,36255115,240},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 196, Opday =< 235 ->
		[{255,36255115,2500},{0,32060119,18}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 196, Opday =< 235 ->
		[{255,36255115,2000},{0,32060119,13}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 196, Opday =< 235 ->
		[{255,36255115,1500},{0,32060119,11}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 196, Opday =< 235 ->
		[{255,36255115,1380},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 196, Opday =< 235 ->
		[{255,36255115,1250},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 196, Opday =< 235 ->
		[{255,36255115,1130},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 196, Opday =< 235 ->
		[{255,36255115,1000},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 196, Opday =< 235 ->
		[{255,36255115,1000},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 196, Opday =< 235 ->
		[{255,36255115,880},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 196, Opday =< 235 ->
		[{255,36255115,750},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 196, Opday =< 235 ->
		[{255,36255115,630},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 196, Opday =< 235 ->
		[{255,36255115,500},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 196, Opday =< 235 ->
		[{255,36255115,380},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 196, Opday =< 235 ->
		[{255,36255115,250},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 236, Opday =< 275 ->
		[{255,36255115,2500},{0,32060119,18}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 236, Opday =< 275 ->
		[{255,36255115,2000},{0,32060119,13}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 236, Opday =< 275 ->
		[{255,36255115,1500},{0,32060119,11}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 236, Opday =< 275 ->
		[{255,36255115,1380},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 236, Opday =< 275 ->
		[{255,36255115,1250},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 236, Opday =< 275 ->
		[{255,36255115,1130},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 236, Opday =< 275 ->
		[{255,36255115,1000},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 236, Opday =< 275 ->
		[{255,36255115,1000},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 236, Opday =< 275 ->
		[{255,36255115,880},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 236, Opday =< 275 ->
		[{255,36255115,750},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 236, Opday =< 275 ->
		[{255,36255115,630},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 236, Opday =< 275 ->
		[{255,36255115,500},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 236, Opday =< 275 ->
		[{255,36255115,380},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 236, Opday =< 275 ->
		[{255,36255115,250},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 276, Opday =< 315 ->
		[{255,36255115,2600},{0,32060119,20}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 276, Opday =< 315 ->
		[{255,36255115,2080},{0,32060119,14}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 276, Opday =< 315 ->
		[{255,36255115,1560},{0,32060119,12}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 276, Opday =< 315 ->
		[{255,36255115,1430},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 276, Opday =< 315 ->
		[{255,36255115,1300},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 276, Opday =< 315 ->
		[{255,36255115,1170},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 276, Opday =< 315 ->
		[{255,36255115,1040},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 276, Opday =< 315 ->
		[{255,36255115,1040},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 276, Opday =< 315 ->
		[{255,36255115,910},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 276, Opday =< 315 ->
		[{255,36255115,780},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 276, Opday =< 315 ->
		[{255,36255115,650},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 276, Opday =< 315 ->
		[{255,36255115,520},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 276, Opday =< 315 ->
		[{255,36255115,390},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 276, Opday =< 315 ->
		[{255,36255115,260},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 316, Opday =< 355 ->
		[{255,36255115,2600},{0,32060119,20}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 316, Opday =< 355 ->
		[{255,36255115,2080},{0,32060119,14}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 316, Opday =< 355 ->
		[{255,36255115,1560},{0,32060119,12}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 316, Opday =< 355 ->
		[{255,36255115,1430},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 316, Opday =< 355 ->
		[{255,36255115,1300},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 316, Opday =< 355 ->
		[{255,36255115,1170},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 316, Opday =< 355 ->
		[{255,36255115,1040},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 316, Opday =< 355 ->
		[{255,36255115,1040},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 316, Opday =< 355 ->
		[{255,36255115,910},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 316, Opday =< 355 ->
		[{255,36255115,780},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 316, Opday =< 355 ->
		[{255,36255115,650},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 316, Opday =< 355 ->
		[{255,36255115,520},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 316, Opday =< 355 ->
		[{255,36255115,390},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 316, Opday =< 355 ->
		[{255,36255115,260},{0,32060119,2}];
get_ng_reward(1,Rank,Opday) when Rank >= 1, Rank =< 1, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,2700},{0,32060119,20}];
get_ng_reward(1,Rank,Opday) when Rank >= 2, Rank =< 2, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,2160},{0,32060119,14}];
get_ng_reward(1,Rank,Opday) when Rank >= 3, Rank =< 3, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,1620},{0,32060119,12}];
get_ng_reward(1,Rank,Opday) when Rank >= 4, Rank =< 4, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,1490},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 5, Rank =< 5, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,1350},{0,32060119,10}];
get_ng_reward(1,Rank,Opday) when Rank >= 6, Rank =< 6, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,1220},{0,32060119,9}];
get_ng_reward(1,Rank,Opday) when Rank >= 7, Rank =< 7, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,1080},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 8, Rank =< 8, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,1080},{0,32060119,8}];
get_ng_reward(1,Rank,Opday) when Rank >= 9, Rank =< 9, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,950},{0,32060119,7}];
get_ng_reward(1,Rank,Opday) when Rank >= 10, Rank =< 10, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,810},{0,32060119,6}];
get_ng_reward(1,Rank,Opday) when Rank >= 11, Rank =< 15, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,680},{0,32060119,5}];
get_ng_reward(1,Rank,Opday) when Rank >= 16, Rank =< 30, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,540},{0,32060119,4}];
get_ng_reward(1,Rank,Opday) when Rank >= 31, Rank =< 50, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,410},{0,32060119,3}];
get_ng_reward(1,Rank,Opday) when Rank >= 51, Rank =< 65535, Opday >= 356, Opday =< 9999 ->
		[{255,36255115,270},{0,32060119,2}];
get_ng_reward(2,Rank,Opday) when Rank >= 0, Rank =< 65535, Opday >= 0, Opday =< 9999 ->
		[{255,36255115,666},{2,0,18},{3,0,66666}];
get_ng_reward(_Type,_Rank,_Opday) ->
	[].

