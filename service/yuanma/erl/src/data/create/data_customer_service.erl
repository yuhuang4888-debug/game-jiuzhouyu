%%%---------------------------------------
%%% module      : data_customer_service
%%% description : 客服信息配置
%%%
%%%---------------------------------------
-module(data_customer_service).
-compile(export_all).
-include("customer_service.hrl").



get_cfg(1) ->
	#base_customer_service{id = 1,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(2) ->
	#base_customer_service{id = 2,display = 1,display_code = 1,keyword = "suyou",medium = "bf_suyou",link_info_1 = "客服QQ：3257596149",link_info_2 = "微信公众号：zisugame",work_time = "09:00-20:00"};

get_cfg(3) ->
	#base_customer_service{id = 3,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_1340040",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(4) ->
	#base_customer_service{id = 4,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_1340137",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(5) ->
	#base_customer_service{id = 5,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_1340140",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(6) ->
	#base_customer_service{id = 6,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_1340237",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(7) ->
	#base_customer_service{id = 7,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_1340240",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(8) ->
	#base_customer_service{id = 8,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_ios",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(9) ->
	#base_customer_service{id = 9,display = 1,display_code = 1,keyword = "ml",medium = "bf_ml_ios_1340940",link_info_1 = "微信公众号：mlgame",link_info_2 = "客服电话：4008018738",work_time = "10:00-22:00"};

get_cfg(10) ->
	#base_customer_service{id = 10,display = 1,display_code = 1,keyword = "suyou",medium = "bf_suyou_wzqst",link_info_1 = "微信公众号：zisugame",link_info_2 = "",work_time = "09:00-20:00"};

get_cfg(11) ->
	#base_customer_service{id = 11,display = 1,display_code = 0,keyword = "bf_ml_qzxd",medium = "bf_ml_qzxd",link_info_1 = "微信公众号：huotuwan",link_info_2 = "",work_time = "09:00-20:00"};

get_cfg(12) ->
	#base_customer_service{id = 12,display = 1,display_code = 0,keyword = "bf_ml_gwzx",medium = "bf_ml_gwzx",link_info_1 = "微信公众号：huotuwan",link_info_2 = "",work_time = "09:00-20:00"};

get_cfg(13) ->
	#base_customer_service{id = 13,display = 1,display_code = 0,keyword = "bf_ml_mhwy",medium = "bf_ml_mhwy",link_info_1 = "微信公众号：chaoshenwan",link_info_2 = "",work_time = "09:00-20:00"};

get_cfg(_Id) ->
	[].

get_ids() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13].

get_vip_cfg(1) ->
	#base_customer_service_vip{id = 1,display = 1,keyword = "ml",medium = "bf_ml",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(2) ->
	#base_customer_service_vip{id = 2,display = 1,keyword = "ml",medium = "bf_ml_1340040",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(3) ->
	#base_customer_service_vip{id = 3,display = 1,keyword = "ml",medium = "bf_ml_1340137",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(4) ->
	#base_customer_service_vip{id = 4,display = 1,keyword = "ml",medium = "bf_ml_1340140",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(5) ->
	#base_customer_service_vip{id = 5,display = 1,keyword = "ml",medium = "bf_ml_1340237",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(6) ->
	#base_customer_service_vip{id = 6,display = 1,keyword = "ml",medium = "bf_ml_1340240",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(7) ->
	#base_customer_service_vip{id = 7,display = 1,keyword = "ml",medium = "bf_ml_ios",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(8) ->
	#base_customer_service_vip{id = 8,display = 1,keyword = "ml",medium = "bf_ml_ios_1340940",menu_gold = 5000,qq_gold = 10000,qq = "800081361"};

get_vip_cfg(9) ->
	#base_customer_service_vip{id = 9,display = 1,keyword = "suyou",medium = "bf_suyou_wzqst",menu_gold = 3000,qq_gold = 5000,qq = "1472631382"};

get_vip_cfg(_Id) ->
	[].

get_vip_ids() ->
[1,2,3,4,5,6,7,8,9].

