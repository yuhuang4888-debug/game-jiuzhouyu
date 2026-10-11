%%%---------------------------------------
%%% module      : data_drop_limit
%%% description : 掉落上限配置
%%%
%%%---------------------------------------
-module(data_drop_limit).
-compile(export_all).
-include("drop.hrl").



get_goods_limit(0,18030001) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 18030001,limit_type = 0,limit_day = 1,limit_num = 1};

get_goods_limit(0,18030002) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 18030002,limit_type = 1,limit_day = 7,limit_num = 7};

get_goods_limit(0,18030003) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 18030003,limit_type = 1,limit_day = 7,limit_num = 7};

get_goods_limit(0,18030004) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 18030004,limit_type = 1,limit_day = 7,limit_num = 3};

get_goods_limit(0,18030005) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 18030005,limit_type = 1,limit_day = 7,limit_num = 2};

get_goods_limit(0,18030006) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 18030006,limit_type = 1,limit_day = 7,limit_num = 1};

get_goods_limit(0,19030001) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 19030001,limit_type = 0,limit_day = 1,limit_num = 1};

get_goods_limit(0,19030002) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 19030002,limit_type = 1,limit_day = 7,limit_num = 7};

get_goods_limit(0,19030003) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 19030003,limit_type = 1,limit_day = 7,limit_num = 7};

get_goods_limit(0,19030004) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 19030004,limit_type = 1,limit_day = 7,limit_num = 3};

get_goods_limit(0,19030005) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 19030005,limit_type = 1,limit_day = 7,limit_num = 2};

get_goods_limit(0,19030006) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 19030006,limit_type = 1,limit_day = 7,limit_num = 1};

get_goods_limit(0,38040017) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38040017,limit_type = 1,limit_day = 7,limit_num = 7};

get_goods_limit(0,38040020) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38040020,limit_type = 1,limit_day = 7,limit_num = 2};

get_goods_limit(0,38070001) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38070001,limit_type = 0,limit_day = 1,limit_num = 2};

get_goods_limit(0,38110001) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110001,limit_type = 0,limit_day = 1,limit_num = 20};

get_goods_limit(0,38110002) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110002,limit_type = 0,limit_day = 1,limit_num = 40};

get_goods_limit(0,38110003) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110003,limit_type = 0,limit_day = 1,limit_num = 30};

get_goods_limit(0,38110004) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110004,limit_type = 0,limit_day = 1,limit_num = 20};

get_goods_limit(0,38110005) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110005,limit_type = 0,limit_day = 1,limit_num = 20};

get_goods_limit(0,38110009) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110009,limit_type = 0,limit_day = 1,limit_num = 20};

get_goods_limit(0,38110013) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110013,limit_type = 0,limit_day = 1,limit_num = 15};

get_goods_limit(0,38110014) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110014,limit_type = 0,limit_day = 1,limit_num = 25};

get_goods_limit(0,38110015) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110015,limit_type = 0,limit_day = 1,limit_num = 20};

get_goods_limit(0,38110016) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110016,limit_type = 0,limit_day = 1,limit_num = 30};

get_goods_limit(0,38110017) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110017,limit_type = 0,limit_day = 1,limit_num = 25};

get_goods_limit(0,38110018) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38110018,limit_type = 0,limit_day = 1,limit_num = 50};

get_goods_limit(0,38190010) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38190010,limit_type = 0,limit_day = 7,limit_num = 20};

get_goods_limit(0,38190011) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38190011,limit_type = 0,limit_day = 7,limit_num = 1};

get_goods_limit(0,38190012) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 38190012,limit_type = 0,limit_day = 7,limit_num = 1};

get_goods_limit(0,39510011) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 39510011,limit_type = 1,limit_day = 7,limit_num = 1};

get_goods_limit(0,56010001) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56010001,limit_type = 0,limit_day = 1,limit_num = 5};

get_goods_limit(0,56010002) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56010002,limit_type = 0,limit_day = 1,limit_num = 5};

get_goods_limit(0,56010003) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56010003,limit_type = 0,limit_day = 1,limit_num = 5};

get_goods_limit(0,56010004) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56010004,limit_type = 0,limit_day = 1,limit_num = 5};

get_goods_limit(0,56020001) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56020001,limit_type = 0,limit_day = 1,limit_num = 1};

get_goods_limit(0,56020002) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56020002,limit_type = 0,limit_day = 1,limit_num = 1};

get_goods_limit(0,56020003) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56020003,limit_type = 0,limit_day = 1,limit_num = 1};

get_goods_limit(0,56020004) ->
	#base_drop_limit{drop_thing_type = 0,goods_id = 56020004,limit_type = 0,limit_day = 1,limit_num = 1};

get_goods_limit(_Dropthingtype,_Goodsid) ->
	[].

