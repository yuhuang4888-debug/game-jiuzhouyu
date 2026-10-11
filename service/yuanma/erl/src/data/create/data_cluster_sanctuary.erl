%%%---------------------------------------
%%% module      : data_cluster_sanctuary
%%% description : 跨服圣域配置
%%%
%%%---------------------------------------
-module(data_cluster_sanctuary).
-compile(export_all).
-include("cluster_sanctuary.hrl").



get_san_type(1) ->
	#base_san_type{type = 1,san_num = [{3,[38003]}],city_num = [{2,[]}],village_num = [{1,[38001,38002]}],open_min = 5,open_max = 8,server_num = 2,wlv = 0};

get_san_type(2) ->
	#base_san_type{type = 2,san_num = [{3,[38008,38009]}],city_num = [{2,[]}],village_num = [{1,[38004,38005,38006,38007]}],open_min = 9,open_max = 17,server_num = 4,wlv = 0};

get_san_type(3) ->
	#base_san_type{type = 3,san_num = [{3,[38022]}],city_num = [{2,[38018,38019,38020,38021]}],village_num = [{1,[38010,38011,38012,38013,38014,38015,38016,38017]}],open_min = 18,open_max = 9999,server_num = 8,wlv = 0};

get_san_type(_Type) ->
	[].

get_all_santype() ->
[1,2,3].


get_wlv_limit(1) ->
0;


get_wlv_limit(2) ->
0;


get_wlv_limit(3) ->
0;

get_wlv_limit(_Type) ->
	[].

get_type_by_openday(_Openday) when _Openday >= 5, _Openday =< 8 ->
		1;
get_type_by_openday(_Openday) when _Openday >= 9, _Openday =< 17 ->
		2;
get_type_by_openday(_Openday) when _Openday >= 18, _Openday =< 9999 ->
		3;
get_type_by_openday(_Openday) ->
	[].

get_mon_type(1,1) ->
	#base_san_mon_type{type = 1,con_type = 1,san_score = 10,score = 150,min_score = 100,medal = [{255,36255012,10}],anger = 10};

get_mon_type(1,2) ->
	#base_san_mon_type{type = 1,con_type = 2,san_score = 10,score = 300,min_score = 100,medal = [{255,36255012,10}],anger = 10};

get_mon_type(1,3) ->
	#base_san_mon_type{type = 1,con_type = 3,san_score = 10,score = 300,min_score = 100,medal = [{255,36255012,20}],anger = 10};

get_mon_type(2,1) ->
	#base_san_mon_type{type = 2,con_type = 1,san_score = 20,score = 300,min_score = 100,medal = [{255,36255012,20}],anger = 10};

get_mon_type(2,2) ->
	#base_san_mon_type{type = 2,con_type = 2,san_score = 20,score = 600,min_score = 100,medal = [{255,36255012,20}],anger = 10};

get_mon_type(2,3) ->
	#base_san_mon_type{type = 2,con_type = 3,san_score = 20,score = 600,min_score = 100,medal = [{255,36255012,30}],anger = 10};

get_mon_type(3,1) ->
	#base_san_mon_type{type = 3,con_type = 1,san_score = 30,score = 1000,min_score = 100,medal = [{255,36255012,50}],anger = 10};

get_mon_type(3,2) ->
	#base_san_mon_type{type = 3,con_type = 2,san_score = 30,score = 2000,min_score = 100,medal = [{255,36255012,50}],anger = 10};

get_mon_type(3,3) ->
	#base_san_mon_type{type = 3,con_type = 3,san_score = 30,score = 2000,min_score = 100,medal = [{255,36255012,100}],anger = 10};

get_mon_type(4,1) ->
	#base_san_mon_type{type = 4,con_type = 1,san_score = 0,score = 75,min_score = 50,medal = [{255,36255012,5}],anger = 20};

get_mon_type(4,2) ->
	#base_san_mon_type{type = 4,con_type = 2,san_score = 0,score = 150,min_score = 50,medal = [{255,36255012,5}],anger = 20};

get_mon_type(4,3) ->
	#base_san_mon_type{type = 4,con_type = 3,san_score = 0,score = 150,min_score = 50,medal = [{255,36255012,10}],anger = 20};

get_mon_type(5,1) ->
	#base_san_mon_type{type = 5,con_type = 1,san_score = 0,score = 150,min_score = 50,medal = [{255,36255012,10}],anger = 20};

get_mon_type(5,2) ->
	#base_san_mon_type{type = 5,con_type = 2,san_score = 0,score = 300,min_score = 50,medal = [{255,36255012,10}],anger = 20};

get_mon_type(5,3) ->
	#base_san_mon_type{type = 5,con_type = 3,san_score = 0,score = 300,min_score = 50,medal = [{255,36255012,15}],anger = 20};

get_mon_type(6,1) ->
	#base_san_mon_type{type = 6,con_type = 1,san_score = 0,score = 500,min_score = 50,medal = [{255,36255012,25}],anger = 20};

get_mon_type(6,2) ->
	#base_san_mon_type{type = 6,con_type = 2,san_score = 0,score = 1000,min_score = 50,medal = [{255,36255012,25}],anger = 20};

get_mon_type(6,3) ->
	#base_san_mon_type{type = 6,con_type = 3,san_score = 0,score = 1000,min_score = 50,medal = [{255,36255012,50}],anger = 20};

get_mon_type(_Type,_Contype) ->
	[].

get_mon_cfg(380001) ->
	#base_san_mon{mon_id = 380001,type = 1,scene = 38001,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380002) ->
	#base_san_mon{mon_id = 380002,type = 1,scene = 38001,x = 998,y = 4377,reborn = []};

get_mon_cfg(380003) ->
	#base_san_mon{mon_id = 380003,type = 1,scene = 38001,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380004) ->
	#base_san_mon{mon_id = 380004,type = 1,scene = 38001,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380005) ->
	#base_san_mon{mon_id = 380005,type = 4,scene = 38001,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380006) ->
	#base_san_mon{mon_id = 380006,type = 4,scene = 38001,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380007) ->
	#base_san_mon{mon_id = 380007,type = 2,scene = 38001,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380008) ->
	#base_san_mon{mon_id = 380008,type = 2,scene = 38001,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380009) ->
	#base_san_mon{mon_id = 380009,type = 2,scene = 38001,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380010) ->
	#base_san_mon{mon_id = 380010,type = 3,scene = 38001,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380011) ->
	#base_san_mon{mon_id = 380011,type = 1,scene = 38002,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380012) ->
	#base_san_mon{mon_id = 380012,type = 1,scene = 38002,x = 998,y = 4377,reborn = []};

get_mon_cfg(380013) ->
	#base_san_mon{mon_id = 380013,type = 1,scene = 38002,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380014) ->
	#base_san_mon{mon_id = 380014,type = 1,scene = 38002,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380015) ->
	#base_san_mon{mon_id = 380015,type = 4,scene = 38002,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380016) ->
	#base_san_mon{mon_id = 380016,type = 4,scene = 38002,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380017) ->
	#base_san_mon{mon_id = 380017,type = 2,scene = 38002,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380018) ->
	#base_san_mon{mon_id = 380018,type = 2,scene = 38002,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380019) ->
	#base_san_mon{mon_id = 380019,type = 2,scene = 38002,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380020) ->
	#base_san_mon{mon_id = 380020,type = 3,scene = 38002,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380021) ->
	#base_san_mon{mon_id = 380021,type = 1,scene = 38003,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380022) ->
	#base_san_mon{mon_id = 380022,type = 1,scene = 38003,x = 998,y = 4377,reborn = []};

get_mon_cfg(380023) ->
	#base_san_mon{mon_id = 380023,type = 1,scene = 38003,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380024) ->
	#base_san_mon{mon_id = 380024,type = 1,scene = 38003,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380025) ->
	#base_san_mon{mon_id = 380025,type = 1,scene = 38003,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380026) ->
	#base_san_mon{mon_id = 380026,type = 1,scene = 38003,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380027) ->
	#base_san_mon{mon_id = 380027,type = 2,scene = 38003,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380028) ->
	#base_san_mon{mon_id = 380028,type = 2,scene = 38003,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380029) ->
	#base_san_mon{mon_id = 380029,type = 2,scene = 38003,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380030) ->
	#base_san_mon{mon_id = 380030,type = 3,scene = 38003,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380031) ->
	#base_san_mon{mon_id = 380031,type = 1,scene = 38004,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380032) ->
	#base_san_mon{mon_id = 380032,type = 1,scene = 38004,x = 998,y = 4377,reborn = []};

get_mon_cfg(380033) ->
	#base_san_mon{mon_id = 380033,type = 1,scene = 38004,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380034) ->
	#base_san_mon{mon_id = 380034,type = 1,scene = 38004,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380035) ->
	#base_san_mon{mon_id = 380035,type = 4,scene = 38004,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380036) ->
	#base_san_mon{mon_id = 380036,type = 4,scene = 38004,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380037) ->
	#base_san_mon{mon_id = 380037,type = 2,scene = 38004,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380038) ->
	#base_san_mon{mon_id = 380038,type = 2,scene = 38004,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380039) ->
	#base_san_mon{mon_id = 380039,type = 2,scene = 38004,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380040) ->
	#base_san_mon{mon_id = 380040,type = 3,scene = 38004,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380041) ->
	#base_san_mon{mon_id = 380041,type = 1,scene = 38005,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380042) ->
	#base_san_mon{mon_id = 380042,type = 1,scene = 38005,x = 998,y = 4377,reborn = []};

get_mon_cfg(380043) ->
	#base_san_mon{mon_id = 380043,type = 1,scene = 38005,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380044) ->
	#base_san_mon{mon_id = 380044,type = 1,scene = 38005,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380045) ->
	#base_san_mon{mon_id = 380045,type = 4,scene = 38005,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380046) ->
	#base_san_mon{mon_id = 380046,type = 4,scene = 38005,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380047) ->
	#base_san_mon{mon_id = 380047,type = 2,scene = 38005,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380048) ->
	#base_san_mon{mon_id = 380048,type = 2,scene = 38005,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380049) ->
	#base_san_mon{mon_id = 380049,type = 2,scene = 38005,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380050) ->
	#base_san_mon{mon_id = 380050,type = 3,scene = 38005,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380051) ->
	#base_san_mon{mon_id = 380051,type = 1,scene = 38006,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380052) ->
	#base_san_mon{mon_id = 380052,type = 1,scene = 38006,x = 998,y = 4377,reborn = []};

get_mon_cfg(380053) ->
	#base_san_mon{mon_id = 380053,type = 1,scene = 38006,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380054) ->
	#base_san_mon{mon_id = 380054,type = 1,scene = 38006,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380055) ->
	#base_san_mon{mon_id = 380055,type = 4,scene = 38006,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380056) ->
	#base_san_mon{mon_id = 380056,type = 4,scene = 38006,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380057) ->
	#base_san_mon{mon_id = 380057,type = 2,scene = 38006,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380058) ->
	#base_san_mon{mon_id = 380058,type = 2,scene = 38006,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380059) ->
	#base_san_mon{mon_id = 380059,type = 2,scene = 38006,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380060) ->
	#base_san_mon{mon_id = 380060,type = 3,scene = 38006,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380061) ->
	#base_san_mon{mon_id = 380061,type = 1,scene = 38007,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380062) ->
	#base_san_mon{mon_id = 380062,type = 1,scene = 38007,x = 998,y = 4377,reborn = []};

get_mon_cfg(380063) ->
	#base_san_mon{mon_id = 380063,type = 1,scene = 38007,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380064) ->
	#base_san_mon{mon_id = 380064,type = 1,scene = 38007,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380065) ->
	#base_san_mon{mon_id = 380065,type = 4,scene = 38007,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380066) ->
	#base_san_mon{mon_id = 380066,type = 4,scene = 38007,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380067) ->
	#base_san_mon{mon_id = 380067,type = 2,scene = 38007,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380068) ->
	#base_san_mon{mon_id = 380068,type = 2,scene = 38007,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380069) ->
	#base_san_mon{mon_id = 380069,type = 2,scene = 38007,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380070) ->
	#base_san_mon{mon_id = 380070,type = 3,scene = 38007,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380071) ->
	#base_san_mon{mon_id = 380071,type = 1,scene = 38008,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380072) ->
	#base_san_mon{mon_id = 380072,type = 1,scene = 38008,x = 998,y = 4377,reborn = []};

get_mon_cfg(380073) ->
	#base_san_mon{mon_id = 380073,type = 1,scene = 38008,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380074) ->
	#base_san_mon{mon_id = 380074,type = 1,scene = 38008,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380075) ->
	#base_san_mon{mon_id = 380075,type = 1,scene = 38008,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380076) ->
	#base_san_mon{mon_id = 380076,type = 1,scene = 38008,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380077) ->
	#base_san_mon{mon_id = 380077,type = 2,scene = 38008,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380078) ->
	#base_san_mon{mon_id = 380078,type = 2,scene = 38008,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380079) ->
	#base_san_mon{mon_id = 380079,type = 2,scene = 38008,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380080) ->
	#base_san_mon{mon_id = 380080,type = 3,scene = 38008,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380081) ->
	#base_san_mon{mon_id = 380081,type = 1,scene = 38009,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380082) ->
	#base_san_mon{mon_id = 380082,type = 1,scene = 38009,x = 998,y = 4377,reborn = []};

get_mon_cfg(380083) ->
	#base_san_mon{mon_id = 380083,type = 1,scene = 38009,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380084) ->
	#base_san_mon{mon_id = 380084,type = 1,scene = 38009,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380085) ->
	#base_san_mon{mon_id = 380085,type = 1,scene = 38009,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380086) ->
	#base_san_mon{mon_id = 380086,type = 1,scene = 38009,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380087) ->
	#base_san_mon{mon_id = 380087,type = 2,scene = 38009,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380088) ->
	#base_san_mon{mon_id = 380088,type = 2,scene = 38009,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380089) ->
	#base_san_mon{mon_id = 380089,type = 2,scene = 38009,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380090) ->
	#base_san_mon{mon_id = 380090,type = 3,scene = 38009,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380091) ->
	#base_san_mon{mon_id = 380091,type = 1,scene = 38010,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380092) ->
	#base_san_mon{mon_id = 380092,type = 1,scene = 38010,x = 998,y = 4377,reborn = []};

get_mon_cfg(380093) ->
	#base_san_mon{mon_id = 380093,type = 1,scene = 38010,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380094) ->
	#base_san_mon{mon_id = 380094,type = 1,scene = 38010,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380095) ->
	#base_san_mon{mon_id = 380095,type = 4,scene = 38010,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380096) ->
	#base_san_mon{mon_id = 380096,type = 4,scene = 38010,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380097) ->
	#base_san_mon{mon_id = 380097,type = 2,scene = 38010,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380098) ->
	#base_san_mon{mon_id = 380098,type = 2,scene = 38010,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380099) ->
	#base_san_mon{mon_id = 380099,type = 2,scene = 38010,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380100) ->
	#base_san_mon{mon_id = 380100,type = 3,scene = 38010,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380101) ->
	#base_san_mon{mon_id = 380101,type = 1,scene = 38011,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380102) ->
	#base_san_mon{mon_id = 380102,type = 1,scene = 38011,x = 998,y = 4377,reborn = []};

get_mon_cfg(380103) ->
	#base_san_mon{mon_id = 380103,type = 1,scene = 38011,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380104) ->
	#base_san_mon{mon_id = 380104,type = 1,scene = 38011,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380105) ->
	#base_san_mon{mon_id = 380105,type = 4,scene = 38011,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380106) ->
	#base_san_mon{mon_id = 380106,type = 4,scene = 38011,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380107) ->
	#base_san_mon{mon_id = 380107,type = 2,scene = 38011,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380108) ->
	#base_san_mon{mon_id = 380108,type = 2,scene = 38011,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380109) ->
	#base_san_mon{mon_id = 380109,type = 2,scene = 38011,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380110) ->
	#base_san_mon{mon_id = 380110,type = 3,scene = 38011,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380111) ->
	#base_san_mon{mon_id = 380111,type = 1,scene = 38012,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380112) ->
	#base_san_mon{mon_id = 380112,type = 1,scene = 38012,x = 998,y = 4377,reborn = []};

get_mon_cfg(380113) ->
	#base_san_mon{mon_id = 380113,type = 1,scene = 38012,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380114) ->
	#base_san_mon{mon_id = 380114,type = 1,scene = 38012,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380115) ->
	#base_san_mon{mon_id = 380115,type = 4,scene = 38012,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380116) ->
	#base_san_mon{mon_id = 380116,type = 4,scene = 38012,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380117) ->
	#base_san_mon{mon_id = 380117,type = 2,scene = 38012,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380118) ->
	#base_san_mon{mon_id = 380118,type = 2,scene = 38012,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380119) ->
	#base_san_mon{mon_id = 380119,type = 2,scene = 38012,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380120) ->
	#base_san_mon{mon_id = 380120,type = 3,scene = 38012,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380121) ->
	#base_san_mon{mon_id = 380121,type = 1,scene = 38013,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380122) ->
	#base_san_mon{mon_id = 380122,type = 1,scene = 38013,x = 998,y = 4377,reborn = []};

get_mon_cfg(380123) ->
	#base_san_mon{mon_id = 380123,type = 1,scene = 38013,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380124) ->
	#base_san_mon{mon_id = 380124,type = 1,scene = 38013,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380125) ->
	#base_san_mon{mon_id = 380125,type = 4,scene = 38013,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380126) ->
	#base_san_mon{mon_id = 380126,type = 4,scene = 38013,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380127) ->
	#base_san_mon{mon_id = 380127,type = 2,scene = 38013,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380128) ->
	#base_san_mon{mon_id = 380128,type = 2,scene = 38013,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380129) ->
	#base_san_mon{mon_id = 380129,type = 2,scene = 38013,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380130) ->
	#base_san_mon{mon_id = 380130,type = 3,scene = 38013,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380131) ->
	#base_san_mon{mon_id = 380131,type = 1,scene = 38014,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380132) ->
	#base_san_mon{mon_id = 380132,type = 1,scene = 38014,x = 998,y = 4377,reborn = []};

get_mon_cfg(380133) ->
	#base_san_mon{mon_id = 380133,type = 1,scene = 38014,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380134) ->
	#base_san_mon{mon_id = 380134,type = 1,scene = 38014,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380135) ->
	#base_san_mon{mon_id = 380135,type = 4,scene = 38014,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380136) ->
	#base_san_mon{mon_id = 380136,type = 4,scene = 38014,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380137) ->
	#base_san_mon{mon_id = 380137,type = 2,scene = 38014,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380138) ->
	#base_san_mon{mon_id = 380138,type = 2,scene = 38014,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380139) ->
	#base_san_mon{mon_id = 380139,type = 2,scene = 38014,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380140) ->
	#base_san_mon{mon_id = 380140,type = 3,scene = 38014,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380141) ->
	#base_san_mon{mon_id = 380141,type = 1,scene = 38015,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380142) ->
	#base_san_mon{mon_id = 380142,type = 1,scene = 38015,x = 998,y = 4377,reborn = []};

get_mon_cfg(380143) ->
	#base_san_mon{mon_id = 380143,type = 1,scene = 38015,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380144) ->
	#base_san_mon{mon_id = 380144,type = 1,scene = 38015,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380145) ->
	#base_san_mon{mon_id = 380145,type = 4,scene = 38015,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380146) ->
	#base_san_mon{mon_id = 380146,type = 4,scene = 38015,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380147) ->
	#base_san_mon{mon_id = 380147,type = 2,scene = 38015,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380148) ->
	#base_san_mon{mon_id = 380148,type = 2,scene = 38015,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380149) ->
	#base_san_mon{mon_id = 380149,type = 2,scene = 38015,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380150) ->
	#base_san_mon{mon_id = 380150,type = 3,scene = 38015,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380151) ->
	#base_san_mon{mon_id = 380151,type = 1,scene = 38016,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380152) ->
	#base_san_mon{mon_id = 380152,type = 1,scene = 38016,x = 998,y = 4377,reborn = []};

get_mon_cfg(380153) ->
	#base_san_mon{mon_id = 380153,type = 1,scene = 38016,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380154) ->
	#base_san_mon{mon_id = 380154,type = 1,scene = 38016,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380155) ->
	#base_san_mon{mon_id = 380155,type = 4,scene = 38016,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380156) ->
	#base_san_mon{mon_id = 380156,type = 4,scene = 38016,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380157) ->
	#base_san_mon{mon_id = 380157,type = 2,scene = 38016,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380158) ->
	#base_san_mon{mon_id = 380158,type = 2,scene = 38016,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380159) ->
	#base_san_mon{mon_id = 380159,type = 2,scene = 38016,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380160) ->
	#base_san_mon{mon_id = 380160,type = 3,scene = 38016,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380161) ->
	#base_san_mon{mon_id = 380161,type = 1,scene = 38017,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380162) ->
	#base_san_mon{mon_id = 380162,type = 1,scene = 38017,x = 998,y = 4377,reborn = []};

get_mon_cfg(380163) ->
	#base_san_mon{mon_id = 380163,type = 1,scene = 38017,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380164) ->
	#base_san_mon{mon_id = 380164,type = 1,scene = 38017,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380165) ->
	#base_san_mon{mon_id = 380165,type = 4,scene = 38017,x = 1808,y = 1722,reborn = 900};

get_mon_cfg(380166) ->
	#base_san_mon{mon_id = 380166,type = 4,scene = 38017,x = 5168,y = 4632,reborn = 900};

get_mon_cfg(380167) ->
	#base_san_mon{mon_id = 380167,type = 2,scene = 38017,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380168) ->
	#base_san_mon{mon_id = 380168,type = 2,scene = 38017,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380169) ->
	#base_san_mon{mon_id = 380169,type = 2,scene = 38017,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380170) ->
	#base_san_mon{mon_id = 380170,type = 3,scene = 38017,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380171) ->
	#base_san_mon{mon_id = 380171,type = 1,scene = 38018,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380172) ->
	#base_san_mon{mon_id = 380172,type = 1,scene = 38018,x = 998,y = 4377,reborn = []};

get_mon_cfg(380173) ->
	#base_san_mon{mon_id = 380173,type = 1,scene = 38018,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380174) ->
	#base_san_mon{mon_id = 380174,type = 1,scene = 38018,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380175) ->
	#base_san_mon{mon_id = 380175,type = 1,scene = 38018,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380176) ->
	#base_san_mon{mon_id = 380176,type = 1,scene = 38018,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380177) ->
	#base_san_mon{mon_id = 380177,type = 2,scene = 38018,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380178) ->
	#base_san_mon{mon_id = 380178,type = 2,scene = 38018,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380179) ->
	#base_san_mon{mon_id = 380179,type = 2,scene = 38018,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380180) ->
	#base_san_mon{mon_id = 380180,type = 3,scene = 38018,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380181) ->
	#base_san_mon{mon_id = 380181,type = 1,scene = 38019,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380182) ->
	#base_san_mon{mon_id = 380182,type = 1,scene = 38019,x = 998,y = 4377,reborn = []};

get_mon_cfg(380183) ->
	#base_san_mon{mon_id = 380183,type = 1,scene = 38019,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380184) ->
	#base_san_mon{mon_id = 380184,type = 1,scene = 38019,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380185) ->
	#base_san_mon{mon_id = 380185,type = 1,scene = 38019,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380186) ->
	#base_san_mon{mon_id = 380186,type = 1,scene = 38019,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380187) ->
	#base_san_mon{mon_id = 380187,type = 2,scene = 38019,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380188) ->
	#base_san_mon{mon_id = 380188,type = 2,scene = 38019,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380189) ->
	#base_san_mon{mon_id = 380189,type = 2,scene = 38019,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380190) ->
	#base_san_mon{mon_id = 380190,type = 3,scene = 38019,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380191) ->
	#base_san_mon{mon_id = 380191,type = 1,scene = 38020,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380192) ->
	#base_san_mon{mon_id = 380192,type = 1,scene = 38020,x = 998,y = 4377,reborn = []};

get_mon_cfg(380193) ->
	#base_san_mon{mon_id = 380193,type = 1,scene = 38020,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380194) ->
	#base_san_mon{mon_id = 380194,type = 1,scene = 38020,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380195) ->
	#base_san_mon{mon_id = 380195,type = 1,scene = 38020,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380196) ->
	#base_san_mon{mon_id = 380196,type = 1,scene = 38020,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380197) ->
	#base_san_mon{mon_id = 380197,type = 2,scene = 38020,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380198) ->
	#base_san_mon{mon_id = 380198,type = 2,scene = 38020,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380199) ->
	#base_san_mon{mon_id = 380199,type = 2,scene = 38020,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380200) ->
	#base_san_mon{mon_id = 380200,type = 3,scene = 38020,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380201) ->
	#base_san_mon{mon_id = 380201,type = 1,scene = 38021,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380202) ->
	#base_san_mon{mon_id = 380202,type = 1,scene = 38021,x = 998,y = 4377,reborn = []};

get_mon_cfg(380203) ->
	#base_san_mon{mon_id = 380203,type = 1,scene = 38021,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380204) ->
	#base_san_mon{mon_id = 380204,type = 1,scene = 38021,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380205) ->
	#base_san_mon{mon_id = 380205,type = 1,scene = 38021,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380206) ->
	#base_san_mon{mon_id = 380206,type = 1,scene = 38021,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380207) ->
	#base_san_mon{mon_id = 380207,type = 2,scene = 38021,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380208) ->
	#base_san_mon{mon_id = 380208,type = 2,scene = 38021,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380209) ->
	#base_san_mon{mon_id = 380209,type = 2,scene = 38021,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380210) ->
	#base_san_mon{mon_id = 380210,type = 3,scene = 38021,x = 7140,y = 2510,reborn = []};

get_mon_cfg(380211) ->
	#base_san_mon{mon_id = 380211,type = 1,scene = 38022,x = 8820,y = 6620,reborn = []};

get_mon_cfg(380212) ->
	#base_san_mon{mon_id = 380212,type = 1,scene = 38022,x = 998,y = 4377,reborn = []};

get_mon_cfg(380213) ->
	#base_san_mon{mon_id = 380213,type = 1,scene = 38022,x = 4800,y = 6860,reborn = []};

get_mon_cfg(380214) ->
	#base_san_mon{mon_id = 380214,type = 1,scene = 38022,x = 2865,y = 5846,reborn = []};

get_mon_cfg(380215) ->
	#base_san_mon{mon_id = 380215,type = 1,scene = 38022,x = 1808,y = 1722,reborn = []};

get_mon_cfg(380216) ->
	#base_san_mon{mon_id = 380216,type = 1,scene = 38022,x = 5168,y = 4632,reborn = []};

get_mon_cfg(380217) ->
	#base_san_mon{mon_id = 380217,type = 2,scene = 38022,x = 8550,y = 4392,reborn = []};

get_mon_cfg(380218) ->
	#base_san_mon{mon_id = 380218,type = 2,scene = 38022,x = 8910,y = 1160,reborn = []};

get_mon_cfg(380219) ->
	#base_san_mon{mon_id = 380219,type = 2,scene = 38022,x = 4995,y = 1392,reborn = []};

get_mon_cfg(380220) ->
	#base_san_mon{mon_id = 380220,type = 3,scene = 38022,x = 7140,y = 2510,reborn = []};

get_mon_cfg(_Monid) ->
	[].


get_mon_by_scene(38001) ->
[380001,380002,380003,380004,380005,380006,380007,380008,380009,380010];


get_mon_by_scene(38002) ->
[380011,380012,380013,380014,380015,380016,380017,380018,380019,380020];


get_mon_by_scene(38003) ->
[380021,380022,380023,380024,380025,380026,380027,380028,380029,380030];


get_mon_by_scene(38004) ->
[380031,380032,380033,380034,380035,380036,380037,380038,380039,380040];


get_mon_by_scene(38005) ->
[380041,380042,380043,380044,380045,380046,380047,380048,380049,380050];


get_mon_by_scene(38006) ->
[380051,380052,380053,380054,380055,380056,380057,380058,380059,380060];


get_mon_by_scene(38007) ->
[380061,380062,380063,380064,380065,380066,380067,380068,380069,380070];


get_mon_by_scene(38008) ->
[380071,380072,380073,380074,380075,380076,380077,380078,380079,380080];


get_mon_by_scene(38009) ->
[380081,380082,380083,380084,380085,380086,380087,380088,380089,380090];


get_mon_by_scene(38010) ->
[380091,380092,380093,380094,380095,380096,380097,380098,380099,380100];


get_mon_by_scene(38011) ->
[380101,380102,380103,380104,380105,380106,380107,380108,380109,380110];


get_mon_by_scene(38012) ->
[380111,380112,380113,380114,380115,380116,380117,380118,380119,380120];


get_mon_by_scene(38013) ->
[380121,380122,380123,380124,380125,380126,380127,380128,380129,380130];


get_mon_by_scene(38014) ->
[380131,380132,380133,380134,380135,380136,380137,380138,380139,380140];


get_mon_by_scene(38015) ->
[380141,380142,380143,380144,380145,380146,380147,380148,380149,380150];


get_mon_by_scene(38016) ->
[380151,380152,380153,380154,380155,380156,380157,380158,380159,380160];


get_mon_by_scene(38017) ->
[380161,380162,380163,380164,380165,380166,380167,380168,380169,380170];


get_mon_by_scene(38018) ->
[380171,380172,380173,380174,380175,380176,380177,380178,380179,380180];


get_mon_by_scene(38019) ->
[380181,380182,380183,380184,380185,380186,380187,380188,380189,380190];


get_mon_by_scene(38020) ->
[380191,380192,380193,380194,380195,380196,380197,380198,380199,380200];


get_mon_by_scene(38021) ->
[380201,380202,380203,380204,380205,380206,380207,380208,380209,380210];


get_mon_by_scene(38022) ->
[380211,380212,380213,380214,380215,380216,380217,380218,380219,380220];

get_mon_by_scene(_Scene) ->
	[].

get_construction_info(1) ->
	#base_san_cons{type = 1,name = <<"境门"/utf8>>,scene = 1010,reward = [{0, 35010008, 1}]};

get_construction_info(2) ->
	#base_san_cons{type = 2,name = <<"幽巢	"/utf8>>,scene = 1011,reward = [{0, 35010008, 1}]};

get_construction_info(3) ->
	#base_san_cons{type = 3,name = <<"圣域"/utf8>>,scene = 1012,reward = [{0, 35010008, 1}]};

get_construction_info(_Type) ->
	[].


get_con_type(1010) ->
[1];


get_con_type(1011) ->
[2];


get_con_type(1012) ->
[3];

get_con_type(_Scene) ->
	[].

get_reward_world_lv(_Worldlv,_Type) when _Worldlv >= 0, _Worldlv =< 9999, _Type == 1 ->
		[{0, 35010008, 1}];
get_reward_world_lv(_Worldlv,_Type) when _Worldlv >= 0, _Worldlv =< 9999, _Type == 2 ->
		[{0, 35010008, 1}];
get_reward_world_lv(_Worldlv,_Type) when _Worldlv >= 0, _Worldlv =< 9999, _Type == 3 ->
		[{0, 35010008, 1}];
get_reward_world_lv(_Worldlv,_Type) ->
	[].

get_score_cfg(2500) ->
	#base_san_score{id = 1,score = 2500,reward = [{0,35010009,1}]};

get_score_cfg(4500) ->
	#base_san_score{id = 2,score = 4500,reward = [{0,35010010,1}]};

get_score_cfg(7500) ->
	#base_san_score{id = 3,score = 7500,reward = [{0,35010011,1}]};

get_score_cfg(10000) ->
	#base_san_score{id = 4,score = 10000,reward = [{0,35010012,1}]};

get_score_cfg(11500) ->
	#base_san_score{id = 5,score = 11500,reward = [{0,35010009,1}]};

get_score_cfg(13000) ->
	#base_san_score{id = 6,score = 13000,reward = [{0,35010010,1}]};

get_score_cfg(14500) ->
	#base_san_score{id = 7,score = 14500,reward = [{0,35010011,1}]};

get_score_cfg(16000) ->
	#base_san_score{id = 8,score = 16000,reward = [{0,35010012,1}]};

get_score_cfg(_Score) ->
	[].

get_all_score_cfg() ->
[2500,4500,7500,10000,11500,13000,14500,16000].


get_score_by_id(1) ->
[2500];


get_score_by_id(2) ->
[4500];


get_score_by_id(3) ->
[7500];


get_score_by_id(4) ->
[10000];


get_score_by_id(5) ->
[11500];


get_score_by_id(6) ->
[13000];


get_score_by_id(7) ->
[14500];


get_score_by_id(8) ->
[16000];

get_score_by_id(_Id) ->
	[].


get_id_by_score(2500) ->
[1];


get_id_by_score(4500) ->
[2];


get_id_by_score(7500) ->
[3];


get_id_by_score(10000) ->
[4];


get_id_by_score(11500) ->
[5];


get_id_by_score(13000) ->
[6];


get_id_by_score(14500) ->
[7];


get_id_by_score(16000) ->
[8];

get_id_by_score(_Score) ->
	[].

get_shop_cfg(1) ->
	#base_san_shop{id = 1,open_day = 5,limit = 2,cost = [{0,34,10}],reward = [{0,34,10}]};

get_shop_cfg(_Id) ->
	[].

get_shop_id(_Openday) when _Openday >= 5 ->
		1;
get_shop_id(_Openday) ->
	[].


get_san_value(anger_limit) ->
240;


get_san_value(auction_begin_time) ->
30;


get_san_value(auction_extra) ->
[{5000,1,[{300, 284115},{50, 284117},{50,284119}]}];


get_san_value(auction_kill_player_add) ->
250;


get_san_value(auction_point_limit) ->
[{1,999,90}];


get_san_value(auction_point_update_time) ->
60;


get_san_value(auction_produce_limit_time) ->
1800;


get_san_value(auction_worth_ratio) ->
20;


get_san_value(auto_revive_after_limit) ->
15;


get_san_value(clear_role_after_scene_bl) ->
30;


get_san_value(clear_role_anger_time) ->
[{16,0}];


get_san_value(clear_role_score) ->
[];


get_san_value(clear_user_act_end) ->
30;


get_san_value(die_wait_time) ->
[{min_times, 4},{special,[{5,30}]},{extra, 30}];


get_san_value(drop_reward_hurt_limit) ->
30000;


get_san_value(kill_log_num) ->
20;


get_san_value(kill_player_reward_and_anger) ->
{[{255,36255012,0}], 0};


get_san_value(min_score_get_hurt_limit) ->
2;


get_san_value(open_lv) ->
200;


get_san_value(open_time) ->
[{open,{9,0}},{continue, {17,0}}];


get_san_value(player_die_times) ->
300;


get_san_value(random_time) ->
14;


get_san_value(reborn_time) ->
[{1,00},{9,00},{12,30},{16,00},{19,30},{22,30}];


get_san_value(revive_cost) ->
[{2,0,20}];


get_san_value(revive_point_gost) ->
15;


get_san_value(san_type1_begin_point) ->
[1,2];


get_san_value(san_type2_begin_point) ->
[3,4,5,6];


get_san_value(san_type3_begin_point) ->
[7,8,9,10,11,12,13,14];


get_san_value(san_type4_begin_point) ->
[15,16,17,18,19,20,21,22];


get_san_value(tip_notify_user_act_end) ->
5;


get_san_value(unlock_score) ->
10000;


get_san_value(unlock_stage_reward) ->
[{1,0,300}];


get_san_value(world_lv_list) ->
[{1,270},{271,320},{321,370},{371,9999},{1,370},{371,420},{421,9999},{1,420},{421,470},{471,520},{521,570},{571,620},{621,670},{671,9999}];

get_san_value(_Key) ->
	[].

get_all_scene_type() ->
[1010,1011,1012].


get_scene_ids(1010) ->
[38001,38002,38004,38005,38006,38007,38010,38011,38012,38013,38014,38015,38016,38017];


get_scene_ids(1011) ->
[38018,38019,38020,38021];


get_scene_ids(1012) ->
[38003,38008,38009,38022];

get_scene_ids(_Id) ->
	[].


get_can_enter_scenes(1) ->
[38001];


get_can_enter_scenes(2) ->
[38002];


get_can_enter_scenes(3) ->
[38004];


get_can_enter_scenes(4) ->
[38005];


get_can_enter_scenes(5) ->
[38007];


get_can_enter_scenes(6) ->
[38006];


get_can_enter_scenes(7) ->
[38010];


get_can_enter_scenes(8) ->
[38011];


get_can_enter_scenes(9) ->
[38012];


get_can_enter_scenes(10) ->
[38013];


get_can_enter_scenes(11) ->
[38014];


get_can_enter_scenes(12) ->
[38015];


get_can_enter_scenes(13) ->
[38016];


get_can_enter_scenes(14) ->
[38017];


get_can_enter_scenes(15) ->
[38023];


get_can_enter_scenes(16) ->
[38024];


get_can_enter_scenes(17) ->
[38025];


get_can_enter_scenes(18) ->
[38026];


get_can_enter_scenes(19) ->
[38027];


get_can_enter_scenes(20) ->
[38028];


get_can_enter_scenes(21) ->
[38029];


get_can_enter_scenes(22) ->
[38030];


get_can_enter_scenes(38001) ->
[38003];


get_can_enter_scenes(38002) ->
[38003];


get_can_enter_scenes(38003) ->
[];


get_can_enter_scenes(38004) ->
[38008];


get_can_enter_scenes(38005) ->
[38008];


get_can_enter_scenes(38006) ->
[38009];


get_can_enter_scenes(38007) ->
[38009];


get_can_enter_scenes(38008) ->
[38009];


get_can_enter_scenes(38009) ->
[38008];


get_can_enter_scenes(38010) ->
[38018];


get_can_enter_scenes(38011) ->
[38018];


get_can_enter_scenes(38012) ->
[38019];


get_can_enter_scenes(38013) ->
[38019];


get_can_enter_scenes(38014) ->
[38020];


get_can_enter_scenes(38015) ->
[38020];


get_can_enter_scenes(38016) ->
[38021];


get_can_enter_scenes(38017) ->
[38021];


get_can_enter_scenes(38018) ->
[38022];


get_can_enter_scenes(38019) ->
[38022];


get_can_enter_scenes(38020) ->
[38022];


get_can_enter_scenes(38021) ->
[38022];


get_can_enter_scenes(38022) ->
[];


get_can_enter_scenes(38023) ->
[38031];


get_can_enter_scenes(38024) ->
[38031];


get_can_enter_scenes(38025) ->
[38032];


get_can_enter_scenes(38026) ->
[38032];


get_can_enter_scenes(38027) ->
[38033];


get_can_enter_scenes(38028) ->
[38033];


get_can_enter_scenes(38029) ->
[38034];


get_can_enter_scenes(38030) ->
[38034];


get_can_enter_scenes(38031) ->
[38035];


get_can_enter_scenes(38032) ->
[38035];


get_can_enter_scenes(38033) ->
[38035];


get_can_enter_scenes(38034) ->
[38035];


get_can_enter_scenes(38035) ->
[];

get_can_enter_scenes(_Sceneid) ->
	[].

get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011407,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6007407,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015052,0},{0,101025052,0},{0,101045052,0},{0,101065052,0},{0,101085052,0},{0,101105052,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015052,0},{0,102025052,0},{0,102045052,0},{0,102065052,0},{0,102085052,0},{0,102105052,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 270 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015062,0},{0,101025062,0},{0,101045062,0},{0,101065062,0},{0,101085062,0},{0,101105062,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015062,0},{0,102025062,0},{0,102045062,0},{0,102065062,0},{0,102085062,0},{0,102105062,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 271, _WorldLv =< 320 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 321, _WorldLv =< 370 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011408,0},{0,6001407,0},{0,6002407,0},{0,6003407,0},{0,6004407,0},{0,6006407,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 9999 ->
		[{1,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011408,0},{0,6001408,0},{0,6002408,0},{0,6003408,0},{0,6004408,0},{0,6007408,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011409,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6007409,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,101015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{2,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,102015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]},{3,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,103015072,0},{0,101025072,0},{0,101045072,0},{0,101065072,0},{0,101085072,0},{0,101105072,0}]},{4,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,104015072,0},{0,102025072,0},{0,102045072,0},{0,102065072,0},{0,102085072,0},{0,102105072,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 370 ->
		[{1,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,101015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{2,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,102015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]},{3,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,103015082,0},{0,101025082,0},{0,101045082,0},{0,101065082,0},{0,101085082,0},{0,101105082,0}]},{4,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,104015082,0},{0,102025082,0},{0,102045082,0},{0,102065082,0},{0,102085082,0},{0,102105082,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 371, _WorldLv =< 420 ->
		[{1,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011410,0},{0,6001409,0},{0,6002409,0},{0,6003409,0},{0,6004409,0},{0,6006409,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 9999 ->
		[{1,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011410,0},{0,6001410,0},{0,6002410,0},{0,6003410,0},{0,6004410,0},{0,6007410,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6007411,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011411,0},{0,6001411,0},{0,6002411,0},{0,6003411,0},{0,6004411,0},{0,6006411,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011411,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6006412,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6006412,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6006412,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6006412,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011412,0},{0,6001412,0},{0,6002412,0},{0,6003412,0},{0,6004412,0},{0,6007412,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6006413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001413,0},{0,6002413,0},{0,6003413,0},{0,6004413,0},{0,6007413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006413,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{2,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]},{3,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{4,[{0,6011413,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015092,0},{0,101025092,0},{0,101045092,0},{0,101065092,0},{0,101085092,0},{0,101105092,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015092,0},{0,102025092,0},{0,102045092,0},{0,102065092,0},{0,102085092,0},{0,102105092,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 1, _WorldLv =< 420 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015102,0},{0,101025102,0},{0,101045102,0},{0,101065102,0},{0,101085102,0},{0,101105102,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015102,0},{0,102025102,0},{0,102045102,0},{0,102065102,0},{0,102085102,0},{0,102105102,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 421, _WorldLv =< 470 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015112,0},{0,101025112,0},{0,101045112,0},{0,101065112,0},{0,101085112,0},{0,101105112,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015112,0},{0,102025112,0},{0,102045112,0},{0,102065112,0},{0,102085112,0},{0,102105112,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 471, _WorldLv =< 520 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015122,0},{0,101025122,0},{0,101045122,0},{0,101065122,0},{0,101085122,0},{0,101105122,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015122,0},{0,102025122,0},{0,102045122,0},{0,102065122,0},{0,102085122,0},{0,102105122,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 521, _WorldLv =< 570 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015132,0},{0,101025132,0},{0,101045132,0},{0,101065132,0},{0,101085132,0},{0,101105132,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015132,0},{0,102025132,0},{0,102045132,0},{0,102065132,0},{0,102085132,0},{0,102105132,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 571, _WorldLv =< 620 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015142,0},{0,101025142,0},{0,101045142,0},{0,101065142,0},{0,101085142,0},{0,101105142,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015142,0},{0,102025142,0},{0,102045142,0},{0,102065142,0},{0,102085142,0},{0,102105142,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 621, _WorldLv =< 670 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6006414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015152,0},{0,101025152,0},{0,101045152,0},{0,101065152,0},{0,101085152,0},{0,101105152,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015152,0},{0,102025152,0},{0,102045152,0},{0,102065152,0},{0,102085152,0},{0,102105152,0}]}];
get_reward_preview(_WorldLv) when _WorldLv >= 671, _WorldLv =< 9999 ->
		[{1,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,101015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{2,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,102015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]},{3,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,103015162,0},{0,101025162,0},{0,101045162,0},{0,101065162,0},{0,101085162,0},{0,101105162,0}]},{4,[{0,6011414,0},{0,6001414,0},{0,6002414,0},{0,6003414,0},{0,6004414,0},{0,6007414,0},{0,104015162,0},{0,102025162,0},{0,102045162,0},{0,102065162,0},{0,102085162,0},{0,102105162,0}]}];
get_reward_preview(_WorldLv) ->
	[].

get_all_wlv() ->
[{100,129},{130,159},{160,189},{190,219},{220,249},{250,279},{280,309},{310,339},{340,369},{370,399},{400,429},{430,459},{460,489},{490,519},{520,549},{550,579},{580,609},{610,639},{640,669},{670,699},{700,729},{730,759},{760,789},{790,9999}].

get_limit_hurt_list(100,129) ->
[63000,189000,567000,945000,1575000,3150000];

get_limit_hurt_list(130,159) ->
[126000,378000,1134000,1890000,3150000,6300000];

get_limit_hurt_list(160,189) ->
[234000,702000,2106000,3510000,5850000,11700000];

get_limit_hurt_list(190,219) ->
[453600,1360800,4082400,6804000,11340000,22680000];

get_limit_hurt_list(220,249) ->
[702000,2106000,6318000,10530000,17550000,35100000];

get_limit_hurt_list(250,279) ->
[1134000,3402000,10206000,17010000,28350000,56700000];

get_limit_hurt_list(280,309) ->
[1620000,4860000,14580000,24300000,40500000,81000000];

get_limit_hurt_list(310,339) ->
[2430000,7290000,21870000,36450000,60750000,121500000];

get_limit_hurt_list(340,369) ->
[3240000,9720000,29160000,48600000,81000000,162000000];

get_limit_hurt_list(370,399) ->
[4896000,14688000,44064000,73440000,122400000,244800000];

get_limit_hurt_list(400,429) ->
[6732000,20196000,60588000,100980000,168300000,336600000];

get_limit_hurt_list(430,459) ->
[8568000,25704000,77112000,128520000,214200000,428400000];

get_limit_hurt_list(460,489) ->
[10404000,31212000,93636000,156060000,260100000,520200000];

get_limit_hurt_list(490,519) ->
[12240000,36720000,110160000,183600000,306000000,612000000];

get_limit_hurt_list(520,549) ->
[15300000,45900000,137700000,229500000,382500000,765000000];

get_limit_hurt_list(550,579) ->
[18972000,56916000,170748000,284580000,474300000,948600000];

get_limit_hurt_list(580,609) ->
[22644000,67932000,203796000,339660000,566100000,1132200000];

get_limit_hurt_list(610,639) ->
[26316000,78948000,236844000,394740000,657900000,1315800000];

get_limit_hurt_list(640,669) ->
[32436000,97308000,291924000,486540000,810900000,1621800000];

get_limit_hurt_list(670,699) ->
[39780000,119340000,358020000,596700000,994500000,1989000000];

get_limit_hurt_list(700,729) ->
[47124000,141372000,424116000,706860000,1178100000,2356200000];

get_limit_hurt_list(730,759) ->
[58140000,174420000,523260000,872100000,1453500000,2907000000];

get_limit_hurt_list(760,789) ->
[72828000,218484000,655452000,1092420000,1820700000,3641400000];

get_limit_hurt_list(790,9999) ->
[87516000,262548000,787644000,1312740000,2187900000,4294967295];

get_limit_hurt_list(_Wlvmin,_Wlvmax) ->
	[].

get_point_rule(_Wlv,63000) when _Wlv >= 100, _Wlv =< 129 ->
	#base_c_sanctuary_point{wlv_min=100,wlv_max=129,hurt=63000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,189000) when _Wlv >= 100, _Wlv =< 129 ->
	#base_c_sanctuary_point{wlv_min=100,wlv_max=129,hurt=189000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,567000) when _Wlv >= 100, _Wlv =< 129 ->
	#base_c_sanctuary_point{wlv_min=100,wlv_max=129,hurt=567000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,945000) when _Wlv >= 100, _Wlv =< 129 ->
	#base_c_sanctuary_point{wlv_min=100,wlv_max=129,hurt=945000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,1575000) when _Wlv >= 100, _Wlv =< 129 ->
	#base_c_sanctuary_point{wlv_min=100,wlv_max=129,hurt=1575000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,3150000) when _Wlv >= 100, _Wlv =< 129 ->
	#base_c_sanctuary_point{wlv_min=100,wlv_max=129,hurt=3150000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,126000) when _Wlv >= 130, _Wlv =< 159 ->
	#base_c_sanctuary_point{wlv_min=130,wlv_max=159,hurt=126000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,378000) when _Wlv >= 130, _Wlv =< 159 ->
	#base_c_sanctuary_point{wlv_min=130,wlv_max=159,hurt=378000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,1134000) when _Wlv >= 130, _Wlv =< 159 ->
	#base_c_sanctuary_point{wlv_min=130,wlv_max=159,hurt=1134000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,1890000) when _Wlv >= 130, _Wlv =< 159 ->
	#base_c_sanctuary_point{wlv_min=130,wlv_max=159,hurt=1890000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,3150000) when _Wlv >= 130, _Wlv =< 159 ->
	#base_c_sanctuary_point{wlv_min=130,wlv_max=159,hurt=3150000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,6300000) when _Wlv >= 130, _Wlv =< 159 ->
	#base_c_sanctuary_point{wlv_min=130,wlv_max=159,hurt=6300000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,234000) when _Wlv >= 160, _Wlv =< 189 ->
	#base_c_sanctuary_point{wlv_min=160,wlv_max=189,hurt=234000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,702000) when _Wlv >= 160, _Wlv =< 189 ->
	#base_c_sanctuary_point{wlv_min=160,wlv_max=189,hurt=702000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,2106000) when _Wlv >= 160, _Wlv =< 189 ->
	#base_c_sanctuary_point{wlv_min=160,wlv_max=189,hurt=2106000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,3510000) when _Wlv >= 160, _Wlv =< 189 ->
	#base_c_sanctuary_point{wlv_min=160,wlv_max=189,hurt=3510000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,5850000) when _Wlv >= 160, _Wlv =< 189 ->
	#base_c_sanctuary_point{wlv_min=160,wlv_max=189,hurt=5850000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,11700000) when _Wlv >= 160, _Wlv =< 189 ->
	#base_c_sanctuary_point{wlv_min=160,wlv_max=189,hurt=11700000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,453600) when _Wlv >= 190, _Wlv =< 219 ->
	#base_c_sanctuary_point{wlv_min=190,wlv_max=219,hurt=453600,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,1360800) when _Wlv >= 190, _Wlv =< 219 ->
	#base_c_sanctuary_point{wlv_min=190,wlv_max=219,hurt=1360800,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,4082400) when _Wlv >= 190, _Wlv =< 219 ->
	#base_c_sanctuary_point{wlv_min=190,wlv_max=219,hurt=4082400,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,6804000) when _Wlv >= 190, _Wlv =< 219 ->
	#base_c_sanctuary_point{wlv_min=190,wlv_max=219,hurt=6804000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,11340000) when _Wlv >= 190, _Wlv =< 219 ->
	#base_c_sanctuary_point{wlv_min=190,wlv_max=219,hurt=11340000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,22680000) when _Wlv >= 190, _Wlv =< 219 ->
	#base_c_sanctuary_point{wlv_min=190,wlv_max=219,hurt=22680000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,702000) when _Wlv >= 220, _Wlv =< 249 ->
	#base_c_sanctuary_point{wlv_min=220,wlv_max=249,hurt=702000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,2106000) when _Wlv >= 220, _Wlv =< 249 ->
	#base_c_sanctuary_point{wlv_min=220,wlv_max=249,hurt=2106000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,6318000) when _Wlv >= 220, _Wlv =< 249 ->
	#base_c_sanctuary_point{wlv_min=220,wlv_max=249,hurt=6318000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,10530000) when _Wlv >= 220, _Wlv =< 249 ->
	#base_c_sanctuary_point{wlv_min=220,wlv_max=249,hurt=10530000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,17550000) when _Wlv >= 220, _Wlv =< 249 ->
	#base_c_sanctuary_point{wlv_min=220,wlv_max=249,hurt=17550000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,35100000) when _Wlv >= 220, _Wlv =< 249 ->
	#base_c_sanctuary_point{wlv_min=220,wlv_max=249,hurt=35100000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,1134000) when _Wlv >= 250, _Wlv =< 279 ->
	#base_c_sanctuary_point{wlv_min=250,wlv_max=279,hurt=1134000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,3402000) when _Wlv >= 250, _Wlv =< 279 ->
	#base_c_sanctuary_point{wlv_min=250,wlv_max=279,hurt=3402000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,10206000) when _Wlv >= 250, _Wlv =< 279 ->
	#base_c_sanctuary_point{wlv_min=250,wlv_max=279,hurt=10206000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,17010000) when _Wlv >= 250, _Wlv =< 279 ->
	#base_c_sanctuary_point{wlv_min=250,wlv_max=279,hurt=17010000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,28350000) when _Wlv >= 250, _Wlv =< 279 ->
	#base_c_sanctuary_point{wlv_min=250,wlv_max=279,hurt=28350000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,56700000) when _Wlv >= 250, _Wlv =< 279 ->
	#base_c_sanctuary_point{wlv_min=250,wlv_max=279,hurt=56700000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,1620000) when _Wlv >= 280, _Wlv =< 309 ->
	#base_c_sanctuary_point{wlv_min=280,wlv_max=309,hurt=1620000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,4860000) when _Wlv >= 280, _Wlv =< 309 ->
	#base_c_sanctuary_point{wlv_min=280,wlv_max=309,hurt=4860000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,14580000) when _Wlv >= 280, _Wlv =< 309 ->
	#base_c_sanctuary_point{wlv_min=280,wlv_max=309,hurt=14580000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,24300000) when _Wlv >= 280, _Wlv =< 309 ->
	#base_c_sanctuary_point{wlv_min=280,wlv_max=309,hurt=24300000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,40500000) when _Wlv >= 280, _Wlv =< 309 ->
	#base_c_sanctuary_point{wlv_min=280,wlv_max=309,hurt=40500000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,81000000) when _Wlv >= 280, _Wlv =< 309 ->
	#base_c_sanctuary_point{wlv_min=280,wlv_max=309,hurt=81000000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,2430000) when _Wlv >= 310, _Wlv =< 339 ->
	#base_c_sanctuary_point{wlv_min=310,wlv_max=339,hurt=2430000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,7290000) when _Wlv >= 310, _Wlv =< 339 ->
	#base_c_sanctuary_point{wlv_min=310,wlv_max=339,hurt=7290000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,21870000) when _Wlv >= 310, _Wlv =< 339 ->
	#base_c_sanctuary_point{wlv_min=310,wlv_max=339,hurt=21870000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,36450000) when _Wlv >= 310, _Wlv =< 339 ->
	#base_c_sanctuary_point{wlv_min=310,wlv_max=339,hurt=36450000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,60750000) when _Wlv >= 310, _Wlv =< 339 ->
	#base_c_sanctuary_point{wlv_min=310,wlv_max=339,hurt=60750000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,121500000) when _Wlv >= 310, _Wlv =< 339 ->
	#base_c_sanctuary_point{wlv_min=310,wlv_max=339,hurt=121500000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,3240000) when _Wlv >= 340, _Wlv =< 369 ->
	#base_c_sanctuary_point{wlv_min=340,wlv_max=369,hurt=3240000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,9720000) when _Wlv >= 340, _Wlv =< 369 ->
	#base_c_sanctuary_point{wlv_min=340,wlv_max=369,hurt=9720000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,29160000) when _Wlv >= 340, _Wlv =< 369 ->
	#base_c_sanctuary_point{wlv_min=340,wlv_max=369,hurt=29160000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,48600000) when _Wlv >= 340, _Wlv =< 369 ->
	#base_c_sanctuary_point{wlv_min=340,wlv_max=369,hurt=48600000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,81000000) when _Wlv >= 340, _Wlv =< 369 ->
	#base_c_sanctuary_point{wlv_min=340,wlv_max=369,hurt=81000000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,162000000) when _Wlv >= 340, _Wlv =< 369 ->
	#base_c_sanctuary_point{wlv_min=340,wlv_max=369,hurt=162000000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,4896000) when _Wlv >= 370, _Wlv =< 399 ->
	#base_c_sanctuary_point{wlv_min=370,wlv_max=399,hurt=4896000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,14688000) when _Wlv >= 370, _Wlv =< 399 ->
	#base_c_sanctuary_point{wlv_min=370,wlv_max=399,hurt=14688000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,44064000) when _Wlv >= 370, _Wlv =< 399 ->
	#base_c_sanctuary_point{wlv_min=370,wlv_max=399,hurt=44064000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,73440000) when _Wlv >= 370, _Wlv =< 399 ->
	#base_c_sanctuary_point{wlv_min=370,wlv_max=399,hurt=73440000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,122400000) when _Wlv >= 370, _Wlv =< 399 ->
	#base_c_sanctuary_point{wlv_min=370,wlv_max=399,hurt=122400000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,244800000) when _Wlv >= 370, _Wlv =< 399 ->
	#base_c_sanctuary_point{wlv_min=370,wlv_max=399,hurt=244800000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,6732000) when _Wlv >= 400, _Wlv =< 429 ->
	#base_c_sanctuary_point{wlv_min=400,wlv_max=429,hurt=6732000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,20196000) when _Wlv >= 400, _Wlv =< 429 ->
	#base_c_sanctuary_point{wlv_min=400,wlv_max=429,hurt=20196000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,60588000) when _Wlv >= 400, _Wlv =< 429 ->
	#base_c_sanctuary_point{wlv_min=400,wlv_max=429,hurt=60588000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,100980000) when _Wlv >= 400, _Wlv =< 429 ->
	#base_c_sanctuary_point{wlv_min=400,wlv_max=429,hurt=100980000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,168300000) when _Wlv >= 400, _Wlv =< 429 ->
	#base_c_sanctuary_point{wlv_min=400,wlv_max=429,hurt=168300000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,336600000) when _Wlv >= 400, _Wlv =< 429 ->
	#base_c_sanctuary_point{wlv_min=400,wlv_max=429,hurt=336600000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,8568000) when _Wlv >= 430, _Wlv =< 459 ->
	#base_c_sanctuary_point{wlv_min=430,wlv_max=459,hurt=8568000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,25704000) when _Wlv >= 430, _Wlv =< 459 ->
	#base_c_sanctuary_point{wlv_min=430,wlv_max=459,hurt=25704000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,77112000) when _Wlv >= 430, _Wlv =< 459 ->
	#base_c_sanctuary_point{wlv_min=430,wlv_max=459,hurt=77112000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,128520000) when _Wlv >= 430, _Wlv =< 459 ->
	#base_c_sanctuary_point{wlv_min=430,wlv_max=459,hurt=128520000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,214200000) when _Wlv >= 430, _Wlv =< 459 ->
	#base_c_sanctuary_point{wlv_min=430,wlv_max=459,hurt=214200000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,428400000) when _Wlv >= 430, _Wlv =< 459 ->
	#base_c_sanctuary_point{wlv_min=430,wlv_max=459,hurt=428400000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,10404000) when _Wlv >= 460, _Wlv =< 489 ->
	#base_c_sanctuary_point{wlv_min=460,wlv_max=489,hurt=10404000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,31212000) when _Wlv >= 460, _Wlv =< 489 ->
	#base_c_sanctuary_point{wlv_min=460,wlv_max=489,hurt=31212000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,93636000) when _Wlv >= 460, _Wlv =< 489 ->
	#base_c_sanctuary_point{wlv_min=460,wlv_max=489,hurt=93636000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,156060000) when _Wlv >= 460, _Wlv =< 489 ->
	#base_c_sanctuary_point{wlv_min=460,wlv_max=489,hurt=156060000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,260100000) when _Wlv >= 460, _Wlv =< 489 ->
	#base_c_sanctuary_point{wlv_min=460,wlv_max=489,hurt=260100000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,520200000) when _Wlv >= 460, _Wlv =< 489 ->
	#base_c_sanctuary_point{wlv_min=460,wlv_max=489,hurt=520200000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,12240000) when _Wlv >= 490, _Wlv =< 519 ->
	#base_c_sanctuary_point{wlv_min=490,wlv_max=519,hurt=12240000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,36720000) when _Wlv >= 490, _Wlv =< 519 ->
	#base_c_sanctuary_point{wlv_min=490,wlv_max=519,hurt=36720000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,110160000) when _Wlv >= 490, _Wlv =< 519 ->
	#base_c_sanctuary_point{wlv_min=490,wlv_max=519,hurt=110160000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,183600000) when _Wlv >= 490, _Wlv =< 519 ->
	#base_c_sanctuary_point{wlv_min=490,wlv_max=519,hurt=183600000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,306000000) when _Wlv >= 490, _Wlv =< 519 ->
	#base_c_sanctuary_point{wlv_min=490,wlv_max=519,hurt=306000000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,612000000) when _Wlv >= 490, _Wlv =< 519 ->
	#base_c_sanctuary_point{wlv_min=490,wlv_max=519,hurt=612000000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,15300000) when _Wlv >= 520, _Wlv =< 549 ->
	#base_c_sanctuary_point{wlv_min=520,wlv_max=549,hurt=15300000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,45900000) when _Wlv >= 520, _Wlv =< 549 ->
	#base_c_sanctuary_point{wlv_min=520,wlv_max=549,hurt=45900000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,137700000) when _Wlv >= 520, _Wlv =< 549 ->
	#base_c_sanctuary_point{wlv_min=520,wlv_max=549,hurt=137700000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,229500000) when _Wlv >= 520, _Wlv =< 549 ->
	#base_c_sanctuary_point{wlv_min=520,wlv_max=549,hurt=229500000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,382500000) when _Wlv >= 520, _Wlv =< 549 ->
	#base_c_sanctuary_point{wlv_min=520,wlv_max=549,hurt=382500000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,765000000) when _Wlv >= 520, _Wlv =< 549 ->
	#base_c_sanctuary_point{wlv_min=520,wlv_max=549,hurt=765000000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,18972000) when _Wlv >= 550, _Wlv =< 579 ->
	#base_c_sanctuary_point{wlv_min=550,wlv_max=579,hurt=18972000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,56916000) when _Wlv >= 550, _Wlv =< 579 ->
	#base_c_sanctuary_point{wlv_min=550,wlv_max=579,hurt=56916000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,170748000) when _Wlv >= 550, _Wlv =< 579 ->
	#base_c_sanctuary_point{wlv_min=550,wlv_max=579,hurt=170748000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,284580000) when _Wlv >= 550, _Wlv =< 579 ->
	#base_c_sanctuary_point{wlv_min=550,wlv_max=579,hurt=284580000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,474300000) when _Wlv >= 550, _Wlv =< 579 ->
	#base_c_sanctuary_point{wlv_min=550,wlv_max=579,hurt=474300000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,948600000) when _Wlv >= 550, _Wlv =< 579 ->
	#base_c_sanctuary_point{wlv_min=550,wlv_max=579,hurt=948600000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,22644000) when _Wlv >= 580, _Wlv =< 609 ->
	#base_c_sanctuary_point{wlv_min=580,wlv_max=609,hurt=22644000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,67932000) when _Wlv >= 580, _Wlv =< 609 ->
	#base_c_sanctuary_point{wlv_min=580,wlv_max=609,hurt=67932000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,203796000) when _Wlv >= 580, _Wlv =< 609 ->
	#base_c_sanctuary_point{wlv_min=580,wlv_max=609,hurt=203796000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,339660000) when _Wlv >= 580, _Wlv =< 609 ->
	#base_c_sanctuary_point{wlv_min=580,wlv_max=609,hurt=339660000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,566100000) when _Wlv >= 580, _Wlv =< 609 ->
	#base_c_sanctuary_point{wlv_min=580,wlv_max=609,hurt=566100000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,1132200000) when _Wlv >= 580, _Wlv =< 609 ->
	#base_c_sanctuary_point{wlv_min=580,wlv_max=609,hurt=1132200000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,26316000) when _Wlv >= 610, _Wlv =< 639 ->
	#base_c_sanctuary_point{wlv_min=610,wlv_max=639,hurt=26316000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,78948000) when _Wlv >= 610, _Wlv =< 639 ->
	#base_c_sanctuary_point{wlv_min=610,wlv_max=639,hurt=78948000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,236844000) when _Wlv >= 610, _Wlv =< 639 ->
	#base_c_sanctuary_point{wlv_min=610,wlv_max=639,hurt=236844000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,394740000) when _Wlv >= 610, _Wlv =< 639 ->
	#base_c_sanctuary_point{wlv_min=610,wlv_max=639,hurt=394740000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,657900000) when _Wlv >= 610, _Wlv =< 639 ->
	#base_c_sanctuary_point{wlv_min=610,wlv_max=639,hurt=657900000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,1315800000) when _Wlv >= 610, _Wlv =< 639 ->
	#base_c_sanctuary_point{wlv_min=610,wlv_max=639,hurt=1315800000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,32436000) when _Wlv >= 640, _Wlv =< 669 ->
	#base_c_sanctuary_point{wlv_min=640,wlv_max=669,hurt=32436000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,97308000) when _Wlv >= 640, _Wlv =< 669 ->
	#base_c_sanctuary_point{wlv_min=640,wlv_max=669,hurt=97308000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,291924000) when _Wlv >= 640, _Wlv =< 669 ->
	#base_c_sanctuary_point{wlv_min=640,wlv_max=669,hurt=291924000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,486540000) when _Wlv >= 640, _Wlv =< 669 ->
	#base_c_sanctuary_point{wlv_min=640,wlv_max=669,hurt=486540000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,810900000) when _Wlv >= 640, _Wlv =< 669 ->
	#base_c_sanctuary_point{wlv_min=640,wlv_max=669,hurt=810900000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,1621800000) when _Wlv >= 640, _Wlv =< 669 ->
	#base_c_sanctuary_point{wlv_min=640,wlv_max=669,hurt=1621800000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,39780000) when _Wlv >= 670, _Wlv =< 699 ->
	#base_c_sanctuary_point{wlv_min=670,wlv_max=699,hurt=39780000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,119340000) when _Wlv >= 670, _Wlv =< 699 ->
	#base_c_sanctuary_point{wlv_min=670,wlv_max=699,hurt=119340000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,358020000) when _Wlv >= 670, _Wlv =< 699 ->
	#base_c_sanctuary_point{wlv_min=670,wlv_max=699,hurt=358020000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,596700000) when _Wlv >= 670, _Wlv =< 699 ->
	#base_c_sanctuary_point{wlv_min=670,wlv_max=699,hurt=596700000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,994500000) when _Wlv >= 670, _Wlv =< 699 ->
	#base_c_sanctuary_point{wlv_min=670,wlv_max=699,hurt=994500000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,1989000000) when _Wlv >= 670, _Wlv =< 699 ->
	#base_c_sanctuary_point{wlv_min=670,wlv_max=699,hurt=1989000000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,47124000) when _Wlv >= 700, _Wlv =< 729 ->
	#base_c_sanctuary_point{wlv_min=700,wlv_max=729,hurt=47124000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,141372000) when _Wlv >= 700, _Wlv =< 729 ->
	#base_c_sanctuary_point{wlv_min=700,wlv_max=729,hurt=141372000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,424116000) when _Wlv >= 700, _Wlv =< 729 ->
	#base_c_sanctuary_point{wlv_min=700,wlv_max=729,hurt=424116000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,706860000) when _Wlv >= 700, _Wlv =< 729 ->
	#base_c_sanctuary_point{wlv_min=700,wlv_max=729,hurt=706860000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,1178100000) when _Wlv >= 700, _Wlv =< 729 ->
	#base_c_sanctuary_point{wlv_min=700,wlv_max=729,hurt=1178100000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,2356200000) when _Wlv >= 700, _Wlv =< 729 ->
	#base_c_sanctuary_point{wlv_min=700,wlv_max=729,hurt=2356200000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,58140000) when _Wlv >= 730, _Wlv =< 759 ->
	#base_c_sanctuary_point{wlv_min=730,wlv_max=759,hurt=58140000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,174420000) when _Wlv >= 730, _Wlv =< 759 ->
	#base_c_sanctuary_point{wlv_min=730,wlv_max=759,hurt=174420000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,523260000) when _Wlv >= 730, _Wlv =< 759 ->
	#base_c_sanctuary_point{wlv_min=730,wlv_max=759,hurt=523260000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,872100000) when _Wlv >= 730, _Wlv =< 759 ->
	#base_c_sanctuary_point{wlv_min=730,wlv_max=759,hurt=872100000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,1453500000) when _Wlv >= 730, _Wlv =< 759 ->
	#base_c_sanctuary_point{wlv_min=730,wlv_max=759,hurt=1453500000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,2907000000) when _Wlv >= 730, _Wlv =< 759 ->
	#base_c_sanctuary_point{wlv_min=730,wlv_max=759,hurt=2907000000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,72828000) when _Wlv >= 760, _Wlv =< 789 ->
	#base_c_sanctuary_point{wlv_min=760,wlv_max=789,hurt=72828000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,218484000) when _Wlv >= 760, _Wlv =< 789 ->
	#base_c_sanctuary_point{wlv_min=760,wlv_max=789,hurt=218484000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,655452000) when _Wlv >= 760, _Wlv =< 789 ->
	#base_c_sanctuary_point{wlv_min=760,wlv_max=789,hurt=655452000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,1092420000) when _Wlv >= 760, _Wlv =< 789 ->
	#base_c_sanctuary_point{wlv_min=760,wlv_max=789,hurt=1092420000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,1820700000) when _Wlv >= 760, _Wlv =< 789 ->
	#base_c_sanctuary_point{wlv_min=760,wlv_max=789,hurt=1820700000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,3641400000) when _Wlv >= 760, _Wlv =< 789 ->
	#base_c_sanctuary_point{wlv_min=760,wlv_max=789,hurt=3641400000,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,87516000) when _Wlv >= 790, _Wlv =< 9999 ->
	#base_c_sanctuary_point{wlv_min=790,wlv_max=9999,hurt=87516000,hurt_add=5,kill_add=4};
get_point_rule(_Wlv,262548000) when _Wlv >= 790, _Wlv =< 9999 ->
	#base_c_sanctuary_point{wlv_min=790,wlv_max=9999,hurt=262548000,hurt_add=10,kill_add=4};
get_point_rule(_Wlv,787644000) when _Wlv >= 790, _Wlv =< 9999 ->
	#base_c_sanctuary_point{wlv_min=790,wlv_max=9999,hurt=787644000,hurt_add=15,kill_add=4};
get_point_rule(_Wlv,1312740000) when _Wlv >= 790, _Wlv =< 9999 ->
	#base_c_sanctuary_point{wlv_min=790,wlv_max=9999,hurt=1312740000,hurt_add=20,kill_add=4};
get_point_rule(_Wlv,2187900000) when _Wlv >= 790, _Wlv =< 9999 ->
	#base_c_sanctuary_point{wlv_min=790,wlv_max=9999,hurt=2187900000,hurt_add=40,kill_add=4};
get_point_rule(_Wlv,4294967295) when _Wlv >= 790, _Wlv =< 9999 ->
	#base_c_sanctuary_point{wlv_min=790,wlv_max=9999,hurt=4294967295,hurt_add=80,kill_add=4};
get_point_rule(_Wlv,_Hurt) ->
	[].

get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380021, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380021,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380022, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380022,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380023, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380023,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380024, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380024,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380025, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380025,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380026, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380026,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380027, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380027,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380028, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380028,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380029, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380029,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380030, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380030,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380071, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380071,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380072, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380072,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380073, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380073,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380074, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380074,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380075, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380075,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380076, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380076,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380077, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380077,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380078, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380078,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380079, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380079,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380080, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380080,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380161, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380161,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380162, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380162,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380163, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380163,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380164, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380164,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380165, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380165,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380166, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380166,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380167, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380167,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380168, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380168,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380169, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380169,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380170, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380170,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380171, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380171,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380172, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380172,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380173, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380173,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380174, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380174,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380175, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380175,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380176, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380176,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380177, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380177,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380178, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380178,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380179, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380179,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380180, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380180,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380181, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380181,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380182, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380182,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380183, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380183,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380184, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380184,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380185, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380185,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380186, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380186,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380187, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380187,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380188, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380188,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380189, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380189,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380190, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380190,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380191, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380191,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380192, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380192,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380193, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380193,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380194, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380194,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380195, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380195,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380196, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380196,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380197, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380197,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380198, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380198,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380199, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380199,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380200, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380200,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380201, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380201,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380202, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380202,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380203, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380203,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380204, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380204,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380205, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380205,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380206, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380206,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=1,wlv_max=290,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=291,wlv_max=350,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=351,wlv_max=400,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=401,wlv_max=455,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=456,wlv_max=500,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=501,wlv_max=550,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380207, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380207,wlv_min=551,wlv_max=9999,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=1,wlv_max=290,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=291,wlv_max=350,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=351,wlv_max=400,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=401,wlv_max=455,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=456,wlv_max=500,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=501,wlv_max=550,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380208, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380208,wlv_min=551,wlv_max=9999,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=1,wlv_max=290,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=291,wlv_max=350,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=351,wlv_max=400,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=401,wlv_max=455,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=456,wlv_max=500,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=501,wlv_max=550,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380209, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380209,wlv_min=551,wlv_max=9999,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=1,wlv_max=290,worth=85,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284202,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=291,wlv_max=350,worth=85,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284203,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=351,wlv_max=400,worth=85,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284204,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=401,wlv_max=455,worth=85,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284205,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=456,wlv_max=500,worth=85,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284206,16000,200,0},{284215,10000,50,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=501,wlv_max=550,worth=85,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284207,16000,200,0},{284215,10000,50,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380210, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380210,wlv_min=551,wlv_max=9999,worth=85,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284208,16000,200,0},{284215,10000,50,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380211, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380211,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380212, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380212,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380213, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380213,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380214, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380214,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380215, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380215,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380216, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380216,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380217, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380217,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380218, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380218,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380219, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380219,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380220, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380220,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380301, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380301,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380302, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380302,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380303, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380303,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380304, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380304,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380305, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380305,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380306, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380306,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380307, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380307,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380308, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380308,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380309, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380309,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380310, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380310,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380311, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380311,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380312, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380312,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380313, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380313,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380314, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380314,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380315, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380315,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380316, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380316,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380317, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380317,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380318, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380318,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380319, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380319,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380320, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380320,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380321, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380321,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380322, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380322,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380323, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380323,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380324, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380324,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380325, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380325,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380326, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380326,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380327, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380327,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380328, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380328,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380329, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380329,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380330, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380330,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380331, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380331,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380332, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380332,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380333, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380333,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380334, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380334,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380335, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380335,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380336, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380336,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380337, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380337,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380338, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380338,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=1,wlv_max=290,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=291,wlv_max=350,worth=18,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=351,wlv_max=400,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=401,wlv_max=455,worth=18,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=456,wlv_max=500,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=501,wlv_max=550,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380339, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380339,wlv_min=551,wlv_max=9999,worth=18,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=1,wlv_max=290,worth=55,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=291,wlv_max=350,worth=55,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284113,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=351,wlv_max=400,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=401,wlv_max=455,worth=55,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=456,wlv_max=500,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284206,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=501,wlv_max=550,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284207,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380340, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380340,wlv_min=551,wlv_max=9999,worth=55,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284113,90000,600,0},{284114,90000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=50,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284211,12800,200,0},{284208,16000,200,0},{284214,120000,600,0},{284216,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380341, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380341,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380342, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380342,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380343, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380343,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380344, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380344,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380345, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380345,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=1,wlv_max=290,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=291,wlv_max=350,worth=0,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=351,wlv_max=400,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=401,wlv_max=455,worth=0,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=456,wlv_max=500,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=501,wlv_max=550,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380346, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380346,wlv_min=551,wlv_max=9999,worth=0,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=20,bgold_produce=[{284201,144000,4000,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=1,wlv_max=290,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=291,wlv_max=350,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=351,wlv_max=400,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=401,wlv_max=455,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=456,wlv_max=500,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=501,wlv_max=550,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380347, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380347,wlv_min=551,wlv_max=9999,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=1,wlv_max=290,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=291,wlv_max=350,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=351,wlv_max=400,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=401,wlv_max=455,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=456,wlv_max=500,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=501,wlv_max=550,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380348, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380348,wlv_min=551,wlv_max=9999,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=1,wlv_max=290,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284202,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=291,wlv_max=350,worth=30,produce=[{284101,60000,3000,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284203,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=351,wlv_max=400,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284204,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=401,wlv_max=455,worth=30,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284105,72000,600,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284205,16000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=456,wlv_max=500,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284206,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=501,wlv_max=550,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284207,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380349, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380349,wlv_min=551,wlv_max=9999,worth=30,produce=[{284102,25000,500,0},{284103,25000,200,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=30,bgold_produce=[{284201,144000,4000,0},{284210,12000,300,0},{284208,16000,200,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=1,wlv_max=290,worth=85,produce=[{284101,60000,3000,0},{284106,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284202,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=291,wlv_max=350,worth=85,produce=[{284101,60000,3000,0},{284107,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284203,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=351,wlv_max=400,worth=85,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284108,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284204,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=401,wlv_max=455,worth=85,produce=[{284101,60000,3000,0},{284102,25000,500,0},{284109,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284205,16000,200,0},{284215,10000,50,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=456,wlv_max=500,worth=85,produce=[{284102,25000,500,0},{284103,25000,200,0},{284110,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284206,16000,200,0},{284215,10000,50,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=501,wlv_max=550,worth=85,produce=[{284102,25000,500,0},{284103,25000,200,0},{284111,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284207,16000,200,0},{284215,10000,50,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) when _MonId == 380350, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_boss{mon_id=380350,wlv_min=551,wlv_max=9999,worth=85,produce=[{284102,25000,500,0},{284103,25000,200,0},{284112,30000,300,0},{284117,7500,50,1},{284115,80000,400,1},{284114,90000,600,0},{284105,72000,600,0},{284120,4500,300,0},{284121,4500,300,0}],bgold_worth=70,bgold_produce=[{284201,144000,4000,0},{284211,12800,200,0},{284213,100000,400,0},{284214,120000,600,0},{284208,16000,200,0},{284215,10000,50,0},{284216,15000,200,0},{284217,15000,200,0}]};
get_auction_by_mon(_MonId,_Wlv) ->
	[].

get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38001, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38001,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38002, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38002,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38004, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38004,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38005, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38005,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38006, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38006,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38007, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38007,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38009, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38009,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38010, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38010,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38011, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38011,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38012, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38012,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38013, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38013,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38014, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38014,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38015, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38015,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38016, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38016,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38023, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38023,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38024, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38024,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38025, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38025,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38026, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38026,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38027, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38027,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38028, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38028,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38029, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38029,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 1, _Wlv =< 290 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=1,wlv_max=290,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284106,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284202,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 291, _Wlv =< 350 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=291,wlv_max=350,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284107,30000,300,0},{284113,90000,600,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284203,16000,200,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 351, _Wlv =< 400 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=351,wlv_max=400,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284108,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284204,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 401, _Wlv =< 455 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=401,wlv_max=455,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284109,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284205,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 456, _Wlv =< 500 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=456,wlv_max=500,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284110,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284206,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 501, _Wlv =< 550 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=501,wlv_max=550,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284111,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284207,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) when _Scene == 38030, _Wlv >= 551, _Wlv =< 9999 ->
	#base_c_sanctuary_auction_scene{scene=38030,wlv_min=551,wlv_max=9999,worth=0,ratio=20,produce=[{284104,80000,8000,0},{284101,60000,3000,0},{284112,30000,300,0},{284113,90000,600,0},{284102,50000,1000,0},{284103,62500,500,0}],bgold_worth=0,bgold_ratio=40,bgold_produce=[{284201,144000,4000,0},{284209,16000,500,0},{284208,16000,200,0},{284214,120000,600,0}]};
get_auction_by_scene(_Scene,_Wlv) ->
	[].

get_all_id() ->
[15,16,17,18,19,20,21,22].

