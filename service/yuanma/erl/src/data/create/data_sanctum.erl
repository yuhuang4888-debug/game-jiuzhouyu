%%%---------------------------------------
%%% module      : data_sanctum
%%% description : 永恒圣殿配置
%%%
%%%---------------------------------------
-module(data_sanctum).
-compile(export_all).
-include("kf_sanctum.hrl").



get_mon_type(1) ->
	#base_sanctum_montype{montype = 1,refresh = [{time, 5}],reborn_time = 0};

get_mon_type(2) ->
	#base_sanctum_montype{montype = 2,refresh = [],reborn_time = 360};

get_mon_type(3) ->
	#base_sanctum_montype{montype = 3,refresh = [],reborn_time = 0};

get_mon_type(_Montype) ->
	[].

get_all_mon_type() ->
[1,2,3].

get_scene_mon_info(44001,1) ->
	#base_sanctum_scene{scene = 44001,montype = 1,mon_num = 1,mon = [{44001101, 4171,4149}]};

get_scene_mon_info(44001,2) ->
	#base_sanctum_scene{scene = 44001,montype = 2,mon_num = 8,mon = [{44001201,1492,7157},{44001202,4200,6647},{44001203,1239,4401},{44001204, 7223,4280},{44001205,6876,7382},{44001206,1574,1151},{44001207,4324,755},{44001208,6761,1761}]};

get_scene_mon_info(44001,3) ->
	#base_sanctum_scene{scene = 44001,montype = 3,mon_num = 1,mon = [{44001301,1252,1793},{44001301,2081,2629},{44001301,1169,2445},{44001301,1944,1965},{44001301,1729,2333},{44001301,1597,2753},{44001301,876,2064},{44001301,2229,2285},{44001301,1354,2112},{44001301,1633,1829},{44002301,2857,4786},{44002301,3176,5856},{44002301,2063,5247},{44002301,3390,5059},{44002301,2298,4851},{44002301,2634,5132},{44002301,2567,5695},{44002301,3000,5354},{44002301,3469,5481},{44003301,56265,3208},{44003301,5823,4063},{44003301,6727,3436},{44003301,5371,3646},{44003301,6067,3663},{44003301,5827,3307},{44003301,6589,3843}]};

get_scene_mon_info(44002,1) ->
	#base_sanctum_scene{scene = 44002,montype = 1,mon_num = 1,mon = [{44002101, 3817,2276}]};

get_scene_mon_info(44002,2) ->
	#base_sanctum_scene{scene = 44002,montype = 2,mon_num = 4,mon = [{44002201, 1284,3912},{44002202, 1264,1197},{44002203, 6425,1212},{44002204, 6452,3804}]};

get_scene_mon_info(44002,3) ->
	#base_sanctum_scene{scene = 44002,montype = 3,mon_num = 1,mon = [{44001301,2208,2569},{44001301,2640,2488},{44001301,2673,2134},{44001301,2514,2767},{44001301,2348,2014},{44001301,2429,2278},{44002301,3476,2897},{44002301,4310,2854},{44002301,3892,2902},{44002301,3125,3179},{44002301,4781,3134},{44002301,3654,3258},{44002301,4166,3256},{44003301,4893,2086},{44003301,4904,2589},{44003301,5111,2310},{44003301,5183,1947},{44003301,5333,2766},{44003301,5431,2462},{44003301,5350,2126},{44004301,3068,1623},{44004301,4391,1563},{44004301,3806,1740},{44004301,3458,1578},{44004301,4071,1563},{44004301,3347,1788},{44004301,4214,1769}]};

get_scene_mon_info(44003,1) ->
	#base_sanctum_scene{scene = 44003,montype = 1,mon_num = 1,mon = [{44003101, 3817,2276}]};

get_scene_mon_info(44003,2) ->
	#base_sanctum_scene{scene = 44003,montype = 2,mon_num = 4,mon = [{44003201, 1284,3912},{44003202, 1264,1197},{44003203, 6425,1212},{44003204, 6452,3804}]};

get_scene_mon_info(44003,3) ->
	#base_sanctum_scene{scene = 44003,montype = 3,mon_num = 1,mon = [{44001301,2208,2569},{44001301,2640,2488},{44001301,2673,2134},{44001301,2514,2767},{44001301,2348,2014},{44001301,2429,2278},{44002301,3476,2897},{44002301,4310,2854},{44002301,3892,2902},{44002301,3125,3179},{44002301,4781,3134},{44002301,3654,3258},{44002301,4166,3256},{44003301,4893,2086},{44003301,4904,2589},{44003301,5111,2310},{44003301,5183,1947},{44003301,5333,2766},{44003301,5431,2462},{44003301,5350,2126},{44004301,3068,1623},{44004301,4391,1563},{44004301,3806,1740},{44004301,3458,1578},{44004301,4071,1563},{44004301,3347,1788},{44004301,4214,1769}]};

get_scene_mon_info(44004,1) ->
	#base_sanctum_scene{scene = 44004,montype = 1,mon_num = 1,mon = [{44004101, 3817,2276}]};

get_scene_mon_info(44004,2) ->
	#base_sanctum_scene{scene = 44004,montype = 2,mon_num = 4,mon = [{44004201, 1284,3912},{44004202, 1264,1197},{44004203, 6425,1212},{44004204, 6452,3804}]};

get_scene_mon_info(44004,3) ->
	#base_sanctum_scene{scene = 44004,montype = 3,mon_num = 1,mon = [{44001301,2208,2569},{44001301,2640,2488},{44001301,2673,2134},{44001301,2514,2767},{44001301,2348,2014},{44001301,2429,2278},{44002301,3476,2897},{44002301,4310,2854},{44002301,3892,2902},{44002301,3125,3179},{44002301,4781,3134},{44002301,3654,3258},{44002301,4166,3256},{44003301,4893,2086},{44003301,4904,2589},{44003301,5111,2310},{44003301,5183,1947},{44003301,5333,2766},{44003301,5431,2462},{44003301,5350,2126},{44004301,3068,1623},{44004301,4391,1563},{44004301,3806,1740},{44004301,3458,1578},{44004301,4071,1563},{44004301,3347,1788},{44004301,4214,1769}]};

get_scene_mon_info(44005,1) ->
	#base_sanctum_scene{scene = 44005,montype = 1,mon_num = 1,mon = [{44005101, 3817,2276}]};

get_scene_mon_info(44005,2) ->
	#base_sanctum_scene{scene = 44005,montype = 2,mon_num = 4,mon = [{44005201, 1284,3912},{44005202, 1264,1197},{44005203, 6425,1212},{44005204, 6452,3804}]};

get_scene_mon_info(44005,3) ->
	#base_sanctum_scene{scene = 44005,montype = 3,mon_num = 1,mon = [{44001301,2208,2569},{44001301,2640,2488},{44001301,2673,2134},{44001301,2514,2767},{44001301,2348,2014},{44001301,2429,2278},{44002301,3476,2897},{44002301,4310,2854},{44002301,3892,2902},{44002301,3125,3179},{44002301,4781,3134},{44002301,3654,3258},{44002301,4166,3256},{44003301,4893,2086},{44003301,4904,2589},{44003301,5111,2310},{44003301,5183,1947},{44003301,5333,2766},{44003301,5431,2462},{44003301,5350,2126},{44004301,3068,1623},{44004301,4391,1563},{44004301,3806,1740},{44004301,3458,1578},{44004301,4071,1563},{44004301,3347,1788},{44004301,4214,1769}]};

get_scene_mon_info(_Scene,_Montype) ->
	[].

get_all_scene() ->
[44001,44002,44003,44004,44005].


get_scene_montype(44001) ->
[1,2,3];


get_scene_montype(44002) ->
[1,2,3];


get_scene_montype(44003) ->
[1,2,3];


get_scene_montype(44004) ->
[1,2,3];


get_scene_montype(44005) ->
[1,2,3];

get_scene_montype(_Scene) ->
	[].

get_hurt_reward(_Rank,44001101) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010258,10},{0,56040003,1}];
get_hurt_reward(_Rank,44001101) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010258,7},{0,56040003,1}];
get_hurt_reward(_Rank,44001101) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010258,5},{0,56040003,1}];
get_hurt_reward(_Rank,44001101) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010258,4},{0,56040003,1}];
get_hurt_reward(_Rank,44001101) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010258,3},{0,56040003,1}];
get_hurt_reward(_Rank,44001101) when _Rank >= 6, _Rank =< 999 ->
		[{0,56040003,1}];
get_hurt_reward(_Rank,44001201) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001201) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001201) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001201) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001201) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001201) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001202) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001202) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001202) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001202) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001202) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001202) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001203) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001203) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001203) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001203) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001203) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001203) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001204) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001204) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001204) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001204) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001204) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001204) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001205) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001205) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001205) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001205) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001205) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001205) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001206) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001206) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001206) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001206) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001206) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001206) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001207) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001207) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001207) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001207) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001207) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001207) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44001208) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010257,6},{0,56020003,1}];
get_hurt_reward(_Rank,44001208) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010257,5},{0,56020003,1}];
get_hurt_reward(_Rank,44001208) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010257,4},{0,56020003,1}];
get_hurt_reward(_Rank,44001208) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010257,3},{0,56020003,1}];
get_hurt_reward(_Rank,44001208) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010257,2},{0,56020003,1}];
get_hurt_reward(_Rank,44001208) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020003,1}];
get_hurt_reward(_Rank,44002101) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010253,8},{0,56040004,1}];
get_hurt_reward(_Rank,44002101) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010253,5},{0,56040004,1}];
get_hurt_reward(_Rank,44002101) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010253,4},{0,56040004,1}];
get_hurt_reward(_Rank,44002101) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010253,3},{0,56040004,1}];
get_hurt_reward(_Rank,44002101) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010253,2},{0,56040004,1}];
get_hurt_reward(_Rank,44002101) when _Rank >= 6, _Rank =< 999 ->
		[{0,56040004,1}];
get_hurt_reward(_Rank,44002201) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44002201) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44002201) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44002201) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44002201) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44002201) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44002202) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44002202) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44002202) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44002202) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44002202) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44002202) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44002203) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44002203) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44002203) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44002203) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44002203) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44002203) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44002204) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44002204) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44002204) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44002204) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44002204) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44002204) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44003101) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010253,8},{0,56040004,1}];
get_hurt_reward(_Rank,44003101) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010253,5},{0,56040004,1}];
get_hurt_reward(_Rank,44003101) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010253,4},{0,56040004,1}];
get_hurt_reward(_Rank,44003101) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010253,3},{0,56040004,1}];
get_hurt_reward(_Rank,44003101) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010253,2},{0,56040004,1}];
get_hurt_reward(_Rank,44003101) when _Rank >= 6, _Rank =< 999 ->
		[{0,56040004,1}];
get_hurt_reward(_Rank,44003201) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44003201) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44003201) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44003201) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44003201) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44003201) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44003202) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44003202) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44003202) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44003202) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44003202) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44003202) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44003203) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44003203) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44003203) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44003203) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44003203) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44003203) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44003204) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44003204) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44003204) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44003204) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44003204) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44003204) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44004101) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010253,8},{0,56040004,1}];
get_hurt_reward(_Rank,44004101) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010253,5},{0,56040004,1}];
get_hurt_reward(_Rank,44004101) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010253,4},{0,56040004,1}];
get_hurt_reward(_Rank,44004101) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010253,3},{0,56040004,1}];
get_hurt_reward(_Rank,44004101) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010253,2},{0,56040004,1}];
get_hurt_reward(_Rank,44004101) when _Rank >= 6, _Rank =< 999 ->
		[{0,56040004,1}];
get_hurt_reward(_Rank,44004201) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44004201) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44004201) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44004201) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44004201) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44004201) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44004202) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44004202) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44004202) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44004202) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44004202) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44004202) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44004203) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44004203) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44004203) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44004203) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44004203) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44004203) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44004204) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44004204) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44004204) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44004204) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44004204) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44004204) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44005101) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010253,8},{0,56040004,1}];
get_hurt_reward(_Rank,44005101) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010253,5},{0,56040004,1}];
get_hurt_reward(_Rank,44005101) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010253,4},{0,56040004,1}];
get_hurt_reward(_Rank,44005101) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010253,3},{0,56040004,1}];
get_hurt_reward(_Rank,44005101) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010253,2},{0,56040004,1}];
get_hurt_reward(_Rank,44005101) when _Rank >= 6, _Rank =< 999 ->
		[{0,56040004,1}];
get_hurt_reward(_Rank,44005201) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44005201) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44005201) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44005201) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44005201) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44005201) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44005202) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44005202) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44005202) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44005202) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44005202) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44005202) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44005203) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44005203) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44005203) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44005203) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44005203) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44005203) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,44005204) when _Rank >= 1, _Rank =< 1 ->
		[{0,32010259,5},{0,56020004,1}];
get_hurt_reward(_Rank,44005204) when _Rank >= 2, _Rank =< 2 ->
		[{0,32010259,4},{0,56020004,1}];
get_hurt_reward(_Rank,44005204) when _Rank >= 3, _Rank =< 3 ->
		[{0,32010259,3},{0,56020004,1}];
get_hurt_reward(_Rank,44005204) when _Rank >= 4, _Rank =< 4 ->
		[{0,32010259,2},{0,56020004,1}];
get_hurt_reward(_Rank,44005204) when _Rank >= 5, _Rank =< 5 ->
		[{0,32010259,1},{0,56020004,1}];
get_hurt_reward(_Rank,44005204) when _Rank >= 6, _Rank =< 999 ->
		[{0,56020004,1}];
get_hurt_reward(_Rank,_Boss_id) ->
	[].


get_value(act_open_list) ->
[{day, [2,5]},{time, [{{21,0},{21,25}}]}];


get_value(auto_revive_after_limit) ->
15;


get_value(die_wait_time) ->
[{min_times, 4},{special,[{5,30}]},{extra, 30}];


get_value(enter_scene_player_limit) ->
50;


get_value(high_sence) ->
44001;


get_value(hurt_percent_pick_reward) ->
2;


get_value(limit_enter_time) ->
5;


get_value(notify_before_start) ->
5;


get_value(open_day_limit) ->
42;


get_value(open_lv) ->
470;


get_value(player_die_times) ->
300;


get_value(revive_point_gost) ->
[{2,0,20}];

get_value(_Key) ->
	[].


get_scene_point(44001) ->
[{1172,5048},{5601,6862},{1598,1080},{4965,1766}];


get_scene_point(44002) ->
[{2123,3488},{2073,1676},{5481,1688},{5626,3433}];


get_scene_point(44003) ->
[{2123,3488},{2073,1676},{5481,1688},{5626,3433}];


get_scene_point(44004) ->
[{2123,3488},{2073,1676},{5481,1688},{5626,3433}];


get_scene_point(44005) ->
[{2123,3488},{2073,1676},{5481,1688},{5626,3433}];

get_scene_point(_Scene) ->
	[].


get_scene_type(44001) ->
[1];


get_scene_type(44002) ->
[2];


get_scene_type(44003) ->
[2];


get_scene_type(44004) ->
[2];


get_scene_type(44005) ->
[2];

get_scene_type(_Scene) ->
	[].

