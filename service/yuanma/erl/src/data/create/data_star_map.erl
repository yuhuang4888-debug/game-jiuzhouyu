%%%---------------------------------------
%%% module      : data_star_map
%%% description : 星图配置
%%%
%%%---------------------------------------
-module(data_star_map).
-compile(export_all).
-include("star_map.hrl").



get_starmap_cfg(1) ->
	#base_star_map{star_map_id = 1,cons_id = 1,class_id = 1,point_id = 0,cons_name = "白羊座",consume = 0,attr = [{1,0},{2,0},{3,0},{4,0},{15,0},{16,0}],extra_attr = []};

get_starmap_cfg(2) ->
	#base_star_map{star_map_id = 2,cons_id = 1,class_id = 1,point_id = 1,cons_name = "白羊座",consume = 10,attr = [{1,70},{2,0},{3,0},{4,0},{15,0},{16,0}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(3) ->
	#base_star_map{star_map_id = 3,cons_id = 1,class_id = 1,point_id = 2,cons_name = "白羊座",consume = 15,attr = [{1,70},{2,1400},{3,0},{4,0},{15,0},{16,0}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(4) ->
	#base_star_map{star_map_id = 4,cons_id = 1,class_id = 1,point_id = 3,cons_name = "白羊座",consume = 20,attr = [{1,70},{2,1400},{3,70},{4,0},{15,0},{16,0}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(5) ->
	#base_star_map{star_map_id = 5,cons_id = 1,class_id = 1,point_id = 4,cons_name = "白羊座",consume = 25,attr = [{1,70},{2,1400},{3,70},{4,70},{15,0},{16,0}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(6) ->
	#base_star_map{star_map_id = 6,cons_id = 1,class_id = 1,point_id = 5,cons_name = "白羊座",consume = 30,attr = [{1,70},{2,1400},{3,70},{4,70},{15,70},{16,0}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(7) ->
	#base_star_map{star_map_id = 7,cons_id = 1,class_id = 1,point_id = 6,cons_name = "白羊座",consume = 35,attr = [{1,70},{2,1400},{3,70},{4,70},{15,70},{16,70}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(8) ->
	#base_star_map{star_map_id = 8,cons_id = 1,class_id = 1,point_id = 7,cons_name = "白羊座",consume = 40,attr = [{1,70},{2,2800},{3,70},{4,70},{15,70},{16,70}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(9) ->
	#base_star_map{star_map_id = 9,cons_id = 1,class_id = 1,point_id = 8,cons_name = "白羊座",consume = 45,attr = [{1,140},{2,2800},{3,70},{4,70},{15,70},{16,70}],extra_attr = [{15,70},{16,70},{68,200}]};

get_starmap_cfg(10) ->
	#base_star_map{star_map_id = 10,cons_id = 1,class_id = 2,point_id = 1,cons_name = "白羊座",consume = 19,attr = [{1,211},{2,2800},{3,70},{4,70},{15,70},{16,70}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(11) ->
	#base_star_map{star_map_id = 11,cons_id = 1,class_id = 2,point_id = 2,cons_name = "白羊座",consume = 24,attr = [{1,211},{2,4220},{3,70},{4,70},{15,70},{16,70}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(12) ->
	#base_star_map{star_map_id = 12,cons_id = 1,class_id = 2,point_id = 3,cons_name = "白羊座",consume = 29,attr = [{1,211},{2,4220},{3,141},{4,70},{15,70},{16,70}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(13) ->
	#base_star_map{star_map_id = 13,cons_id = 1,class_id = 2,point_id = 4,cons_name = "白羊座",consume = 34,attr = [{1,211},{2,4220},{3,141},{4,141},{15,70},{16,70}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(14) ->
	#base_star_map{star_map_id = 14,cons_id = 1,class_id = 2,point_id = 5,cons_name = "白羊座",consume = 39,attr = [{1,211},{2,4220},{3,141},{4,141},{15,141},{16,70}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(15) ->
	#base_star_map{star_map_id = 15,cons_id = 1,class_id = 2,point_id = 6,cons_name = "白羊座",consume = 44,attr = [{1,211},{2,4220},{3,141},{4,141},{15,141},{16,141}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(16) ->
	#base_star_map{star_map_id = 16,cons_id = 1,class_id = 2,point_id = 7,cons_name = "白羊座",consume = 49,attr = [{1,211},{2,5640},{3,141},{4,141},{15,141},{16,141}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(17) ->
	#base_star_map{star_map_id = 17,cons_id = 1,class_id = 2,point_id = 8,cons_name = "白羊座",consume = 54,attr = [{1,282},{2,5640},{3,141},{4,141},{15,141},{16,141}],extra_attr = [{15,141},{16,141},{68,400}]};

get_starmap_cfg(18) ->
	#base_star_map{star_map_id = 18,cons_id = 1,class_id = 3,point_id = 1,cons_name = "白羊座",consume = 28,attr = [{1,354},{2,5640},{3,141},{4,141},{15,141},{16,141}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(19) ->
	#base_star_map{star_map_id = 19,cons_id = 1,class_id = 3,point_id = 2,cons_name = "白羊座",consume = 33,attr = [{1,354},{2,7080},{3,141},{4,141},{15,141},{16,141}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(20) ->
	#base_star_map{star_map_id = 20,cons_id = 1,class_id = 3,point_id = 3,cons_name = "白羊座",consume = 38,attr = [{1,354},{2,7080},{3,213},{4,141},{15,141},{16,141}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(21) ->
	#base_star_map{star_map_id = 21,cons_id = 1,class_id = 3,point_id = 4,cons_name = "白羊座",consume = 43,attr = [{1,354},{2,7080},{3,213},{4,213},{15,141},{16,141}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(22) ->
	#base_star_map{star_map_id = 22,cons_id = 1,class_id = 3,point_id = 5,cons_name = "白羊座",consume = 48,attr = [{1,354},{2,7080},{3,213},{4,213},{15,213},{16,141}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(23) ->
	#base_star_map{star_map_id = 23,cons_id = 1,class_id = 3,point_id = 6,cons_name = "白羊座",consume = 53,attr = [{1,354},{2,7080},{3,213},{4,213},{15,213},{16,213}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(24) ->
	#base_star_map{star_map_id = 24,cons_id = 1,class_id = 3,point_id = 7,cons_name = "白羊座",consume = 58,attr = [{1,354},{2,8520},{3,213},{4,213},{15,213},{16,213}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(25) ->
	#base_star_map{star_map_id = 25,cons_id = 1,class_id = 3,point_id = 8,cons_name = "白羊座",consume = 63,attr = [{1,426},{2,8520},{3,213},{4,213},{15,213},{16,213}],extra_attr = [{15,213},{16,213},{68,600}]};

get_starmap_cfg(26) ->
	#base_star_map{star_map_id = 26,cons_id = 1,class_id = 4,point_id = 1,cons_name = "白羊座",consume = 37,attr = [{1,499},{2,8520},{3,213},{4,213},{15,213},{16,213}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(27) ->
	#base_star_map{star_map_id = 27,cons_id = 1,class_id = 4,point_id = 2,cons_name = "白羊座",consume = 42,attr = [{1,499},{2,9980},{3,213},{4,213},{15,213},{16,213}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(28) ->
	#base_star_map{star_map_id = 28,cons_id = 1,class_id = 4,point_id = 3,cons_name = "白羊座",consume = 47,attr = [{1,499},{2,9980},{3,286},{4,213},{15,213},{16,213}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(29) ->
	#base_star_map{star_map_id = 29,cons_id = 1,class_id = 4,point_id = 4,cons_name = "白羊座",consume = 52,attr = [{1,499},{2,9980},{3,286},{4,286},{15,213},{16,213}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(30) ->
	#base_star_map{star_map_id = 30,cons_id = 1,class_id = 4,point_id = 5,cons_name = "白羊座",consume = 57,attr = [{1,499},{2,9980},{3,286},{4,286},{15,286},{16,213}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(31) ->
	#base_star_map{star_map_id = 31,cons_id = 1,class_id = 4,point_id = 6,cons_name = "白羊座",consume = 62,attr = [{1,499},{2,9980},{3,286},{4,286},{15,286},{16,286}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(32) ->
	#base_star_map{star_map_id = 32,cons_id = 1,class_id = 4,point_id = 7,cons_name = "白羊座",consume = 67,attr = [{1,499},{2,11440},{3,286},{4,286},{15,286},{16,286}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(33) ->
	#base_star_map{star_map_id = 33,cons_id = 1,class_id = 4,point_id = 8,cons_name = "白羊座",consume = 72,attr = [{1,572},{2,11440},{3,286},{4,286},{15,286},{16,286}],extra_attr = [{15,286},{16,286},{68,800}]};

get_starmap_cfg(34) ->
	#base_star_map{star_map_id = 34,cons_id = 1,class_id = 5,point_id = 1,cons_name = "白羊座",consume = 46,attr = [{1,646},{2,11440},{3,286},{4,286},{15,286},{16,286}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(35) ->
	#base_star_map{star_map_id = 35,cons_id = 1,class_id = 5,point_id = 2,cons_name = "白羊座",consume = 51,attr = [{1,646},{2,12920},{3,286},{4,286},{15,286},{16,286}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(36) ->
	#base_star_map{star_map_id = 36,cons_id = 1,class_id = 5,point_id = 3,cons_name = "白羊座",consume = 56,attr = [{1,646},{2,12920},{3,360},{4,286},{15,286},{16,286}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(37) ->
	#base_star_map{star_map_id = 37,cons_id = 1,class_id = 5,point_id = 4,cons_name = "白羊座",consume = 61,attr = [{1,646},{2,12920},{3,360},{4,360},{15,286},{16,286}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(38) ->
	#base_star_map{star_map_id = 38,cons_id = 1,class_id = 5,point_id = 5,cons_name = "白羊座",consume = 66,attr = [{1,646},{2,12920},{3,360},{4,360},{15,360},{16,286}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(39) ->
	#base_star_map{star_map_id = 39,cons_id = 1,class_id = 5,point_id = 6,cons_name = "白羊座",consume = 71,attr = [{1,646},{2,12920},{3,360},{4,360},{15,360},{16,360}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(40) ->
	#base_star_map{star_map_id = 40,cons_id = 1,class_id = 5,point_id = 7,cons_name = "白羊座",consume = 76,attr = [{1,646},{2,14400},{3,360},{4,360},{15,360},{16,360}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(41) ->
	#base_star_map{star_map_id = 41,cons_id = 1,class_id = 5,point_id = 8,cons_name = "白羊座",consume = 81,attr = [{1,720},{2,14400},{3,360},{4,360},{15,360},{16,360}],extra_attr = [{15,360},{16,360},{68,1000}]};

get_starmap_cfg(42) ->
	#base_star_map{star_map_id = 42,cons_id = 1,class_id = 6,point_id = 1,cons_name = "白羊座",consume = 55,attr = [{1,795},{2,14400},{3,360},{4,360},{15,360},{16,360}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(43) ->
	#base_star_map{star_map_id = 43,cons_id = 1,class_id = 6,point_id = 2,cons_name = "白羊座",consume = 60,attr = [{1,795},{2,15900},{3,360},{4,360},{15,360},{16,360}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(44) ->
	#base_star_map{star_map_id = 44,cons_id = 1,class_id = 6,point_id = 3,cons_name = "白羊座",consume = 65,attr = [{1,795},{2,15900},{3,435},{4,360},{15,360},{16,360}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(45) ->
	#base_star_map{star_map_id = 45,cons_id = 1,class_id = 6,point_id = 4,cons_name = "白羊座",consume = 70,attr = [{1,795},{2,15900},{3,435},{4,435},{15,360},{16,360}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(46) ->
	#base_star_map{star_map_id = 46,cons_id = 1,class_id = 6,point_id = 5,cons_name = "白羊座",consume = 75,attr = [{1,795},{2,15900},{3,435},{4,435},{15,435},{16,360}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(47) ->
	#base_star_map{star_map_id = 47,cons_id = 1,class_id = 6,point_id = 6,cons_name = "白羊座",consume = 80,attr = [{1,795},{2,15900},{3,435},{4,435},{15,435},{16,435}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(48) ->
	#base_star_map{star_map_id = 48,cons_id = 1,class_id = 6,point_id = 7,cons_name = "白羊座",consume = 85,attr = [{1,795},{2,17400},{3,435},{4,435},{15,435},{16,435}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(49) ->
	#base_star_map{star_map_id = 49,cons_id = 1,class_id = 6,point_id = 8,cons_name = "白羊座",consume = 90,attr = [{1,870},{2,17400},{3,435},{4,435},{15,435},{16,435}],extra_attr = [{15,435},{16,435},{68,1200}]};

get_starmap_cfg(50) ->
	#base_star_map{star_map_id = 50,cons_id = 1,class_id = 7,point_id = 1,cons_name = "白羊座",consume = 64,attr = [{1,946},{2,17400},{3,435},{4,435},{15,435},{16,435}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(51) ->
	#base_star_map{star_map_id = 51,cons_id = 1,class_id = 7,point_id = 2,cons_name = "白羊座",consume = 69,attr = [{1,946},{2,18920},{3,435},{4,435},{15,435},{16,435}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(52) ->
	#base_star_map{star_map_id = 52,cons_id = 1,class_id = 7,point_id = 3,cons_name = "白羊座",consume = 74,attr = [{1,946},{2,18920},{3,511},{4,435},{15,435},{16,435}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(53) ->
	#base_star_map{star_map_id = 53,cons_id = 1,class_id = 7,point_id = 4,cons_name = "白羊座",consume = 79,attr = [{1,946},{2,18920},{3,511},{4,511},{15,435},{16,435}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(54) ->
	#base_star_map{star_map_id = 54,cons_id = 1,class_id = 7,point_id = 5,cons_name = "白羊座",consume = 84,attr = [{1,946},{2,18920},{3,511},{4,511},{15,511},{16,435}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(55) ->
	#base_star_map{star_map_id = 55,cons_id = 1,class_id = 7,point_id = 6,cons_name = "白羊座",consume = 89,attr = [{1,946},{2,18920},{3,511},{4,511},{15,511},{16,511}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(56) ->
	#base_star_map{star_map_id = 56,cons_id = 1,class_id = 7,point_id = 7,cons_name = "白羊座",consume = 94,attr = [{1,946},{2,20440},{3,511},{4,511},{15,511},{16,511}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(57) ->
	#base_star_map{star_map_id = 57,cons_id = 1,class_id = 7,point_id = 8,cons_name = "白羊座",consume = 99,attr = [{1,1022},{2,20440},{3,511},{4,511},{15,511},{16,511}],extra_attr = [{15,511},{16,511},{68,1400}]};

get_starmap_cfg(58) ->
	#base_star_map{star_map_id = 58,cons_id = 1,class_id = 8,point_id = 1,cons_name = "白羊座",consume = 73,attr = [{1,1099},{2,20440},{3,511},{4,511},{15,511},{16,511}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(59) ->
	#base_star_map{star_map_id = 59,cons_id = 1,class_id = 8,point_id = 2,cons_name = "白羊座",consume = 78,attr = [{1,1099},{2,21980},{3,511},{4,511},{15,511},{16,511}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(60) ->
	#base_star_map{star_map_id = 60,cons_id = 1,class_id = 8,point_id = 3,cons_name = "白羊座",consume = 83,attr = [{1,1099},{2,21980},{3,588},{4,511},{15,511},{16,511}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(61) ->
	#base_star_map{star_map_id = 61,cons_id = 1,class_id = 8,point_id = 4,cons_name = "白羊座",consume = 88,attr = [{1,1099},{2,21980},{3,588},{4,588},{15,511},{16,511}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(62) ->
	#base_star_map{star_map_id = 62,cons_id = 1,class_id = 8,point_id = 5,cons_name = "白羊座",consume = 93,attr = [{1,1099},{2,21980},{3,588},{4,588},{15,588},{16,511}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(63) ->
	#base_star_map{star_map_id = 63,cons_id = 1,class_id = 8,point_id = 6,cons_name = "白羊座",consume = 98,attr = [{1,1099},{2,21980},{3,588},{4,588},{15,588},{16,588}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(64) ->
	#base_star_map{star_map_id = 64,cons_id = 1,class_id = 8,point_id = 7,cons_name = "白羊座",consume = 103,attr = [{1,1099},{2,23520},{3,588},{4,588},{15,588},{16,588}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(65) ->
	#base_star_map{star_map_id = 65,cons_id = 1,class_id = 8,point_id = 8,cons_name = "白羊座",consume = 108,attr = [{1,1176},{2,23520},{3,588},{4,588},{15,588},{16,588}],extra_attr = [{15,588},{16,588},{68,1600}]};

get_starmap_cfg(66) ->
	#base_star_map{star_map_id = 66,cons_id = 1,class_id = 9,point_id = 1,cons_name = "白羊座",consume = 82,attr = [{1,1254},{2,23520},{3,588},{4,588},{15,588},{16,588}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(67) ->
	#base_star_map{star_map_id = 67,cons_id = 1,class_id = 9,point_id = 2,cons_name = "白羊座",consume = 87,attr = [{1,1254},{2,25080},{3,588},{4,588},{15,588},{16,588}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(68) ->
	#base_star_map{star_map_id = 68,cons_id = 1,class_id = 9,point_id = 3,cons_name = "白羊座",consume = 92,attr = [{1,1254},{2,25080},{3,666},{4,588},{15,588},{16,588}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(69) ->
	#base_star_map{star_map_id = 69,cons_id = 1,class_id = 9,point_id = 4,cons_name = "白羊座",consume = 97,attr = [{1,1254},{2,25080},{3,666},{4,666},{15,588},{16,588}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(70) ->
	#base_star_map{star_map_id = 70,cons_id = 1,class_id = 9,point_id = 5,cons_name = "白羊座",consume = 102,attr = [{1,1254},{2,25080},{3,666},{4,666},{15,666},{16,588}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(71) ->
	#base_star_map{star_map_id = 71,cons_id = 1,class_id = 9,point_id = 6,cons_name = "白羊座",consume = 107,attr = [{1,1254},{2,25080},{3,666},{4,666},{15,666},{16,666}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(72) ->
	#base_star_map{star_map_id = 72,cons_id = 1,class_id = 9,point_id = 7,cons_name = "白羊座",consume = 112,attr = [{1,1254},{2,26640},{3,666},{4,666},{15,666},{16,666}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(73) ->
	#base_star_map{star_map_id = 73,cons_id = 1,class_id = 9,point_id = 8,cons_name = "白羊座",consume = 117,attr = [{1,1332},{2,26640},{3,666},{4,666},{15,666},{16,666}],extra_attr = [{15,666},{16,666},{68,1800}]};

get_starmap_cfg(74) ->
	#base_star_map{star_map_id = 74,cons_id = 1,class_id = 10,point_id = 1,cons_name = "白羊座",consume = 91,attr = [{1,1411},{2,26640},{3,666},{4,666},{15,666},{16,666}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(75) ->
	#base_star_map{star_map_id = 75,cons_id = 1,class_id = 10,point_id = 2,cons_name = "白羊座",consume = 96,attr = [{1,1411},{2,28220},{3,666},{4,666},{15,666},{16,666}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(76) ->
	#base_star_map{star_map_id = 76,cons_id = 1,class_id = 10,point_id = 3,cons_name = "白羊座",consume = 101,attr = [{1,1411},{2,28220},{3,745},{4,666},{15,666},{16,666}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(77) ->
	#base_star_map{star_map_id = 77,cons_id = 1,class_id = 10,point_id = 4,cons_name = "白羊座",consume = 106,attr = [{1,1411},{2,28220},{3,745},{4,745},{15,666},{16,666}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(78) ->
	#base_star_map{star_map_id = 78,cons_id = 1,class_id = 10,point_id = 5,cons_name = "白羊座",consume = 111,attr = [{1,1411},{2,28220},{3,745},{4,745},{15,745},{16,666}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(79) ->
	#base_star_map{star_map_id = 79,cons_id = 1,class_id = 10,point_id = 6,cons_name = "白羊座",consume = 116,attr = [{1,1411},{2,28220},{3,745},{4,745},{15,745},{16,745}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(80) ->
	#base_star_map{star_map_id = 80,cons_id = 1,class_id = 10,point_id = 7,cons_name = "白羊座",consume = 121,attr = [{1,1411},{2,29800},{3,745},{4,745},{15,745},{16,745}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(81) ->
	#base_star_map{star_map_id = 81,cons_id = 1,class_id = 10,point_id = 8,cons_name = "白羊座",consume = 126,attr = [{1,1490},{2,29800},{3,745},{4,745},{15,745},{16,745}],extra_attr = [{15,745},{16,745},{68,2000}]};

get_starmap_cfg(82) ->
	#base_star_map{star_map_id = 82,cons_id = 2,class_id = 1,point_id = 1,cons_name = "金牛座",consume = 100,attr = [{1,1570},{2,29800},{3,745},{4,745},{15,745},{16,745}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(83) ->
	#base_star_map{star_map_id = 83,cons_id = 2,class_id = 1,point_id = 2,cons_name = "金牛座",consume = 105,attr = [{1,1570},{2,31400},{3,745},{4,745},{15,745},{16,745}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(84) ->
	#base_star_map{star_map_id = 84,cons_id = 2,class_id = 1,point_id = 3,cons_name = "金牛座",consume = 110,attr = [{1,1570},{2,31400},{3,825},{4,745},{15,745},{16,745}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(85) ->
	#base_star_map{star_map_id = 85,cons_id = 2,class_id = 1,point_id = 4,cons_name = "金牛座",consume = 115,attr = [{1,1570},{2,31400},{3,825},{4,825},{15,745},{16,745}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(86) ->
	#base_star_map{star_map_id = 86,cons_id = 2,class_id = 1,point_id = 5,cons_name = "金牛座",consume = 120,attr = [{1,1570},{2,31400},{3,825},{4,825},{15,825},{16,745}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(87) ->
	#base_star_map{star_map_id = 87,cons_id = 2,class_id = 1,point_id = 6,cons_name = "金牛座",consume = 125,attr = [{1,1570},{2,31400},{3,825},{4,825},{15,825},{16,825}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(88) ->
	#base_star_map{star_map_id = 88,cons_id = 2,class_id = 1,point_id = 7,cons_name = "金牛座",consume = 130,attr = [{1,1570},{2,33000},{3,825},{4,825},{15,825},{16,825}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(89) ->
	#base_star_map{star_map_id = 89,cons_id = 2,class_id = 1,point_id = 8,cons_name = "金牛座",consume = 135,attr = [{1,1650},{2,33000},{3,825},{4,825},{15,825},{16,825}],extra_attr = [{15,825},{16,825},{68,2200}]};

get_starmap_cfg(90) ->
	#base_star_map{star_map_id = 90,cons_id = 2,class_id = 2,point_id = 1,cons_name = "金牛座",consume = 109,attr = [{1,1731},{2,33000},{3,825},{4,825},{15,825},{16,825}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(91) ->
	#base_star_map{star_map_id = 91,cons_id = 2,class_id = 2,point_id = 2,cons_name = "金牛座",consume = 114,attr = [{1,1731},{2,34620},{3,825},{4,825},{15,825},{16,825}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(92) ->
	#base_star_map{star_map_id = 92,cons_id = 2,class_id = 2,point_id = 3,cons_name = "金牛座",consume = 119,attr = [{1,1731},{2,34620},{3,906},{4,825},{15,825},{16,825}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(93) ->
	#base_star_map{star_map_id = 93,cons_id = 2,class_id = 2,point_id = 4,cons_name = "金牛座",consume = 124,attr = [{1,1731},{2,34620},{3,906},{4,906},{15,825},{16,825}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(94) ->
	#base_star_map{star_map_id = 94,cons_id = 2,class_id = 2,point_id = 5,cons_name = "金牛座",consume = 129,attr = [{1,1731},{2,34620},{3,906},{4,906},{15,906},{16,825}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(95) ->
	#base_star_map{star_map_id = 95,cons_id = 2,class_id = 2,point_id = 6,cons_name = "金牛座",consume = 134,attr = [{1,1731},{2,34620},{3,906},{4,906},{15,906},{16,906}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(96) ->
	#base_star_map{star_map_id = 96,cons_id = 2,class_id = 2,point_id = 7,cons_name = "金牛座",consume = 139,attr = [{1,1731},{2,36240},{3,906},{4,906},{15,906},{16,906}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(97) ->
	#base_star_map{star_map_id = 97,cons_id = 2,class_id = 2,point_id = 8,cons_name = "金牛座",consume = 144,attr = [{1,1812},{2,36240},{3,906},{4,906},{15,906},{16,906}],extra_attr = [{15,906},{16,906},{68,2400}]};

get_starmap_cfg(98) ->
	#base_star_map{star_map_id = 98,cons_id = 2,class_id = 3,point_id = 1,cons_name = "金牛座",consume = 118,attr = [{1,1894},{2,36240},{3,906},{4,906},{15,906},{16,906}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(99) ->
	#base_star_map{star_map_id = 99,cons_id = 2,class_id = 3,point_id = 2,cons_name = "金牛座",consume = 123,attr = [{1,1894},{2,37880},{3,906},{4,906},{15,906},{16,906}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(100) ->
	#base_star_map{star_map_id = 100,cons_id = 2,class_id = 3,point_id = 3,cons_name = "金牛座",consume = 128,attr = [{1,1894},{2,37880},{3,988},{4,906},{15,906},{16,906}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(101) ->
	#base_star_map{star_map_id = 101,cons_id = 2,class_id = 3,point_id = 4,cons_name = "金牛座",consume = 133,attr = [{1,1894},{2,37880},{3,988},{4,988},{15,906},{16,906}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(102) ->
	#base_star_map{star_map_id = 102,cons_id = 2,class_id = 3,point_id = 5,cons_name = "金牛座",consume = 138,attr = [{1,1894},{2,37880},{3,988},{4,988},{15,988},{16,906}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(103) ->
	#base_star_map{star_map_id = 103,cons_id = 2,class_id = 3,point_id = 6,cons_name = "金牛座",consume = 143,attr = [{1,1894},{2,37880},{3,988},{4,988},{15,988},{16,988}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(104) ->
	#base_star_map{star_map_id = 104,cons_id = 2,class_id = 3,point_id = 7,cons_name = "金牛座",consume = 148,attr = [{1,1894},{2,39520},{3,988},{4,988},{15,988},{16,988}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(105) ->
	#base_star_map{star_map_id = 105,cons_id = 2,class_id = 3,point_id = 8,cons_name = "金牛座",consume = 153,attr = [{1,1976},{2,39520},{3,988},{4,988},{15,988},{16,988}],extra_attr = [{15,988},{16,988},{68,2600}]};

get_starmap_cfg(106) ->
	#base_star_map{star_map_id = 106,cons_id = 2,class_id = 4,point_id = 1,cons_name = "金牛座",consume = 127,attr = [{1,2059},{2,39520},{3,988},{4,988},{15,988},{16,988}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(107) ->
	#base_star_map{star_map_id = 107,cons_id = 2,class_id = 4,point_id = 2,cons_name = "金牛座",consume = 132,attr = [{1,2059},{2,41180},{3,988},{4,988},{15,988},{16,988}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(108) ->
	#base_star_map{star_map_id = 108,cons_id = 2,class_id = 4,point_id = 3,cons_name = "金牛座",consume = 137,attr = [{1,2059},{2,41180},{3,1071},{4,988},{15,988},{16,988}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(109) ->
	#base_star_map{star_map_id = 109,cons_id = 2,class_id = 4,point_id = 4,cons_name = "金牛座",consume = 142,attr = [{1,2059},{2,41180},{3,1071},{4,1071},{15,988},{16,988}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(110) ->
	#base_star_map{star_map_id = 110,cons_id = 2,class_id = 4,point_id = 5,cons_name = "金牛座",consume = 147,attr = [{1,2059},{2,41180},{3,1071},{4,1071},{15,1071},{16,988}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(111) ->
	#base_star_map{star_map_id = 111,cons_id = 2,class_id = 4,point_id = 6,cons_name = "金牛座",consume = 152,attr = [{1,2059},{2,41180},{3,1071},{4,1071},{15,1071},{16,1071}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(112) ->
	#base_star_map{star_map_id = 112,cons_id = 2,class_id = 4,point_id = 7,cons_name = "金牛座",consume = 157,attr = [{1,2059},{2,42840},{3,1071},{4,1071},{15,1071},{16,1071}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(113) ->
	#base_star_map{star_map_id = 113,cons_id = 2,class_id = 4,point_id = 8,cons_name = "金牛座",consume = 162,attr = [{1,2142},{2,42840},{3,1071},{4,1071},{15,1071},{16,1071}],extra_attr = [{15,1071},{16,1071},{68,2800}]};

get_starmap_cfg(114) ->
	#base_star_map{star_map_id = 114,cons_id = 2,class_id = 5,point_id = 1,cons_name = "金牛座",consume = 136,attr = [{1,2226},{2,42840},{3,1071},{4,1071},{15,1071},{16,1071}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(115) ->
	#base_star_map{star_map_id = 115,cons_id = 2,class_id = 5,point_id = 2,cons_name = "金牛座",consume = 141,attr = [{1,2226},{2,44520},{3,1071},{4,1071},{15,1071},{16,1071}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(116) ->
	#base_star_map{star_map_id = 116,cons_id = 2,class_id = 5,point_id = 3,cons_name = "金牛座",consume = 146,attr = [{1,2226},{2,44520},{3,1155},{4,1071},{15,1071},{16,1071}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(117) ->
	#base_star_map{star_map_id = 117,cons_id = 2,class_id = 5,point_id = 4,cons_name = "金牛座",consume = 151,attr = [{1,2226},{2,44520},{3,1155},{4,1155},{15,1071},{16,1071}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(118) ->
	#base_star_map{star_map_id = 118,cons_id = 2,class_id = 5,point_id = 5,cons_name = "金牛座",consume = 156,attr = [{1,2226},{2,44520},{3,1155},{4,1155},{15,1155},{16,1071}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(119) ->
	#base_star_map{star_map_id = 119,cons_id = 2,class_id = 5,point_id = 6,cons_name = "金牛座",consume = 161,attr = [{1,2226},{2,44520},{3,1155},{4,1155},{15,1155},{16,1155}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(120) ->
	#base_star_map{star_map_id = 120,cons_id = 2,class_id = 5,point_id = 7,cons_name = "金牛座",consume = 166,attr = [{1,2226},{2,46200},{3,1155},{4,1155},{15,1155},{16,1155}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(121) ->
	#base_star_map{star_map_id = 121,cons_id = 2,class_id = 5,point_id = 8,cons_name = "金牛座",consume = 171,attr = [{1,2310},{2,46200},{3,1155},{4,1155},{15,1155},{16,1155}],extra_attr = [{15,1155},{16,1155},{68,3000}]};

get_starmap_cfg(122) ->
	#base_star_map{star_map_id = 122,cons_id = 2,class_id = 6,point_id = 1,cons_name = "金牛座",consume = 145,attr = [{1,2395},{2,46200},{3,1155},{4,1155},{15,1155},{16,1155}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(123) ->
	#base_star_map{star_map_id = 123,cons_id = 2,class_id = 6,point_id = 2,cons_name = "金牛座",consume = 150,attr = [{1,2395},{2,47900},{3,1155},{4,1155},{15,1155},{16,1155}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(124) ->
	#base_star_map{star_map_id = 124,cons_id = 2,class_id = 6,point_id = 3,cons_name = "金牛座",consume = 155,attr = [{1,2395},{2,47900},{3,1240},{4,1155},{15,1155},{16,1155}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(125) ->
	#base_star_map{star_map_id = 125,cons_id = 2,class_id = 6,point_id = 4,cons_name = "金牛座",consume = 160,attr = [{1,2395},{2,47900},{3,1240},{4,1240},{15,1155},{16,1155}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(126) ->
	#base_star_map{star_map_id = 126,cons_id = 2,class_id = 6,point_id = 5,cons_name = "金牛座",consume = 165,attr = [{1,2395},{2,47900},{3,1240},{4,1240},{15,1240},{16,1155}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(127) ->
	#base_star_map{star_map_id = 127,cons_id = 2,class_id = 6,point_id = 6,cons_name = "金牛座",consume = 170,attr = [{1,2395},{2,47900},{3,1240},{4,1240},{15,1240},{16,1240}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(128) ->
	#base_star_map{star_map_id = 128,cons_id = 2,class_id = 6,point_id = 7,cons_name = "金牛座",consume = 175,attr = [{1,2395},{2,49600},{3,1240},{4,1240},{15,1240},{16,1240}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(129) ->
	#base_star_map{star_map_id = 129,cons_id = 2,class_id = 6,point_id = 8,cons_name = "金牛座",consume = 180,attr = [{1,2480},{2,49600},{3,1240},{4,1240},{15,1240},{16,1240}],extra_attr = [{15,1240},{16,1240},{68,3200}]};

get_starmap_cfg(130) ->
	#base_star_map{star_map_id = 130,cons_id = 2,class_id = 7,point_id = 1,cons_name = "金牛座",consume = 154,attr = [{1,2566},{2,49600},{3,1240},{4,1240},{15,1240},{16,1240}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(131) ->
	#base_star_map{star_map_id = 131,cons_id = 2,class_id = 7,point_id = 2,cons_name = "金牛座",consume = 159,attr = [{1,2566},{2,51320},{3,1240},{4,1240},{15,1240},{16,1240}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(132) ->
	#base_star_map{star_map_id = 132,cons_id = 2,class_id = 7,point_id = 3,cons_name = "金牛座",consume = 164,attr = [{1,2566},{2,51320},{3,1326},{4,1240},{15,1240},{16,1240}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(133) ->
	#base_star_map{star_map_id = 133,cons_id = 2,class_id = 7,point_id = 4,cons_name = "金牛座",consume = 169,attr = [{1,2566},{2,51320},{3,1326},{4,1326},{15,1240},{16,1240}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(134) ->
	#base_star_map{star_map_id = 134,cons_id = 2,class_id = 7,point_id = 5,cons_name = "金牛座",consume = 174,attr = [{1,2566},{2,51320},{3,1326},{4,1326},{15,1326},{16,1240}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(135) ->
	#base_star_map{star_map_id = 135,cons_id = 2,class_id = 7,point_id = 6,cons_name = "金牛座",consume = 179,attr = [{1,2566},{2,51320},{3,1326},{4,1326},{15,1326},{16,1326}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(136) ->
	#base_star_map{star_map_id = 136,cons_id = 2,class_id = 7,point_id = 7,cons_name = "金牛座",consume = 184,attr = [{1,2566},{2,53040},{3,1326},{4,1326},{15,1326},{16,1326}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(137) ->
	#base_star_map{star_map_id = 137,cons_id = 2,class_id = 7,point_id = 8,cons_name = "金牛座",consume = 189,attr = [{1,2652},{2,53040},{3,1326},{4,1326},{15,1326},{16,1326}],extra_attr = [{15,1326},{16,1326},{68,3400}]};

get_starmap_cfg(138) ->
	#base_star_map{star_map_id = 138,cons_id = 2,class_id = 8,point_id = 1,cons_name = "金牛座",consume = 163,attr = [{1,2739},{2,53040},{3,1326},{4,1326},{15,1326},{16,1326}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(139) ->
	#base_star_map{star_map_id = 139,cons_id = 2,class_id = 8,point_id = 2,cons_name = "金牛座",consume = 168,attr = [{1,2739},{2,54780},{3,1326},{4,1326},{15,1326},{16,1326}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(140) ->
	#base_star_map{star_map_id = 140,cons_id = 2,class_id = 8,point_id = 3,cons_name = "金牛座",consume = 173,attr = [{1,2739},{2,54780},{3,1413},{4,1326},{15,1326},{16,1326}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(141) ->
	#base_star_map{star_map_id = 141,cons_id = 2,class_id = 8,point_id = 4,cons_name = "金牛座",consume = 178,attr = [{1,2739},{2,54780},{3,1413},{4,1413},{15,1326},{16,1326}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(142) ->
	#base_star_map{star_map_id = 142,cons_id = 2,class_id = 8,point_id = 5,cons_name = "金牛座",consume = 183,attr = [{1,2739},{2,54780},{3,1413},{4,1413},{15,1413},{16,1326}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(143) ->
	#base_star_map{star_map_id = 143,cons_id = 2,class_id = 8,point_id = 6,cons_name = "金牛座",consume = 188,attr = [{1,2739},{2,54780},{3,1413},{4,1413},{15,1413},{16,1413}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(144) ->
	#base_star_map{star_map_id = 144,cons_id = 2,class_id = 8,point_id = 7,cons_name = "金牛座",consume = 193,attr = [{1,2739},{2,56520},{3,1413},{4,1413},{15,1413},{16,1413}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(145) ->
	#base_star_map{star_map_id = 145,cons_id = 2,class_id = 8,point_id = 8,cons_name = "金牛座",consume = 198,attr = [{1,2826},{2,56520},{3,1413},{4,1413},{15,1413},{16,1413}],extra_attr = [{15,1413},{16,1413},{68,3600}]};

get_starmap_cfg(146) ->
	#base_star_map{star_map_id = 146,cons_id = 2,class_id = 9,point_id = 1,cons_name = "金牛座",consume = 172,attr = [{1,2914},{2,56520},{3,1413},{4,1413},{15,1413},{16,1413}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(147) ->
	#base_star_map{star_map_id = 147,cons_id = 2,class_id = 9,point_id = 2,cons_name = "金牛座",consume = 177,attr = [{1,2914},{2,58280},{3,1413},{4,1413},{15,1413},{16,1413}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(148) ->
	#base_star_map{star_map_id = 148,cons_id = 2,class_id = 9,point_id = 3,cons_name = "金牛座",consume = 182,attr = [{1,2914},{2,58280},{3,1501},{4,1413},{15,1413},{16,1413}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(149) ->
	#base_star_map{star_map_id = 149,cons_id = 2,class_id = 9,point_id = 4,cons_name = "金牛座",consume = 187,attr = [{1,2914},{2,58280},{3,1501},{4,1501},{15,1413},{16,1413}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(150) ->
	#base_star_map{star_map_id = 150,cons_id = 2,class_id = 9,point_id = 5,cons_name = "金牛座",consume = 192,attr = [{1,2914},{2,58280},{3,1501},{4,1501},{15,1501},{16,1413}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(151) ->
	#base_star_map{star_map_id = 151,cons_id = 2,class_id = 9,point_id = 6,cons_name = "金牛座",consume = 197,attr = [{1,2914},{2,58280},{3,1501},{4,1501},{15,1501},{16,1501}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(152) ->
	#base_star_map{star_map_id = 152,cons_id = 2,class_id = 9,point_id = 7,cons_name = "金牛座",consume = 202,attr = [{1,2914},{2,60040},{3,1501},{4,1501},{15,1501},{16,1501}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(153) ->
	#base_star_map{star_map_id = 153,cons_id = 2,class_id = 9,point_id = 8,cons_name = "金牛座",consume = 207,attr = [{1,3002},{2,60040},{3,1501},{4,1501},{15,1501},{16,1501}],extra_attr = [{15,1501},{16,1501},{68,3800}]};

get_starmap_cfg(154) ->
	#base_star_map{star_map_id = 154,cons_id = 2,class_id = 10,point_id = 1,cons_name = "金牛座",consume = 181,attr = [{1,3091},{2,60040},{3,1501},{4,1501},{15,1501},{16,1501}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(155) ->
	#base_star_map{star_map_id = 155,cons_id = 2,class_id = 10,point_id = 2,cons_name = "金牛座",consume = 186,attr = [{1,3091},{2,61820},{3,1501},{4,1501},{15,1501},{16,1501}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(156) ->
	#base_star_map{star_map_id = 156,cons_id = 2,class_id = 10,point_id = 3,cons_name = "金牛座",consume = 191,attr = [{1,3091},{2,61820},{3,1590},{4,1501},{15,1501},{16,1501}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(157) ->
	#base_star_map{star_map_id = 157,cons_id = 2,class_id = 10,point_id = 4,cons_name = "金牛座",consume = 196,attr = [{1,3091},{2,61820},{3,1590},{4,1590},{15,1501},{16,1501}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(158) ->
	#base_star_map{star_map_id = 158,cons_id = 2,class_id = 10,point_id = 5,cons_name = "金牛座",consume = 201,attr = [{1,3091},{2,61820},{3,1590},{4,1590},{15,1590},{16,1501}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(159) ->
	#base_star_map{star_map_id = 159,cons_id = 2,class_id = 10,point_id = 6,cons_name = "金牛座",consume = 206,attr = [{1,3091},{2,61820},{3,1590},{4,1590},{15,1590},{16,1590}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(160) ->
	#base_star_map{star_map_id = 160,cons_id = 2,class_id = 10,point_id = 7,cons_name = "金牛座",consume = 211,attr = [{1,3091},{2,63600},{3,1590},{4,1590},{15,1590},{16,1590}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(161) ->
	#base_star_map{star_map_id = 161,cons_id = 2,class_id = 10,point_id = 8,cons_name = "金牛座",consume = 216,attr = [{1,3180},{2,63600},{3,1590},{4,1590},{15,1590},{16,1590}],extra_attr = [{15,1590},{16,1590},{68,4000}]};

get_starmap_cfg(162) ->
	#base_star_map{star_map_id = 162,cons_id = 3,class_id = 1,point_id = 1,cons_name = "双子座",consume = 190,attr = [{1,3270},{2,63600},{3,1590},{4,1590},{15,1590},{16,1590}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(163) ->
	#base_star_map{star_map_id = 163,cons_id = 3,class_id = 1,point_id = 2,cons_name = "双子座",consume = 195,attr = [{1,3270},{2,65400},{3,1590},{4,1590},{15,1590},{16,1590}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(164) ->
	#base_star_map{star_map_id = 164,cons_id = 3,class_id = 1,point_id = 3,cons_name = "双子座",consume = 200,attr = [{1,3270},{2,65400},{3,1680},{4,1590},{15,1590},{16,1590}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(165) ->
	#base_star_map{star_map_id = 165,cons_id = 3,class_id = 1,point_id = 4,cons_name = "双子座",consume = 205,attr = [{1,3270},{2,65400},{3,1680},{4,1680},{15,1590},{16,1590}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(166) ->
	#base_star_map{star_map_id = 166,cons_id = 3,class_id = 1,point_id = 5,cons_name = "双子座",consume = 210,attr = [{1,3270},{2,65400},{3,1680},{4,1680},{15,1680},{16,1590}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(167) ->
	#base_star_map{star_map_id = 167,cons_id = 3,class_id = 1,point_id = 6,cons_name = "双子座",consume = 215,attr = [{1,3270},{2,65400},{3,1680},{4,1680},{15,1680},{16,1680}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(168) ->
	#base_star_map{star_map_id = 168,cons_id = 3,class_id = 1,point_id = 7,cons_name = "双子座",consume = 220,attr = [{1,3270},{2,67200},{3,1680},{4,1680},{15,1680},{16,1680}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(169) ->
	#base_star_map{star_map_id = 169,cons_id = 3,class_id = 1,point_id = 8,cons_name = "双子座",consume = 225,attr = [{1,3360},{2,67200},{3,1680},{4,1680},{15,1680},{16,1680}],extra_attr = [{15,1680},{16,1680},{68,4200}]};

get_starmap_cfg(170) ->
	#base_star_map{star_map_id = 170,cons_id = 3,class_id = 2,point_id = 1,cons_name = "双子座",consume = 199,attr = [{1,3451},{2,67200},{3,1680},{4,1680},{15,1680},{16,1680}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(171) ->
	#base_star_map{star_map_id = 171,cons_id = 3,class_id = 2,point_id = 2,cons_name = "双子座",consume = 204,attr = [{1,3451},{2,69020},{3,1680},{4,1680},{15,1680},{16,1680}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(172) ->
	#base_star_map{star_map_id = 172,cons_id = 3,class_id = 2,point_id = 3,cons_name = "双子座",consume = 209,attr = [{1,3451},{2,69020},{3,1771},{4,1680},{15,1680},{16,1680}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(173) ->
	#base_star_map{star_map_id = 173,cons_id = 3,class_id = 2,point_id = 4,cons_name = "双子座",consume = 214,attr = [{1,3451},{2,69020},{3,1771},{4,1771},{15,1680},{16,1680}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(174) ->
	#base_star_map{star_map_id = 174,cons_id = 3,class_id = 2,point_id = 5,cons_name = "双子座",consume = 219,attr = [{1,3451},{2,69020},{3,1771},{4,1771},{15,1771},{16,1680}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(175) ->
	#base_star_map{star_map_id = 175,cons_id = 3,class_id = 2,point_id = 6,cons_name = "双子座",consume = 224,attr = [{1,3451},{2,69020},{3,1771},{4,1771},{15,1771},{16,1771}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(176) ->
	#base_star_map{star_map_id = 176,cons_id = 3,class_id = 2,point_id = 7,cons_name = "双子座",consume = 229,attr = [{1,3451},{2,70840},{3,1771},{4,1771},{15,1771},{16,1771}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(177) ->
	#base_star_map{star_map_id = 177,cons_id = 3,class_id = 2,point_id = 8,cons_name = "双子座",consume = 234,attr = [{1,3542},{2,70840},{3,1771},{4,1771},{15,1771},{16,1771}],extra_attr = [{15,1771},{16,1771},{68,4400}]};

get_starmap_cfg(178) ->
	#base_star_map{star_map_id = 178,cons_id = 3,class_id = 3,point_id = 1,cons_name = "双子座",consume = 208,attr = [{1,3634},{2,70840},{3,1771},{4,1771},{15,1771},{16,1771}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(179) ->
	#base_star_map{star_map_id = 179,cons_id = 3,class_id = 3,point_id = 2,cons_name = "双子座",consume = 213,attr = [{1,3634},{2,72680},{3,1771},{4,1771},{15,1771},{16,1771}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(180) ->
	#base_star_map{star_map_id = 180,cons_id = 3,class_id = 3,point_id = 3,cons_name = "双子座",consume = 218,attr = [{1,3634},{2,72680},{3,1863},{4,1771},{15,1771},{16,1771}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(181) ->
	#base_star_map{star_map_id = 181,cons_id = 3,class_id = 3,point_id = 4,cons_name = "双子座",consume = 223,attr = [{1,3634},{2,72680},{3,1863},{4,1863},{15,1771},{16,1771}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(182) ->
	#base_star_map{star_map_id = 182,cons_id = 3,class_id = 3,point_id = 5,cons_name = "双子座",consume = 228,attr = [{1,3634},{2,72680},{3,1863},{4,1863},{15,1863},{16,1771}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(183) ->
	#base_star_map{star_map_id = 183,cons_id = 3,class_id = 3,point_id = 6,cons_name = "双子座",consume = 233,attr = [{1,3634},{2,72680},{3,1863},{4,1863},{15,1863},{16,1863}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(184) ->
	#base_star_map{star_map_id = 184,cons_id = 3,class_id = 3,point_id = 7,cons_name = "双子座",consume = 238,attr = [{1,3634},{2,74520},{3,1863},{4,1863},{15,1863},{16,1863}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(185) ->
	#base_star_map{star_map_id = 185,cons_id = 3,class_id = 3,point_id = 8,cons_name = "双子座",consume = 243,attr = [{1,3726},{2,74520},{3,1863},{4,1863},{15,1863},{16,1863}],extra_attr = [{15,1863},{16,1863},{68,4600}]};

get_starmap_cfg(186) ->
	#base_star_map{star_map_id = 186,cons_id = 3,class_id = 4,point_id = 1,cons_name = "双子座",consume = 217,attr = [{1,3819},{2,74520},{3,1863},{4,1863},{15,1863},{16,1863}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(187) ->
	#base_star_map{star_map_id = 187,cons_id = 3,class_id = 4,point_id = 2,cons_name = "双子座",consume = 222,attr = [{1,3819},{2,76380},{3,1863},{4,1863},{15,1863},{16,1863}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(188) ->
	#base_star_map{star_map_id = 188,cons_id = 3,class_id = 4,point_id = 3,cons_name = "双子座",consume = 227,attr = [{1,3819},{2,76380},{3,1956},{4,1863},{15,1863},{16,1863}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(189) ->
	#base_star_map{star_map_id = 189,cons_id = 3,class_id = 4,point_id = 4,cons_name = "双子座",consume = 232,attr = [{1,3819},{2,76380},{3,1956},{4,1956},{15,1863},{16,1863}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(190) ->
	#base_star_map{star_map_id = 190,cons_id = 3,class_id = 4,point_id = 5,cons_name = "双子座",consume = 237,attr = [{1,3819},{2,76380},{3,1956},{4,1956},{15,1956},{16,1863}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(191) ->
	#base_star_map{star_map_id = 191,cons_id = 3,class_id = 4,point_id = 6,cons_name = "双子座",consume = 242,attr = [{1,3819},{2,76380},{3,1956},{4,1956},{15,1956},{16,1956}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(192) ->
	#base_star_map{star_map_id = 192,cons_id = 3,class_id = 4,point_id = 7,cons_name = "双子座",consume = 247,attr = [{1,3819},{2,78240},{3,1956},{4,1956},{15,1956},{16,1956}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(193) ->
	#base_star_map{star_map_id = 193,cons_id = 3,class_id = 4,point_id = 8,cons_name = "双子座",consume = 252,attr = [{1,3912},{2,78240},{3,1956},{4,1956},{15,1956},{16,1956}],extra_attr = [{15,1956},{16,1956},{68,4800}]};

get_starmap_cfg(194) ->
	#base_star_map{star_map_id = 194,cons_id = 3,class_id = 5,point_id = 1,cons_name = "双子座",consume = 226,attr = [{1,4006},{2,78240},{3,1956},{4,1956},{15,1956},{16,1956}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(195) ->
	#base_star_map{star_map_id = 195,cons_id = 3,class_id = 5,point_id = 2,cons_name = "双子座",consume = 231,attr = [{1,4006},{2,80120},{3,1956},{4,1956},{15,1956},{16,1956}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(196) ->
	#base_star_map{star_map_id = 196,cons_id = 3,class_id = 5,point_id = 3,cons_name = "双子座",consume = 236,attr = [{1,4006},{2,80120},{3,2050},{4,1956},{15,1956},{16,1956}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(197) ->
	#base_star_map{star_map_id = 197,cons_id = 3,class_id = 5,point_id = 4,cons_name = "双子座",consume = 241,attr = [{1,4006},{2,80120},{3,2050},{4,2050},{15,1956},{16,1956}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(198) ->
	#base_star_map{star_map_id = 198,cons_id = 3,class_id = 5,point_id = 5,cons_name = "双子座",consume = 246,attr = [{1,4006},{2,80120},{3,2050},{4,2050},{15,2050},{16,1956}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(199) ->
	#base_star_map{star_map_id = 199,cons_id = 3,class_id = 5,point_id = 6,cons_name = "双子座",consume = 251,attr = [{1,4006},{2,80120},{3,2050},{4,2050},{15,2050},{16,2050}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(200) ->
	#base_star_map{star_map_id = 200,cons_id = 3,class_id = 5,point_id = 7,cons_name = "双子座",consume = 256,attr = [{1,4006},{2,82000},{3,2050},{4,2050},{15,2050},{16,2050}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(201) ->
	#base_star_map{star_map_id = 201,cons_id = 3,class_id = 5,point_id = 8,cons_name = "双子座",consume = 261,attr = [{1,4100},{2,82000},{3,2050},{4,2050},{15,2050},{16,2050}],extra_attr = [{15,2050},{16,2050},{68,5000}]};

get_starmap_cfg(202) ->
	#base_star_map{star_map_id = 202,cons_id = 3,class_id = 6,point_id = 1,cons_name = "双子座",consume = 235,attr = [{1,4195},{2,82000},{3,2050},{4,2050},{15,2050},{16,2050}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(203) ->
	#base_star_map{star_map_id = 203,cons_id = 3,class_id = 6,point_id = 2,cons_name = "双子座",consume = 240,attr = [{1,4195},{2,83900},{3,2050},{4,2050},{15,2050},{16,2050}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(204) ->
	#base_star_map{star_map_id = 204,cons_id = 3,class_id = 6,point_id = 3,cons_name = "双子座",consume = 245,attr = [{1,4195},{2,83900},{3,2145},{4,2050},{15,2050},{16,2050}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(205) ->
	#base_star_map{star_map_id = 205,cons_id = 3,class_id = 6,point_id = 4,cons_name = "双子座",consume = 250,attr = [{1,4195},{2,83900},{3,2145},{4,2145},{15,2050},{16,2050}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(206) ->
	#base_star_map{star_map_id = 206,cons_id = 3,class_id = 6,point_id = 5,cons_name = "双子座",consume = 255,attr = [{1,4195},{2,83900},{3,2145},{4,2145},{15,2145},{16,2050}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(207) ->
	#base_star_map{star_map_id = 207,cons_id = 3,class_id = 6,point_id = 6,cons_name = "双子座",consume = 260,attr = [{1,4195},{2,83900},{3,2145},{4,2145},{15,2145},{16,2145}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(208) ->
	#base_star_map{star_map_id = 208,cons_id = 3,class_id = 6,point_id = 7,cons_name = "双子座",consume = 265,attr = [{1,4195},{2,85800},{3,2145},{4,2145},{15,2145},{16,2145}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(209) ->
	#base_star_map{star_map_id = 209,cons_id = 3,class_id = 6,point_id = 8,cons_name = "双子座",consume = 270,attr = [{1,4290},{2,85800},{3,2145},{4,2145},{15,2145},{16,2145}],extra_attr = [{15,2145},{16,2145},{68,5200}]};

get_starmap_cfg(210) ->
	#base_star_map{star_map_id = 210,cons_id = 3,class_id = 7,point_id = 1,cons_name = "双子座",consume = 244,attr = [{1,4386},{2,85800},{3,2145},{4,2145},{15,2145},{16,2145}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(211) ->
	#base_star_map{star_map_id = 211,cons_id = 3,class_id = 7,point_id = 2,cons_name = "双子座",consume = 249,attr = [{1,4386},{2,87720},{3,2145},{4,2145},{15,2145},{16,2145}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(212) ->
	#base_star_map{star_map_id = 212,cons_id = 3,class_id = 7,point_id = 3,cons_name = "双子座",consume = 254,attr = [{1,4386},{2,87720},{3,2241},{4,2145},{15,2145},{16,2145}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(213) ->
	#base_star_map{star_map_id = 213,cons_id = 3,class_id = 7,point_id = 4,cons_name = "双子座",consume = 259,attr = [{1,4386},{2,87720},{3,2241},{4,2241},{15,2145},{16,2145}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(214) ->
	#base_star_map{star_map_id = 214,cons_id = 3,class_id = 7,point_id = 5,cons_name = "双子座",consume = 264,attr = [{1,4386},{2,87720},{3,2241},{4,2241},{15,2241},{16,2145}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(215) ->
	#base_star_map{star_map_id = 215,cons_id = 3,class_id = 7,point_id = 6,cons_name = "双子座",consume = 269,attr = [{1,4386},{2,87720},{3,2241},{4,2241},{15,2241},{16,2241}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(216) ->
	#base_star_map{star_map_id = 216,cons_id = 3,class_id = 7,point_id = 7,cons_name = "双子座",consume = 274,attr = [{1,4386},{2,89640},{3,2241},{4,2241},{15,2241},{16,2241}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(217) ->
	#base_star_map{star_map_id = 217,cons_id = 3,class_id = 7,point_id = 8,cons_name = "双子座",consume = 279,attr = [{1,4482},{2,89640},{3,2241},{4,2241},{15,2241},{16,2241}],extra_attr = [{15,2241},{16,2241},{68,5400}]};

get_starmap_cfg(218) ->
	#base_star_map{star_map_id = 218,cons_id = 3,class_id = 8,point_id = 1,cons_name = "双子座",consume = 253,attr = [{1,4579},{2,89640},{3,2241},{4,2241},{15,2241},{16,2241}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(219) ->
	#base_star_map{star_map_id = 219,cons_id = 3,class_id = 8,point_id = 2,cons_name = "双子座",consume = 258,attr = [{1,4579},{2,91580},{3,2241},{4,2241},{15,2241},{16,2241}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(220) ->
	#base_star_map{star_map_id = 220,cons_id = 3,class_id = 8,point_id = 3,cons_name = "双子座",consume = 263,attr = [{1,4579},{2,91580},{3,2338},{4,2241},{15,2241},{16,2241}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(221) ->
	#base_star_map{star_map_id = 221,cons_id = 3,class_id = 8,point_id = 4,cons_name = "双子座",consume = 268,attr = [{1,4579},{2,91580},{3,2338},{4,2338},{15,2241},{16,2241}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(222) ->
	#base_star_map{star_map_id = 222,cons_id = 3,class_id = 8,point_id = 5,cons_name = "双子座",consume = 273,attr = [{1,4579},{2,91580},{3,2338},{4,2338},{15,2338},{16,2241}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(223) ->
	#base_star_map{star_map_id = 223,cons_id = 3,class_id = 8,point_id = 6,cons_name = "双子座",consume = 278,attr = [{1,4579},{2,91580},{3,2338},{4,2338},{15,2338},{16,2338}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(224) ->
	#base_star_map{star_map_id = 224,cons_id = 3,class_id = 8,point_id = 7,cons_name = "双子座",consume = 283,attr = [{1,4579},{2,93520},{3,2338},{4,2338},{15,2338},{16,2338}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(225) ->
	#base_star_map{star_map_id = 225,cons_id = 3,class_id = 8,point_id = 8,cons_name = "双子座",consume = 288,attr = [{1,4676},{2,93520},{3,2338},{4,2338},{15,2338},{16,2338}],extra_attr = [{15,2338},{16,2338},{68,5600}]};

get_starmap_cfg(226) ->
	#base_star_map{star_map_id = 226,cons_id = 3,class_id = 9,point_id = 1,cons_name = "双子座",consume = 262,attr = [{1,4774},{2,93520},{3,2338},{4,2338},{15,2338},{16,2338}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(227) ->
	#base_star_map{star_map_id = 227,cons_id = 3,class_id = 9,point_id = 2,cons_name = "双子座",consume = 267,attr = [{1,4774},{2,95480},{3,2338},{4,2338},{15,2338},{16,2338}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(228) ->
	#base_star_map{star_map_id = 228,cons_id = 3,class_id = 9,point_id = 3,cons_name = "双子座",consume = 272,attr = [{1,4774},{2,95480},{3,2436},{4,2338},{15,2338},{16,2338}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(229) ->
	#base_star_map{star_map_id = 229,cons_id = 3,class_id = 9,point_id = 4,cons_name = "双子座",consume = 277,attr = [{1,4774},{2,95480},{3,2436},{4,2436},{15,2338},{16,2338}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(230) ->
	#base_star_map{star_map_id = 230,cons_id = 3,class_id = 9,point_id = 5,cons_name = "双子座",consume = 282,attr = [{1,4774},{2,95480},{3,2436},{4,2436},{15,2436},{16,2338}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(231) ->
	#base_star_map{star_map_id = 231,cons_id = 3,class_id = 9,point_id = 6,cons_name = "双子座",consume = 287,attr = [{1,4774},{2,95480},{3,2436},{4,2436},{15,2436},{16,2436}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(232) ->
	#base_star_map{star_map_id = 232,cons_id = 3,class_id = 9,point_id = 7,cons_name = "双子座",consume = 292,attr = [{1,4774},{2,97440},{3,2436},{4,2436},{15,2436},{16,2436}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(233) ->
	#base_star_map{star_map_id = 233,cons_id = 3,class_id = 9,point_id = 8,cons_name = "双子座",consume = 297,attr = [{1,4872},{2,97440},{3,2436},{4,2436},{15,2436},{16,2436}],extra_attr = [{15,2436},{16,2436},{68,5800}]};

get_starmap_cfg(234) ->
	#base_star_map{star_map_id = 234,cons_id = 3,class_id = 10,point_id = 1,cons_name = "双子座",consume = 271,attr = [{1,4971},{2,97440},{3,2436},{4,2436},{15,2436},{16,2436}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(235) ->
	#base_star_map{star_map_id = 235,cons_id = 3,class_id = 10,point_id = 2,cons_name = "双子座",consume = 276,attr = [{1,4971},{2,99420},{3,2436},{4,2436},{15,2436},{16,2436}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(236) ->
	#base_star_map{star_map_id = 236,cons_id = 3,class_id = 10,point_id = 3,cons_name = "双子座",consume = 281,attr = [{1,4971},{2,99420},{3,2535},{4,2436},{15,2436},{16,2436}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(237) ->
	#base_star_map{star_map_id = 237,cons_id = 3,class_id = 10,point_id = 4,cons_name = "双子座",consume = 286,attr = [{1,4971},{2,99420},{3,2535},{4,2535},{15,2436},{16,2436}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(238) ->
	#base_star_map{star_map_id = 238,cons_id = 3,class_id = 10,point_id = 5,cons_name = "双子座",consume = 291,attr = [{1,4971},{2,99420},{3,2535},{4,2535},{15,2535},{16,2436}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(239) ->
	#base_star_map{star_map_id = 239,cons_id = 3,class_id = 10,point_id = 6,cons_name = "双子座",consume = 296,attr = [{1,4971},{2,99420},{3,2535},{4,2535},{15,2535},{16,2535}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(240) ->
	#base_star_map{star_map_id = 240,cons_id = 3,class_id = 10,point_id = 7,cons_name = "双子座",consume = 301,attr = [{1,4971},{2,101400},{3,2535},{4,2535},{15,2535},{16,2535}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(241) ->
	#base_star_map{star_map_id = 241,cons_id = 3,class_id = 10,point_id = 8,cons_name = "双子座",consume = 306,attr = [{1,5070},{2,101400},{3,2535},{4,2535},{15,2535},{16,2535}],extra_attr = [{15,2535},{16,2535},{68,6000}]};

get_starmap_cfg(242) ->
	#base_star_map{star_map_id = 242,cons_id = 4,class_id = 1,point_id = 1,cons_name = "巨蟹座",consume = 280,attr = [{1,5170},{2,101400},{3,2535},{4,2535},{15,2535},{16,2535}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(243) ->
	#base_star_map{star_map_id = 243,cons_id = 4,class_id = 1,point_id = 2,cons_name = "巨蟹座",consume = 285,attr = [{1,5170},{2,103400},{3,2535},{4,2535},{15,2535},{16,2535}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(244) ->
	#base_star_map{star_map_id = 244,cons_id = 4,class_id = 1,point_id = 3,cons_name = "巨蟹座",consume = 290,attr = [{1,5170},{2,103400},{3,2635},{4,2535},{15,2535},{16,2535}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(245) ->
	#base_star_map{star_map_id = 245,cons_id = 4,class_id = 1,point_id = 4,cons_name = "巨蟹座",consume = 295,attr = [{1,5170},{2,103400},{3,2635},{4,2635},{15,2535},{16,2535}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(246) ->
	#base_star_map{star_map_id = 246,cons_id = 4,class_id = 1,point_id = 5,cons_name = "巨蟹座",consume = 300,attr = [{1,5170},{2,103400},{3,2635},{4,2635},{15,2635},{16,2535}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(247) ->
	#base_star_map{star_map_id = 247,cons_id = 4,class_id = 1,point_id = 6,cons_name = "巨蟹座",consume = 305,attr = [{1,5170},{2,103400},{3,2635},{4,2635},{15,2635},{16,2635}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(248) ->
	#base_star_map{star_map_id = 248,cons_id = 4,class_id = 1,point_id = 7,cons_name = "巨蟹座",consume = 310,attr = [{1,5170},{2,105400},{3,2635},{4,2635},{15,2635},{16,2635}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(249) ->
	#base_star_map{star_map_id = 249,cons_id = 4,class_id = 1,point_id = 8,cons_name = "巨蟹座",consume = 315,attr = [{1,5270},{2,105400},{3,2635},{4,2635},{15,2635},{16,2635}],extra_attr = [{15,2635},{16,2635},{68,6200}]};

get_starmap_cfg(250) ->
	#base_star_map{star_map_id = 250,cons_id = 4,class_id = 2,point_id = 1,cons_name = "巨蟹座",consume = 289,attr = [{1,5371},{2,105400},{3,2635},{4,2635},{15,2635},{16,2635}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(251) ->
	#base_star_map{star_map_id = 251,cons_id = 4,class_id = 2,point_id = 2,cons_name = "巨蟹座",consume = 294,attr = [{1,5371},{2,107420},{3,2635},{4,2635},{15,2635},{16,2635}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(252) ->
	#base_star_map{star_map_id = 252,cons_id = 4,class_id = 2,point_id = 3,cons_name = "巨蟹座",consume = 299,attr = [{1,5371},{2,107420},{3,2736},{4,2635},{15,2635},{16,2635}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(253) ->
	#base_star_map{star_map_id = 253,cons_id = 4,class_id = 2,point_id = 4,cons_name = "巨蟹座",consume = 304,attr = [{1,5371},{2,107420},{3,2736},{4,2736},{15,2635},{16,2635}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(254) ->
	#base_star_map{star_map_id = 254,cons_id = 4,class_id = 2,point_id = 5,cons_name = "巨蟹座",consume = 309,attr = [{1,5371},{2,107420},{3,2736},{4,2736},{15,2736},{16,2635}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(255) ->
	#base_star_map{star_map_id = 255,cons_id = 4,class_id = 2,point_id = 6,cons_name = "巨蟹座",consume = 314,attr = [{1,5371},{2,107420},{3,2736},{4,2736},{15,2736},{16,2736}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(256) ->
	#base_star_map{star_map_id = 256,cons_id = 4,class_id = 2,point_id = 7,cons_name = "巨蟹座",consume = 319,attr = [{1,5371},{2,109440},{3,2736},{4,2736},{15,2736},{16,2736}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(257) ->
	#base_star_map{star_map_id = 257,cons_id = 4,class_id = 2,point_id = 8,cons_name = "巨蟹座",consume = 324,attr = [{1,5472},{2,109440},{3,2736},{4,2736},{15,2736},{16,2736}],extra_attr = [{15,2736},{16,2736},{68,6400}]};

get_starmap_cfg(258) ->
	#base_star_map{star_map_id = 258,cons_id = 4,class_id = 3,point_id = 1,cons_name = "巨蟹座",consume = 298,attr = [{1,5574},{2,109440},{3,2736},{4,2736},{15,2736},{16,2736}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(259) ->
	#base_star_map{star_map_id = 259,cons_id = 4,class_id = 3,point_id = 2,cons_name = "巨蟹座",consume = 303,attr = [{1,5574},{2,111480},{3,2736},{4,2736},{15,2736},{16,2736}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(260) ->
	#base_star_map{star_map_id = 260,cons_id = 4,class_id = 3,point_id = 3,cons_name = "巨蟹座",consume = 308,attr = [{1,5574},{2,111480},{3,2838},{4,2736},{15,2736},{16,2736}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(261) ->
	#base_star_map{star_map_id = 261,cons_id = 4,class_id = 3,point_id = 4,cons_name = "巨蟹座",consume = 313,attr = [{1,5574},{2,111480},{3,2838},{4,2838},{15,2736},{16,2736}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(262) ->
	#base_star_map{star_map_id = 262,cons_id = 4,class_id = 3,point_id = 5,cons_name = "巨蟹座",consume = 318,attr = [{1,5574},{2,111480},{3,2838},{4,2838},{15,2838},{16,2736}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(263) ->
	#base_star_map{star_map_id = 263,cons_id = 4,class_id = 3,point_id = 6,cons_name = "巨蟹座",consume = 323,attr = [{1,5574},{2,111480},{3,2838},{4,2838},{15,2838},{16,2838}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(264) ->
	#base_star_map{star_map_id = 264,cons_id = 4,class_id = 3,point_id = 7,cons_name = "巨蟹座",consume = 328,attr = [{1,5574},{2,113520},{3,2838},{4,2838},{15,2838},{16,2838}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(265) ->
	#base_star_map{star_map_id = 265,cons_id = 4,class_id = 3,point_id = 8,cons_name = "巨蟹座",consume = 333,attr = [{1,5676},{2,113520},{3,2838},{4,2838},{15,2838},{16,2838}],extra_attr = [{15,2838},{16,2838},{68,6600}]};

get_starmap_cfg(266) ->
	#base_star_map{star_map_id = 266,cons_id = 4,class_id = 4,point_id = 1,cons_name = "巨蟹座",consume = 307,attr = [{1,5779},{2,113520},{3,2838},{4,2838},{15,2838},{16,2838}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(267) ->
	#base_star_map{star_map_id = 267,cons_id = 4,class_id = 4,point_id = 2,cons_name = "巨蟹座",consume = 312,attr = [{1,5779},{2,115580},{3,2838},{4,2838},{15,2838},{16,2838}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(268) ->
	#base_star_map{star_map_id = 268,cons_id = 4,class_id = 4,point_id = 3,cons_name = "巨蟹座",consume = 317,attr = [{1,5779},{2,115580},{3,2941},{4,2838},{15,2838},{16,2838}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(269) ->
	#base_star_map{star_map_id = 269,cons_id = 4,class_id = 4,point_id = 4,cons_name = "巨蟹座",consume = 322,attr = [{1,5779},{2,115580},{3,2941},{4,2941},{15,2838},{16,2838}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(270) ->
	#base_star_map{star_map_id = 270,cons_id = 4,class_id = 4,point_id = 5,cons_name = "巨蟹座",consume = 327,attr = [{1,5779},{2,115580},{3,2941},{4,2941},{15,2941},{16,2838}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(271) ->
	#base_star_map{star_map_id = 271,cons_id = 4,class_id = 4,point_id = 6,cons_name = "巨蟹座",consume = 332,attr = [{1,5779},{2,115580},{3,2941},{4,2941},{15,2941},{16,2941}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(272) ->
	#base_star_map{star_map_id = 272,cons_id = 4,class_id = 4,point_id = 7,cons_name = "巨蟹座",consume = 337,attr = [{1,5779},{2,117640},{3,2941},{4,2941},{15,2941},{16,2941}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(273) ->
	#base_star_map{star_map_id = 273,cons_id = 4,class_id = 4,point_id = 8,cons_name = "巨蟹座",consume = 342,attr = [{1,5882},{2,117640},{3,2941},{4,2941},{15,2941},{16,2941}],extra_attr = [{15,2941},{16,2941},{68,6800}]};

get_starmap_cfg(274) ->
	#base_star_map{star_map_id = 274,cons_id = 4,class_id = 5,point_id = 1,cons_name = "巨蟹座",consume = 316,attr = [{1,5986},{2,117640},{3,2941},{4,2941},{15,2941},{16,2941}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(275) ->
	#base_star_map{star_map_id = 275,cons_id = 4,class_id = 5,point_id = 2,cons_name = "巨蟹座",consume = 321,attr = [{1,5986},{2,119720},{3,2941},{4,2941},{15,2941},{16,2941}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(276) ->
	#base_star_map{star_map_id = 276,cons_id = 4,class_id = 5,point_id = 3,cons_name = "巨蟹座",consume = 326,attr = [{1,5986},{2,119720},{3,3045},{4,2941},{15,2941},{16,2941}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(277) ->
	#base_star_map{star_map_id = 277,cons_id = 4,class_id = 5,point_id = 4,cons_name = "巨蟹座",consume = 331,attr = [{1,5986},{2,119720},{3,3045},{4,3045},{15,2941},{16,2941}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(278) ->
	#base_star_map{star_map_id = 278,cons_id = 4,class_id = 5,point_id = 5,cons_name = "巨蟹座",consume = 336,attr = [{1,5986},{2,119720},{3,3045},{4,3045},{15,3045},{16,2941}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(279) ->
	#base_star_map{star_map_id = 279,cons_id = 4,class_id = 5,point_id = 6,cons_name = "巨蟹座",consume = 341,attr = [{1,5986},{2,119720},{3,3045},{4,3045},{15,3045},{16,3045}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(280) ->
	#base_star_map{star_map_id = 280,cons_id = 4,class_id = 5,point_id = 7,cons_name = "巨蟹座",consume = 346,attr = [{1,5986},{2,121800},{3,3045},{4,3045},{15,3045},{16,3045}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(281) ->
	#base_star_map{star_map_id = 281,cons_id = 4,class_id = 5,point_id = 8,cons_name = "巨蟹座",consume = 351,attr = [{1,6090},{2,121800},{3,3045},{4,3045},{15,3045},{16,3045}],extra_attr = [{15,3045},{16,3045},{68,7000}]};

get_starmap_cfg(282) ->
	#base_star_map{star_map_id = 282,cons_id = 4,class_id = 6,point_id = 1,cons_name = "巨蟹座",consume = 325,attr = [{1,6195},{2,121800},{3,3045},{4,3045},{15,3045},{16,3045}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(283) ->
	#base_star_map{star_map_id = 283,cons_id = 4,class_id = 6,point_id = 2,cons_name = "巨蟹座",consume = 330,attr = [{1,6195},{2,123900},{3,3045},{4,3045},{15,3045},{16,3045}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(284) ->
	#base_star_map{star_map_id = 284,cons_id = 4,class_id = 6,point_id = 3,cons_name = "巨蟹座",consume = 335,attr = [{1,6195},{2,123900},{3,3150},{4,3045},{15,3045},{16,3045}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(285) ->
	#base_star_map{star_map_id = 285,cons_id = 4,class_id = 6,point_id = 4,cons_name = "巨蟹座",consume = 340,attr = [{1,6195},{2,123900},{3,3150},{4,3150},{15,3045},{16,3045}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(286) ->
	#base_star_map{star_map_id = 286,cons_id = 4,class_id = 6,point_id = 5,cons_name = "巨蟹座",consume = 345,attr = [{1,6195},{2,123900},{3,3150},{4,3150},{15,3150},{16,3045}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(287) ->
	#base_star_map{star_map_id = 287,cons_id = 4,class_id = 6,point_id = 6,cons_name = "巨蟹座",consume = 350,attr = [{1,6195},{2,123900},{3,3150},{4,3150},{15,3150},{16,3150}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(288) ->
	#base_star_map{star_map_id = 288,cons_id = 4,class_id = 6,point_id = 7,cons_name = "巨蟹座",consume = 355,attr = [{1,6195},{2,126000},{3,3150},{4,3150},{15,3150},{16,3150}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(289) ->
	#base_star_map{star_map_id = 289,cons_id = 4,class_id = 6,point_id = 8,cons_name = "巨蟹座",consume = 360,attr = [{1,6300},{2,126000},{3,3150},{4,3150},{15,3150},{16,3150}],extra_attr = [{15,3150},{16,3150},{68,7200}]};

get_starmap_cfg(290) ->
	#base_star_map{star_map_id = 290,cons_id = 4,class_id = 7,point_id = 1,cons_name = "巨蟹座",consume = 334,attr = [{1,6406},{2,126000},{3,3150},{4,3150},{15,3150},{16,3150}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(291) ->
	#base_star_map{star_map_id = 291,cons_id = 4,class_id = 7,point_id = 2,cons_name = "巨蟹座",consume = 339,attr = [{1,6406},{2,128120},{3,3150},{4,3150},{15,3150},{16,3150}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(292) ->
	#base_star_map{star_map_id = 292,cons_id = 4,class_id = 7,point_id = 3,cons_name = "巨蟹座",consume = 344,attr = [{1,6406},{2,128120},{3,3256},{4,3150},{15,3150},{16,3150}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(293) ->
	#base_star_map{star_map_id = 293,cons_id = 4,class_id = 7,point_id = 4,cons_name = "巨蟹座",consume = 349,attr = [{1,6406},{2,128120},{3,3256},{4,3256},{15,3150},{16,3150}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(294) ->
	#base_star_map{star_map_id = 294,cons_id = 4,class_id = 7,point_id = 5,cons_name = "巨蟹座",consume = 354,attr = [{1,6406},{2,128120},{3,3256},{4,3256},{15,3256},{16,3150}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(295) ->
	#base_star_map{star_map_id = 295,cons_id = 4,class_id = 7,point_id = 6,cons_name = "巨蟹座",consume = 359,attr = [{1,6406},{2,128120},{3,3256},{4,3256},{15,3256},{16,3256}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(296) ->
	#base_star_map{star_map_id = 296,cons_id = 4,class_id = 7,point_id = 7,cons_name = "巨蟹座",consume = 364,attr = [{1,6406},{2,130240},{3,3256},{4,3256},{15,3256},{16,3256}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(297) ->
	#base_star_map{star_map_id = 297,cons_id = 4,class_id = 7,point_id = 8,cons_name = "巨蟹座",consume = 369,attr = [{1,6512},{2,130240},{3,3256},{4,3256},{15,3256},{16,3256}],extra_attr = [{15,3256},{16,3256},{68,7400}]};

get_starmap_cfg(298) ->
	#base_star_map{star_map_id = 298,cons_id = 4,class_id = 8,point_id = 1,cons_name = "巨蟹座",consume = 343,attr = [{1,6619},{2,130240},{3,3256},{4,3256},{15,3256},{16,3256}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(299) ->
	#base_star_map{star_map_id = 299,cons_id = 4,class_id = 8,point_id = 2,cons_name = "巨蟹座",consume = 348,attr = [{1,6619},{2,132380},{3,3256},{4,3256},{15,3256},{16,3256}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(300) ->
	#base_star_map{star_map_id = 300,cons_id = 4,class_id = 8,point_id = 3,cons_name = "巨蟹座",consume = 353,attr = [{1,6619},{2,132380},{3,3363},{4,3256},{15,3256},{16,3256}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(301) ->
	#base_star_map{star_map_id = 301,cons_id = 4,class_id = 8,point_id = 4,cons_name = "巨蟹座",consume = 358,attr = [{1,6619},{2,132380},{3,3363},{4,3363},{15,3256},{16,3256}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(302) ->
	#base_star_map{star_map_id = 302,cons_id = 4,class_id = 8,point_id = 5,cons_name = "巨蟹座",consume = 363,attr = [{1,6619},{2,132380},{3,3363},{4,3363},{15,3363},{16,3256}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(303) ->
	#base_star_map{star_map_id = 303,cons_id = 4,class_id = 8,point_id = 6,cons_name = "巨蟹座",consume = 368,attr = [{1,6619},{2,132380},{3,3363},{4,3363},{15,3363},{16,3363}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(304) ->
	#base_star_map{star_map_id = 304,cons_id = 4,class_id = 8,point_id = 7,cons_name = "巨蟹座",consume = 373,attr = [{1,6619},{2,134520},{3,3363},{4,3363},{15,3363},{16,3363}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(305) ->
	#base_star_map{star_map_id = 305,cons_id = 4,class_id = 8,point_id = 8,cons_name = "巨蟹座",consume = 378,attr = [{1,6726},{2,134520},{3,3363},{4,3363},{15,3363},{16,3363}],extra_attr = [{15,3363},{16,3363},{68,7600}]};

get_starmap_cfg(306) ->
	#base_star_map{star_map_id = 306,cons_id = 4,class_id = 9,point_id = 1,cons_name = "巨蟹座",consume = 352,attr = [{1,6834},{2,134520},{3,3363},{4,3363},{15,3363},{16,3363}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(307) ->
	#base_star_map{star_map_id = 307,cons_id = 4,class_id = 9,point_id = 2,cons_name = "巨蟹座",consume = 357,attr = [{1,6834},{2,136680},{3,3363},{4,3363},{15,3363},{16,3363}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(308) ->
	#base_star_map{star_map_id = 308,cons_id = 4,class_id = 9,point_id = 3,cons_name = "巨蟹座",consume = 362,attr = [{1,6834},{2,136680},{3,3471},{4,3363},{15,3363},{16,3363}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(309) ->
	#base_star_map{star_map_id = 309,cons_id = 4,class_id = 9,point_id = 4,cons_name = "巨蟹座",consume = 367,attr = [{1,6834},{2,136680},{3,3471},{4,3471},{15,3363},{16,3363}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(310) ->
	#base_star_map{star_map_id = 310,cons_id = 4,class_id = 9,point_id = 5,cons_name = "巨蟹座",consume = 372,attr = [{1,6834},{2,136680},{3,3471},{4,3471},{15,3471},{16,3363}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(311) ->
	#base_star_map{star_map_id = 311,cons_id = 4,class_id = 9,point_id = 6,cons_name = "巨蟹座",consume = 377,attr = [{1,6834},{2,136680},{3,3471},{4,3471},{15,3471},{16,3471}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(312) ->
	#base_star_map{star_map_id = 312,cons_id = 4,class_id = 9,point_id = 7,cons_name = "巨蟹座",consume = 382,attr = [{1,6834},{2,138840},{3,3471},{4,3471},{15,3471},{16,3471}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(313) ->
	#base_star_map{star_map_id = 313,cons_id = 4,class_id = 9,point_id = 8,cons_name = "巨蟹座",consume = 387,attr = [{1,6942},{2,138840},{3,3471},{4,3471},{15,3471},{16,3471}],extra_attr = [{15,3471},{16,3471},{68,7800}]};

get_starmap_cfg(314) ->
	#base_star_map{star_map_id = 314,cons_id = 4,class_id = 10,point_id = 1,cons_name = "巨蟹座",consume = 361,attr = [{1,7051},{2,138840},{3,3471},{4,3471},{15,3471},{16,3471}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(315) ->
	#base_star_map{star_map_id = 315,cons_id = 4,class_id = 10,point_id = 2,cons_name = "巨蟹座",consume = 366,attr = [{1,7051},{2,141020},{3,3471},{4,3471},{15,3471},{16,3471}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(316) ->
	#base_star_map{star_map_id = 316,cons_id = 4,class_id = 10,point_id = 3,cons_name = "巨蟹座",consume = 371,attr = [{1,7051},{2,141020},{3,3580},{4,3471},{15,3471},{16,3471}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(317) ->
	#base_star_map{star_map_id = 317,cons_id = 4,class_id = 10,point_id = 4,cons_name = "巨蟹座",consume = 376,attr = [{1,7051},{2,141020},{3,3580},{4,3580},{15,3471},{16,3471}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(318) ->
	#base_star_map{star_map_id = 318,cons_id = 4,class_id = 10,point_id = 5,cons_name = "巨蟹座",consume = 381,attr = [{1,7051},{2,141020},{3,3580},{4,3580},{15,3580},{16,3471}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(319) ->
	#base_star_map{star_map_id = 319,cons_id = 4,class_id = 10,point_id = 6,cons_name = "巨蟹座",consume = 386,attr = [{1,7051},{2,141020},{3,3580},{4,3580},{15,3580},{16,3580}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(320) ->
	#base_star_map{star_map_id = 320,cons_id = 4,class_id = 10,point_id = 7,cons_name = "巨蟹座",consume = 391,attr = [{1,7051},{2,143200},{3,3580},{4,3580},{15,3580},{16,3580}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(321) ->
	#base_star_map{star_map_id = 321,cons_id = 4,class_id = 10,point_id = 8,cons_name = "巨蟹座",consume = 396,attr = [{1,7160},{2,143200},{3,3580},{4,3580},{15,3580},{16,3580}],extra_attr = [{15,3580},{16,3580},{68,8000}]};

get_starmap_cfg(322) ->
	#base_star_map{star_map_id = 322,cons_id = 5,class_id = 1,point_id = 1,cons_name = "狮子座",consume = 370,attr = [{1,7270},{2,143200},{3,3580},{4,3580},{15,3580},{16,3580}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(323) ->
	#base_star_map{star_map_id = 323,cons_id = 5,class_id = 1,point_id = 2,cons_name = "狮子座",consume = 375,attr = [{1,7270},{2,145400},{3,3580},{4,3580},{15,3580},{16,3580}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(324) ->
	#base_star_map{star_map_id = 324,cons_id = 5,class_id = 1,point_id = 3,cons_name = "狮子座",consume = 380,attr = [{1,7270},{2,145400},{3,3690},{4,3580},{15,3580},{16,3580}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(325) ->
	#base_star_map{star_map_id = 325,cons_id = 5,class_id = 1,point_id = 4,cons_name = "狮子座",consume = 385,attr = [{1,7270},{2,145400},{3,3690},{4,3690},{15,3580},{16,3580}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(326) ->
	#base_star_map{star_map_id = 326,cons_id = 5,class_id = 1,point_id = 5,cons_name = "狮子座",consume = 390,attr = [{1,7270},{2,145400},{3,3690},{4,3690},{15,3690},{16,3580}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(327) ->
	#base_star_map{star_map_id = 327,cons_id = 5,class_id = 1,point_id = 6,cons_name = "狮子座",consume = 395,attr = [{1,7270},{2,145400},{3,3690},{4,3690},{15,3690},{16,3690}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(328) ->
	#base_star_map{star_map_id = 328,cons_id = 5,class_id = 1,point_id = 7,cons_name = "狮子座",consume = 400,attr = [{1,7270},{2,147600},{3,3690},{4,3690},{15,3690},{16,3690}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(329) ->
	#base_star_map{star_map_id = 329,cons_id = 5,class_id = 1,point_id = 8,cons_name = "狮子座",consume = 405,attr = [{1,7380},{2,147600},{3,3690},{4,3690},{15,3690},{16,3690}],extra_attr = [{15,3690},{16,3690},{68,8200}]};

get_starmap_cfg(330) ->
	#base_star_map{star_map_id = 330,cons_id = 5,class_id = 2,point_id = 1,cons_name = "狮子座",consume = 379,attr = [{1,7491},{2,147600},{3,3690},{4,3690},{15,3690},{16,3690}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(331) ->
	#base_star_map{star_map_id = 331,cons_id = 5,class_id = 2,point_id = 2,cons_name = "狮子座",consume = 384,attr = [{1,7491},{2,149820},{3,3690},{4,3690},{15,3690},{16,3690}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(332) ->
	#base_star_map{star_map_id = 332,cons_id = 5,class_id = 2,point_id = 3,cons_name = "狮子座",consume = 389,attr = [{1,7491},{2,149820},{3,3801},{4,3690},{15,3690},{16,3690}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(333) ->
	#base_star_map{star_map_id = 333,cons_id = 5,class_id = 2,point_id = 4,cons_name = "狮子座",consume = 394,attr = [{1,7491},{2,149820},{3,3801},{4,3801},{15,3690},{16,3690}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(334) ->
	#base_star_map{star_map_id = 334,cons_id = 5,class_id = 2,point_id = 5,cons_name = "狮子座",consume = 399,attr = [{1,7491},{2,149820},{3,3801},{4,3801},{15,3801},{16,3690}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(335) ->
	#base_star_map{star_map_id = 335,cons_id = 5,class_id = 2,point_id = 6,cons_name = "狮子座",consume = 404,attr = [{1,7491},{2,149820},{3,3801},{4,3801},{15,3801},{16,3801}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(336) ->
	#base_star_map{star_map_id = 336,cons_id = 5,class_id = 2,point_id = 7,cons_name = "狮子座",consume = 409,attr = [{1,7491},{2,152040},{3,3801},{4,3801},{15,3801},{16,3801}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(337) ->
	#base_star_map{star_map_id = 337,cons_id = 5,class_id = 2,point_id = 8,cons_name = "狮子座",consume = 414,attr = [{1,7602},{2,152040},{3,3801},{4,3801},{15,3801},{16,3801}],extra_attr = [{15,3801},{16,3801},{68,8400}]};

get_starmap_cfg(338) ->
	#base_star_map{star_map_id = 338,cons_id = 5,class_id = 3,point_id = 1,cons_name = "狮子座",consume = 388,attr = [{1,7714},{2,152040},{3,3801},{4,3801},{15,3801},{16,3801}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(339) ->
	#base_star_map{star_map_id = 339,cons_id = 5,class_id = 3,point_id = 2,cons_name = "狮子座",consume = 393,attr = [{1,7714},{2,154280},{3,3801},{4,3801},{15,3801},{16,3801}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(340) ->
	#base_star_map{star_map_id = 340,cons_id = 5,class_id = 3,point_id = 3,cons_name = "狮子座",consume = 398,attr = [{1,7714},{2,154280},{3,3913},{4,3801},{15,3801},{16,3801}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(341) ->
	#base_star_map{star_map_id = 341,cons_id = 5,class_id = 3,point_id = 4,cons_name = "狮子座",consume = 403,attr = [{1,7714},{2,154280},{3,3913},{4,3913},{15,3801},{16,3801}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(342) ->
	#base_star_map{star_map_id = 342,cons_id = 5,class_id = 3,point_id = 5,cons_name = "狮子座",consume = 408,attr = [{1,7714},{2,154280},{3,3913},{4,3913},{15,3913},{16,3801}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(343) ->
	#base_star_map{star_map_id = 343,cons_id = 5,class_id = 3,point_id = 6,cons_name = "狮子座",consume = 413,attr = [{1,7714},{2,154280},{3,3913},{4,3913},{15,3913},{16,3913}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(344) ->
	#base_star_map{star_map_id = 344,cons_id = 5,class_id = 3,point_id = 7,cons_name = "狮子座",consume = 418,attr = [{1,7714},{2,156520},{3,3913},{4,3913},{15,3913},{16,3913}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(345) ->
	#base_star_map{star_map_id = 345,cons_id = 5,class_id = 3,point_id = 8,cons_name = "狮子座",consume = 423,attr = [{1,7826},{2,156520},{3,3913},{4,3913},{15,3913},{16,3913}],extra_attr = [{15,3913},{16,3913},{68,8600}]};

get_starmap_cfg(346) ->
	#base_star_map{star_map_id = 346,cons_id = 5,class_id = 4,point_id = 1,cons_name = "狮子座",consume = 397,attr = [{1,7939},{2,156520},{3,3913},{4,3913},{15,3913},{16,3913}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(347) ->
	#base_star_map{star_map_id = 347,cons_id = 5,class_id = 4,point_id = 2,cons_name = "狮子座",consume = 402,attr = [{1,7939},{2,158780},{3,3913},{4,3913},{15,3913},{16,3913}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(348) ->
	#base_star_map{star_map_id = 348,cons_id = 5,class_id = 4,point_id = 3,cons_name = "狮子座",consume = 407,attr = [{1,7939},{2,158780},{3,4026},{4,3913},{15,3913},{16,3913}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(349) ->
	#base_star_map{star_map_id = 349,cons_id = 5,class_id = 4,point_id = 4,cons_name = "狮子座",consume = 412,attr = [{1,7939},{2,158780},{3,4026},{4,4026},{15,3913},{16,3913}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(350) ->
	#base_star_map{star_map_id = 350,cons_id = 5,class_id = 4,point_id = 5,cons_name = "狮子座",consume = 417,attr = [{1,7939},{2,158780},{3,4026},{4,4026},{15,4026},{16,3913}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(351) ->
	#base_star_map{star_map_id = 351,cons_id = 5,class_id = 4,point_id = 6,cons_name = "狮子座",consume = 422,attr = [{1,7939},{2,158780},{3,4026},{4,4026},{15,4026},{16,4026}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(352) ->
	#base_star_map{star_map_id = 352,cons_id = 5,class_id = 4,point_id = 7,cons_name = "狮子座",consume = 427,attr = [{1,7939},{2,161040},{3,4026},{4,4026},{15,4026},{16,4026}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(353) ->
	#base_star_map{star_map_id = 353,cons_id = 5,class_id = 4,point_id = 8,cons_name = "狮子座",consume = 432,attr = [{1,8052},{2,161040},{3,4026},{4,4026},{15,4026},{16,4026}],extra_attr = [{15,4026},{16,4026},{68,8800}]};

get_starmap_cfg(354) ->
	#base_star_map{star_map_id = 354,cons_id = 5,class_id = 5,point_id = 1,cons_name = "狮子座",consume = 406,attr = [{1,8166},{2,161040},{3,4026},{4,4026},{15,4026},{16,4026}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(355) ->
	#base_star_map{star_map_id = 355,cons_id = 5,class_id = 5,point_id = 2,cons_name = "狮子座",consume = 411,attr = [{1,8166},{2,163320},{3,4026},{4,4026},{15,4026},{16,4026}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(356) ->
	#base_star_map{star_map_id = 356,cons_id = 5,class_id = 5,point_id = 3,cons_name = "狮子座",consume = 416,attr = [{1,8166},{2,163320},{3,4140},{4,4026},{15,4026},{16,4026}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(357) ->
	#base_star_map{star_map_id = 357,cons_id = 5,class_id = 5,point_id = 4,cons_name = "狮子座",consume = 421,attr = [{1,8166},{2,163320},{3,4140},{4,4140},{15,4026},{16,4026}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(358) ->
	#base_star_map{star_map_id = 358,cons_id = 5,class_id = 5,point_id = 5,cons_name = "狮子座",consume = 426,attr = [{1,8166},{2,163320},{3,4140},{4,4140},{15,4140},{16,4026}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(359) ->
	#base_star_map{star_map_id = 359,cons_id = 5,class_id = 5,point_id = 6,cons_name = "狮子座",consume = 431,attr = [{1,8166},{2,163320},{3,4140},{4,4140},{15,4140},{16,4140}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(360) ->
	#base_star_map{star_map_id = 360,cons_id = 5,class_id = 5,point_id = 7,cons_name = "狮子座",consume = 436,attr = [{1,8166},{2,165600},{3,4140},{4,4140},{15,4140},{16,4140}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(361) ->
	#base_star_map{star_map_id = 361,cons_id = 5,class_id = 5,point_id = 8,cons_name = "狮子座",consume = 441,attr = [{1,8280},{2,165600},{3,4140},{4,4140},{15,4140},{16,4140}],extra_attr = [{15,4140},{16,4140},{68,9000}]};

get_starmap_cfg(362) ->
	#base_star_map{star_map_id = 362,cons_id = 5,class_id = 6,point_id = 1,cons_name = "狮子座",consume = 415,attr = [{1,8395},{2,165600},{3,4140},{4,4140},{15,4140},{16,4140}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(363) ->
	#base_star_map{star_map_id = 363,cons_id = 5,class_id = 6,point_id = 2,cons_name = "狮子座",consume = 420,attr = [{1,8395},{2,167900},{3,4140},{4,4140},{15,4140},{16,4140}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(364) ->
	#base_star_map{star_map_id = 364,cons_id = 5,class_id = 6,point_id = 3,cons_name = "狮子座",consume = 425,attr = [{1,8395},{2,167900},{3,4255},{4,4140},{15,4140},{16,4140}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(365) ->
	#base_star_map{star_map_id = 365,cons_id = 5,class_id = 6,point_id = 4,cons_name = "狮子座",consume = 430,attr = [{1,8395},{2,167900},{3,4255},{4,4255},{15,4140},{16,4140}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(366) ->
	#base_star_map{star_map_id = 366,cons_id = 5,class_id = 6,point_id = 5,cons_name = "狮子座",consume = 435,attr = [{1,8395},{2,167900},{3,4255},{4,4255},{15,4255},{16,4140}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(367) ->
	#base_star_map{star_map_id = 367,cons_id = 5,class_id = 6,point_id = 6,cons_name = "狮子座",consume = 440,attr = [{1,8395},{2,167900},{3,4255},{4,4255},{15,4255},{16,4255}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(368) ->
	#base_star_map{star_map_id = 368,cons_id = 5,class_id = 6,point_id = 7,cons_name = "狮子座",consume = 445,attr = [{1,8395},{2,170200},{3,4255},{4,4255},{15,4255},{16,4255}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(369) ->
	#base_star_map{star_map_id = 369,cons_id = 5,class_id = 6,point_id = 8,cons_name = "狮子座",consume = 450,attr = [{1,8510},{2,170200},{3,4255},{4,4255},{15,4255},{16,4255}],extra_attr = [{15,4255},{16,4255},{68,9200}]};

get_starmap_cfg(370) ->
	#base_star_map{star_map_id = 370,cons_id = 5,class_id = 7,point_id = 1,cons_name = "狮子座",consume = 424,attr = [{1,8626},{2,170200},{3,4255},{4,4255},{15,4255},{16,4255}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(371) ->
	#base_star_map{star_map_id = 371,cons_id = 5,class_id = 7,point_id = 2,cons_name = "狮子座",consume = 429,attr = [{1,8626},{2,172520},{3,4255},{4,4255},{15,4255},{16,4255}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(372) ->
	#base_star_map{star_map_id = 372,cons_id = 5,class_id = 7,point_id = 3,cons_name = "狮子座",consume = 434,attr = [{1,8626},{2,172520},{3,4371},{4,4255},{15,4255},{16,4255}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(373) ->
	#base_star_map{star_map_id = 373,cons_id = 5,class_id = 7,point_id = 4,cons_name = "狮子座",consume = 439,attr = [{1,8626},{2,172520},{3,4371},{4,4371},{15,4255},{16,4255}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(374) ->
	#base_star_map{star_map_id = 374,cons_id = 5,class_id = 7,point_id = 5,cons_name = "狮子座",consume = 444,attr = [{1,8626},{2,172520},{3,4371},{4,4371},{15,4371},{16,4255}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(375) ->
	#base_star_map{star_map_id = 375,cons_id = 5,class_id = 7,point_id = 6,cons_name = "狮子座",consume = 449,attr = [{1,8626},{2,172520},{3,4371},{4,4371},{15,4371},{16,4371}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(376) ->
	#base_star_map{star_map_id = 376,cons_id = 5,class_id = 7,point_id = 7,cons_name = "狮子座",consume = 454,attr = [{1,8626},{2,174840},{3,4371},{4,4371},{15,4371},{16,4371}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(377) ->
	#base_star_map{star_map_id = 377,cons_id = 5,class_id = 7,point_id = 8,cons_name = "狮子座",consume = 459,attr = [{1,8742},{2,174840},{3,4371},{4,4371},{15,4371},{16,4371}],extra_attr = [{15,4371},{16,4371},{68,9400}]};

get_starmap_cfg(378) ->
	#base_star_map{star_map_id = 378,cons_id = 5,class_id = 8,point_id = 1,cons_name = "狮子座",consume = 433,attr = [{1,8859},{2,174840},{3,4371},{4,4371},{15,4371},{16,4371}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(379) ->
	#base_star_map{star_map_id = 379,cons_id = 5,class_id = 8,point_id = 2,cons_name = "狮子座",consume = 438,attr = [{1,8859},{2,177180},{3,4371},{4,4371},{15,4371},{16,4371}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(380) ->
	#base_star_map{star_map_id = 380,cons_id = 5,class_id = 8,point_id = 3,cons_name = "狮子座",consume = 443,attr = [{1,8859},{2,177180},{3,4488},{4,4371},{15,4371},{16,4371}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(381) ->
	#base_star_map{star_map_id = 381,cons_id = 5,class_id = 8,point_id = 4,cons_name = "狮子座",consume = 448,attr = [{1,8859},{2,177180},{3,4488},{4,4488},{15,4371},{16,4371}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(382) ->
	#base_star_map{star_map_id = 382,cons_id = 5,class_id = 8,point_id = 5,cons_name = "狮子座",consume = 453,attr = [{1,8859},{2,177180},{3,4488},{4,4488},{15,4488},{16,4371}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(383) ->
	#base_star_map{star_map_id = 383,cons_id = 5,class_id = 8,point_id = 6,cons_name = "狮子座",consume = 458,attr = [{1,8859},{2,177180},{3,4488},{4,4488},{15,4488},{16,4488}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(384) ->
	#base_star_map{star_map_id = 384,cons_id = 5,class_id = 8,point_id = 7,cons_name = "狮子座",consume = 463,attr = [{1,8859},{2,179520},{3,4488},{4,4488},{15,4488},{16,4488}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(385) ->
	#base_star_map{star_map_id = 385,cons_id = 5,class_id = 8,point_id = 8,cons_name = "狮子座",consume = 468,attr = [{1,8976},{2,179520},{3,4488},{4,4488},{15,4488},{16,4488}],extra_attr = [{15,4488},{16,4488},{68,9600}]};

get_starmap_cfg(386) ->
	#base_star_map{star_map_id = 386,cons_id = 5,class_id = 9,point_id = 1,cons_name = "狮子座",consume = 442,attr = [{1,9094},{2,179520},{3,4488},{4,4488},{15,4488},{16,4488}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(387) ->
	#base_star_map{star_map_id = 387,cons_id = 5,class_id = 9,point_id = 2,cons_name = "狮子座",consume = 447,attr = [{1,9094},{2,181880},{3,4488},{4,4488},{15,4488},{16,4488}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(388) ->
	#base_star_map{star_map_id = 388,cons_id = 5,class_id = 9,point_id = 3,cons_name = "狮子座",consume = 452,attr = [{1,9094},{2,181880},{3,4606},{4,4488},{15,4488},{16,4488}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(389) ->
	#base_star_map{star_map_id = 389,cons_id = 5,class_id = 9,point_id = 4,cons_name = "狮子座",consume = 457,attr = [{1,9094},{2,181880},{3,4606},{4,4606},{15,4488},{16,4488}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(390) ->
	#base_star_map{star_map_id = 390,cons_id = 5,class_id = 9,point_id = 5,cons_name = "狮子座",consume = 462,attr = [{1,9094},{2,181880},{3,4606},{4,4606},{15,4606},{16,4488}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(391) ->
	#base_star_map{star_map_id = 391,cons_id = 5,class_id = 9,point_id = 6,cons_name = "狮子座",consume = 467,attr = [{1,9094},{2,181880},{3,4606},{4,4606},{15,4606},{16,4606}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(392) ->
	#base_star_map{star_map_id = 392,cons_id = 5,class_id = 9,point_id = 7,cons_name = "狮子座",consume = 472,attr = [{1,9094},{2,184240},{3,4606},{4,4606},{15,4606},{16,4606}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(393) ->
	#base_star_map{star_map_id = 393,cons_id = 5,class_id = 9,point_id = 8,cons_name = "狮子座",consume = 477,attr = [{1,9212},{2,184240},{3,4606},{4,4606},{15,4606},{16,4606}],extra_attr = [{15,4606},{16,4606},{68,9800}]};

get_starmap_cfg(394) ->
	#base_star_map{star_map_id = 394,cons_id = 5,class_id = 10,point_id = 1,cons_name = "狮子座",consume = 451,attr = [{1,9331},{2,184240},{3,4606},{4,4606},{15,4606},{16,4606}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(395) ->
	#base_star_map{star_map_id = 395,cons_id = 5,class_id = 10,point_id = 2,cons_name = "狮子座",consume = 456,attr = [{1,9331},{2,186620},{3,4606},{4,4606},{15,4606},{16,4606}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(396) ->
	#base_star_map{star_map_id = 396,cons_id = 5,class_id = 10,point_id = 3,cons_name = "狮子座",consume = 461,attr = [{1,9331},{2,186620},{3,4725},{4,4606},{15,4606},{16,4606}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(397) ->
	#base_star_map{star_map_id = 397,cons_id = 5,class_id = 10,point_id = 4,cons_name = "狮子座",consume = 466,attr = [{1,9331},{2,186620},{3,4725},{4,4725},{15,4606},{16,4606}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(398) ->
	#base_star_map{star_map_id = 398,cons_id = 5,class_id = 10,point_id = 5,cons_name = "狮子座",consume = 471,attr = [{1,9331},{2,186620},{3,4725},{4,4725},{15,4725},{16,4606}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(399) ->
	#base_star_map{star_map_id = 399,cons_id = 5,class_id = 10,point_id = 6,cons_name = "狮子座",consume = 476,attr = [{1,9331},{2,186620},{3,4725},{4,4725},{15,4725},{16,4725}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(400) ->
	#base_star_map{star_map_id = 400,cons_id = 5,class_id = 10,point_id = 7,cons_name = "狮子座",consume = 481,attr = [{1,9331},{2,189000},{3,4725},{4,4725},{15,4725},{16,4725}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(401) ->
	#base_star_map{star_map_id = 401,cons_id = 5,class_id = 10,point_id = 8,cons_name = "狮子座",consume = 486,attr = [{1,9450},{2,189000},{3,4725},{4,4725},{15,4725},{16,4725}],extra_attr = [{15,4725},{16,4725},{68,10000}]};

get_starmap_cfg(402) ->
	#base_star_map{star_map_id = 402,cons_id = 6,class_id = 1,point_id = 1,cons_name = "处女座",consume = 460,attr = [{1,9570},{2,189000},{3,4725},{4,4725},{15,4725},{16,4725}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(403) ->
	#base_star_map{star_map_id = 403,cons_id = 6,class_id = 1,point_id = 2,cons_name = "处女座",consume = 465,attr = [{1,9570},{2,191400},{3,4725},{4,4725},{15,4725},{16,4725}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(404) ->
	#base_star_map{star_map_id = 404,cons_id = 6,class_id = 1,point_id = 3,cons_name = "处女座",consume = 470,attr = [{1,9570},{2,191400},{3,4845},{4,4725},{15,4725},{16,4725}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(405) ->
	#base_star_map{star_map_id = 405,cons_id = 6,class_id = 1,point_id = 4,cons_name = "处女座",consume = 475,attr = [{1,9570},{2,191400},{3,4845},{4,4845},{15,4725},{16,4725}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(406) ->
	#base_star_map{star_map_id = 406,cons_id = 6,class_id = 1,point_id = 5,cons_name = "处女座",consume = 480,attr = [{1,9570},{2,191400},{3,4845},{4,4845},{15,4845},{16,4725}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(407) ->
	#base_star_map{star_map_id = 407,cons_id = 6,class_id = 1,point_id = 6,cons_name = "处女座",consume = 485,attr = [{1,9570},{2,191400},{3,4845},{4,4845},{15,4845},{16,4845}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(408) ->
	#base_star_map{star_map_id = 408,cons_id = 6,class_id = 1,point_id = 7,cons_name = "处女座",consume = 490,attr = [{1,9570},{2,193800},{3,4845},{4,4845},{15,4845},{16,4845}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(409) ->
	#base_star_map{star_map_id = 409,cons_id = 6,class_id = 1,point_id = 8,cons_name = "处女座",consume = 495,attr = [{1,9690},{2,193800},{3,4845},{4,4845},{15,4845},{16,4845}],extra_attr = [{15,4845},{16,4845},{68,10200}]};

get_starmap_cfg(410) ->
	#base_star_map{star_map_id = 410,cons_id = 6,class_id = 2,point_id = 1,cons_name = "处女座",consume = 469,attr = [{1,9811},{2,193800},{3,4845},{4,4845},{15,4845},{16,4845}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(411) ->
	#base_star_map{star_map_id = 411,cons_id = 6,class_id = 2,point_id = 2,cons_name = "处女座",consume = 474,attr = [{1,9811},{2,196220},{3,4845},{4,4845},{15,4845},{16,4845}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(412) ->
	#base_star_map{star_map_id = 412,cons_id = 6,class_id = 2,point_id = 3,cons_name = "处女座",consume = 479,attr = [{1,9811},{2,196220},{3,4966},{4,4845},{15,4845},{16,4845}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(413) ->
	#base_star_map{star_map_id = 413,cons_id = 6,class_id = 2,point_id = 4,cons_name = "处女座",consume = 484,attr = [{1,9811},{2,196220},{3,4966},{4,4966},{15,4845},{16,4845}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(414) ->
	#base_star_map{star_map_id = 414,cons_id = 6,class_id = 2,point_id = 5,cons_name = "处女座",consume = 489,attr = [{1,9811},{2,196220},{3,4966},{4,4966},{15,4966},{16,4845}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(415) ->
	#base_star_map{star_map_id = 415,cons_id = 6,class_id = 2,point_id = 6,cons_name = "处女座",consume = 494,attr = [{1,9811},{2,196220},{3,4966},{4,4966},{15,4966},{16,4966}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(416) ->
	#base_star_map{star_map_id = 416,cons_id = 6,class_id = 2,point_id = 7,cons_name = "处女座",consume = 499,attr = [{1,9811},{2,198640},{3,4966},{4,4966},{15,4966},{16,4966}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(417) ->
	#base_star_map{star_map_id = 417,cons_id = 6,class_id = 2,point_id = 8,cons_name = "处女座",consume = 504,attr = [{1,9932},{2,198640},{3,4966},{4,4966},{15,4966},{16,4966}],extra_attr = [{15,4966},{16,4966},{68,10400}]};

get_starmap_cfg(418) ->
	#base_star_map{star_map_id = 418,cons_id = 6,class_id = 3,point_id = 1,cons_name = "处女座",consume = 478,attr = [{1,10054},{2,198640},{3,4966},{4,4966},{15,4966},{16,4966}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(419) ->
	#base_star_map{star_map_id = 419,cons_id = 6,class_id = 3,point_id = 2,cons_name = "处女座",consume = 483,attr = [{1,10054},{2,201080},{3,4966},{4,4966},{15,4966},{16,4966}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(420) ->
	#base_star_map{star_map_id = 420,cons_id = 6,class_id = 3,point_id = 3,cons_name = "处女座",consume = 488,attr = [{1,10054},{2,201080},{3,5088},{4,4966},{15,4966},{16,4966}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(421) ->
	#base_star_map{star_map_id = 421,cons_id = 6,class_id = 3,point_id = 4,cons_name = "处女座",consume = 493,attr = [{1,10054},{2,201080},{3,5088},{4,5088},{15,4966},{16,4966}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(422) ->
	#base_star_map{star_map_id = 422,cons_id = 6,class_id = 3,point_id = 5,cons_name = "处女座",consume = 498,attr = [{1,10054},{2,201080},{3,5088},{4,5088},{15,5088},{16,4966}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(423) ->
	#base_star_map{star_map_id = 423,cons_id = 6,class_id = 3,point_id = 6,cons_name = "处女座",consume = 503,attr = [{1,10054},{2,201080},{3,5088},{4,5088},{15,5088},{16,5088}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(424) ->
	#base_star_map{star_map_id = 424,cons_id = 6,class_id = 3,point_id = 7,cons_name = "处女座",consume = 508,attr = [{1,10054},{2,203520},{3,5088},{4,5088},{15,5088},{16,5088}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(425) ->
	#base_star_map{star_map_id = 425,cons_id = 6,class_id = 3,point_id = 8,cons_name = "处女座",consume = 513,attr = [{1,10176},{2,203520},{3,5088},{4,5088},{15,5088},{16,5088}],extra_attr = [{15,5088},{16,5088},{68,10600}]};

get_starmap_cfg(426) ->
	#base_star_map{star_map_id = 426,cons_id = 6,class_id = 4,point_id = 1,cons_name = "处女座",consume = 487,attr = [{1,10299},{2,203520},{3,5088},{4,5088},{15,5088},{16,5088}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(427) ->
	#base_star_map{star_map_id = 427,cons_id = 6,class_id = 4,point_id = 2,cons_name = "处女座",consume = 492,attr = [{1,10299},{2,205980},{3,5088},{4,5088},{15,5088},{16,5088}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(428) ->
	#base_star_map{star_map_id = 428,cons_id = 6,class_id = 4,point_id = 3,cons_name = "处女座",consume = 497,attr = [{1,10299},{2,205980},{3,5211},{4,5088},{15,5088},{16,5088}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(429) ->
	#base_star_map{star_map_id = 429,cons_id = 6,class_id = 4,point_id = 4,cons_name = "处女座",consume = 502,attr = [{1,10299},{2,205980},{3,5211},{4,5211},{15,5088},{16,5088}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(430) ->
	#base_star_map{star_map_id = 430,cons_id = 6,class_id = 4,point_id = 5,cons_name = "处女座",consume = 507,attr = [{1,10299},{2,205980},{3,5211},{4,5211},{15,5211},{16,5088}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(431) ->
	#base_star_map{star_map_id = 431,cons_id = 6,class_id = 4,point_id = 6,cons_name = "处女座",consume = 512,attr = [{1,10299},{2,205980},{3,5211},{4,5211},{15,5211},{16,5211}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(432) ->
	#base_star_map{star_map_id = 432,cons_id = 6,class_id = 4,point_id = 7,cons_name = "处女座",consume = 517,attr = [{1,10299},{2,208440},{3,5211},{4,5211},{15,5211},{16,5211}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(433) ->
	#base_star_map{star_map_id = 433,cons_id = 6,class_id = 4,point_id = 8,cons_name = "处女座",consume = 522,attr = [{1,10422},{2,208440},{3,5211},{4,5211},{15,5211},{16,5211}],extra_attr = [{15,5211},{16,5211},{68,10800}]};

get_starmap_cfg(434) ->
	#base_star_map{star_map_id = 434,cons_id = 6,class_id = 5,point_id = 1,cons_name = "处女座",consume = 496,attr = [{1,10546},{2,208440},{3,5211},{4,5211},{15,5211},{16,5211}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(435) ->
	#base_star_map{star_map_id = 435,cons_id = 6,class_id = 5,point_id = 2,cons_name = "处女座",consume = 501,attr = [{1,10546},{2,210920},{3,5211},{4,5211},{15,5211},{16,5211}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(436) ->
	#base_star_map{star_map_id = 436,cons_id = 6,class_id = 5,point_id = 3,cons_name = "处女座",consume = 506,attr = [{1,10546},{2,210920},{3,5335},{4,5211},{15,5211},{16,5211}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(437) ->
	#base_star_map{star_map_id = 437,cons_id = 6,class_id = 5,point_id = 4,cons_name = "处女座",consume = 511,attr = [{1,10546},{2,210920},{3,5335},{4,5335},{15,5211},{16,5211}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(438) ->
	#base_star_map{star_map_id = 438,cons_id = 6,class_id = 5,point_id = 5,cons_name = "处女座",consume = 516,attr = [{1,10546},{2,210920},{3,5335},{4,5335},{15,5335},{16,5211}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(439) ->
	#base_star_map{star_map_id = 439,cons_id = 6,class_id = 5,point_id = 6,cons_name = "处女座",consume = 521,attr = [{1,10546},{2,210920},{3,5335},{4,5335},{15,5335},{16,5335}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(440) ->
	#base_star_map{star_map_id = 440,cons_id = 6,class_id = 5,point_id = 7,cons_name = "处女座",consume = 526,attr = [{1,10546},{2,213400},{3,5335},{4,5335},{15,5335},{16,5335}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(441) ->
	#base_star_map{star_map_id = 441,cons_id = 6,class_id = 5,point_id = 8,cons_name = "处女座",consume = 531,attr = [{1,10670},{2,213400},{3,5335},{4,5335},{15,5335},{16,5335}],extra_attr = [{15,5335},{16,5335},{68,11000}]};

get_starmap_cfg(442) ->
	#base_star_map{star_map_id = 442,cons_id = 6,class_id = 6,point_id = 1,cons_name = "处女座",consume = 505,attr = [{1,10795},{2,213400},{3,5335},{4,5335},{15,5335},{16,5335}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(443) ->
	#base_star_map{star_map_id = 443,cons_id = 6,class_id = 6,point_id = 2,cons_name = "处女座",consume = 510,attr = [{1,10795},{2,215900},{3,5335},{4,5335},{15,5335},{16,5335}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(444) ->
	#base_star_map{star_map_id = 444,cons_id = 6,class_id = 6,point_id = 3,cons_name = "处女座",consume = 515,attr = [{1,10795},{2,215900},{3,5460},{4,5335},{15,5335},{16,5335}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(445) ->
	#base_star_map{star_map_id = 445,cons_id = 6,class_id = 6,point_id = 4,cons_name = "处女座",consume = 520,attr = [{1,10795},{2,215900},{3,5460},{4,5460},{15,5335},{16,5335}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(446) ->
	#base_star_map{star_map_id = 446,cons_id = 6,class_id = 6,point_id = 5,cons_name = "处女座",consume = 525,attr = [{1,10795},{2,215900},{3,5460},{4,5460},{15,5460},{16,5335}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(447) ->
	#base_star_map{star_map_id = 447,cons_id = 6,class_id = 6,point_id = 6,cons_name = "处女座",consume = 530,attr = [{1,10795},{2,215900},{3,5460},{4,5460},{15,5460},{16,5460}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(448) ->
	#base_star_map{star_map_id = 448,cons_id = 6,class_id = 6,point_id = 7,cons_name = "处女座",consume = 535,attr = [{1,10795},{2,218400},{3,5460},{4,5460},{15,5460},{16,5460}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(449) ->
	#base_star_map{star_map_id = 449,cons_id = 6,class_id = 6,point_id = 8,cons_name = "处女座",consume = 540,attr = [{1,10920},{2,218400},{3,5460},{4,5460},{15,5460},{16,5460}],extra_attr = [{15,5460},{16,5460},{68,11200}]};

get_starmap_cfg(450) ->
	#base_star_map{star_map_id = 450,cons_id = 6,class_id = 7,point_id = 1,cons_name = "处女座",consume = 514,attr = [{1,11046},{2,218400},{3,5460},{4,5460},{15,5460},{16,5460}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(451) ->
	#base_star_map{star_map_id = 451,cons_id = 6,class_id = 7,point_id = 2,cons_name = "处女座",consume = 519,attr = [{1,11046},{2,220920},{3,5460},{4,5460},{15,5460},{16,5460}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(452) ->
	#base_star_map{star_map_id = 452,cons_id = 6,class_id = 7,point_id = 3,cons_name = "处女座",consume = 524,attr = [{1,11046},{2,220920},{3,5586},{4,5460},{15,5460},{16,5460}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(453) ->
	#base_star_map{star_map_id = 453,cons_id = 6,class_id = 7,point_id = 4,cons_name = "处女座",consume = 529,attr = [{1,11046},{2,220920},{3,5586},{4,5586},{15,5460},{16,5460}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(454) ->
	#base_star_map{star_map_id = 454,cons_id = 6,class_id = 7,point_id = 5,cons_name = "处女座",consume = 534,attr = [{1,11046},{2,220920},{3,5586},{4,5586},{15,5586},{16,5460}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(455) ->
	#base_star_map{star_map_id = 455,cons_id = 6,class_id = 7,point_id = 6,cons_name = "处女座",consume = 539,attr = [{1,11046},{2,220920},{3,5586},{4,5586},{15,5586},{16,5586}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(456) ->
	#base_star_map{star_map_id = 456,cons_id = 6,class_id = 7,point_id = 7,cons_name = "处女座",consume = 544,attr = [{1,11046},{2,223440},{3,5586},{4,5586},{15,5586},{16,5586}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(457) ->
	#base_star_map{star_map_id = 457,cons_id = 6,class_id = 7,point_id = 8,cons_name = "处女座",consume = 549,attr = [{1,11172},{2,223440},{3,5586},{4,5586},{15,5586},{16,5586}],extra_attr = [{15,5586},{16,5586},{68,11400}]};

get_starmap_cfg(458) ->
	#base_star_map{star_map_id = 458,cons_id = 6,class_id = 8,point_id = 1,cons_name = "处女座",consume = 523,attr = [{1,11299},{2,223440},{3,5586},{4,5586},{15,5586},{16,5586}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(459) ->
	#base_star_map{star_map_id = 459,cons_id = 6,class_id = 8,point_id = 2,cons_name = "处女座",consume = 528,attr = [{1,11299},{2,225980},{3,5586},{4,5586},{15,5586},{16,5586}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(460) ->
	#base_star_map{star_map_id = 460,cons_id = 6,class_id = 8,point_id = 3,cons_name = "处女座",consume = 533,attr = [{1,11299},{2,225980},{3,5713},{4,5586},{15,5586},{16,5586}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(461) ->
	#base_star_map{star_map_id = 461,cons_id = 6,class_id = 8,point_id = 4,cons_name = "处女座",consume = 538,attr = [{1,11299},{2,225980},{3,5713},{4,5713},{15,5586},{16,5586}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(462) ->
	#base_star_map{star_map_id = 462,cons_id = 6,class_id = 8,point_id = 5,cons_name = "处女座",consume = 543,attr = [{1,11299},{2,225980},{3,5713},{4,5713},{15,5713},{16,5586}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(463) ->
	#base_star_map{star_map_id = 463,cons_id = 6,class_id = 8,point_id = 6,cons_name = "处女座",consume = 548,attr = [{1,11299},{2,225980},{3,5713},{4,5713},{15,5713},{16,5713}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(464) ->
	#base_star_map{star_map_id = 464,cons_id = 6,class_id = 8,point_id = 7,cons_name = "处女座",consume = 553,attr = [{1,11299},{2,228520},{3,5713},{4,5713},{15,5713},{16,5713}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(465) ->
	#base_star_map{star_map_id = 465,cons_id = 6,class_id = 8,point_id = 8,cons_name = "处女座",consume = 558,attr = [{1,11426},{2,228520},{3,5713},{4,5713},{15,5713},{16,5713}],extra_attr = [{15,5713},{16,5713},{68,11600}]};

get_starmap_cfg(466) ->
	#base_star_map{star_map_id = 466,cons_id = 6,class_id = 9,point_id = 1,cons_name = "处女座",consume = 532,attr = [{1,11554},{2,228520},{3,5713},{4,5713},{15,5713},{16,5713}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(467) ->
	#base_star_map{star_map_id = 467,cons_id = 6,class_id = 9,point_id = 2,cons_name = "处女座",consume = 537,attr = [{1,11554},{2,231080},{3,5713},{4,5713},{15,5713},{16,5713}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(468) ->
	#base_star_map{star_map_id = 468,cons_id = 6,class_id = 9,point_id = 3,cons_name = "处女座",consume = 542,attr = [{1,11554},{2,231080},{3,5841},{4,5713},{15,5713},{16,5713}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(469) ->
	#base_star_map{star_map_id = 469,cons_id = 6,class_id = 9,point_id = 4,cons_name = "处女座",consume = 547,attr = [{1,11554},{2,231080},{3,5841},{4,5841},{15,5713},{16,5713}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(470) ->
	#base_star_map{star_map_id = 470,cons_id = 6,class_id = 9,point_id = 5,cons_name = "处女座",consume = 552,attr = [{1,11554},{2,231080},{3,5841},{4,5841},{15,5841},{16,5713}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(471) ->
	#base_star_map{star_map_id = 471,cons_id = 6,class_id = 9,point_id = 6,cons_name = "处女座",consume = 557,attr = [{1,11554},{2,231080},{3,5841},{4,5841},{15,5841},{16,5841}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(472) ->
	#base_star_map{star_map_id = 472,cons_id = 6,class_id = 9,point_id = 7,cons_name = "处女座",consume = 562,attr = [{1,11554},{2,233640},{3,5841},{4,5841},{15,5841},{16,5841}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(473) ->
	#base_star_map{star_map_id = 473,cons_id = 6,class_id = 9,point_id = 8,cons_name = "处女座",consume = 567,attr = [{1,11682},{2,233640},{3,5841},{4,5841},{15,5841},{16,5841}],extra_attr = [{15,5841},{16,5841},{68,11800}]};

get_starmap_cfg(474) ->
	#base_star_map{star_map_id = 474,cons_id = 6,class_id = 10,point_id = 1,cons_name = "处女座",consume = 541,attr = [{1,11811},{2,233640},{3,5841},{4,5841},{15,5841},{16,5841}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(475) ->
	#base_star_map{star_map_id = 475,cons_id = 6,class_id = 10,point_id = 2,cons_name = "处女座",consume = 546,attr = [{1,11811},{2,236220},{3,5841},{4,5841},{15,5841},{16,5841}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(476) ->
	#base_star_map{star_map_id = 476,cons_id = 6,class_id = 10,point_id = 3,cons_name = "处女座",consume = 551,attr = [{1,11811},{2,236220},{3,5970},{4,5841},{15,5841},{16,5841}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(477) ->
	#base_star_map{star_map_id = 477,cons_id = 6,class_id = 10,point_id = 4,cons_name = "处女座",consume = 556,attr = [{1,11811},{2,236220},{3,5970},{4,5970},{15,5841},{16,5841}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(478) ->
	#base_star_map{star_map_id = 478,cons_id = 6,class_id = 10,point_id = 5,cons_name = "处女座",consume = 561,attr = [{1,11811},{2,236220},{3,5970},{4,5970},{15,5970},{16,5841}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(479) ->
	#base_star_map{star_map_id = 479,cons_id = 6,class_id = 10,point_id = 6,cons_name = "处女座",consume = 566,attr = [{1,11811},{2,236220},{3,5970},{4,5970},{15,5970},{16,5970}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(480) ->
	#base_star_map{star_map_id = 480,cons_id = 6,class_id = 10,point_id = 7,cons_name = "处女座",consume = 571,attr = [{1,11811},{2,238800},{3,5970},{4,5970},{15,5970},{16,5970}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(481) ->
	#base_star_map{star_map_id = 481,cons_id = 6,class_id = 10,point_id = 8,cons_name = "处女座",consume = 576,attr = [{1,11940},{2,238800},{3,5970},{4,5970},{15,5970},{16,5970}],extra_attr = [{15,5970},{16,5970},{68,12000}]};

get_starmap_cfg(482) ->
	#base_star_map{star_map_id = 482,cons_id = 7,class_id = 1,point_id = 1,cons_name = "天秤座",consume = 550,attr = [{1,12070},{2,238800},{3,5970},{4,5970},{15,5970},{16,5970}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(483) ->
	#base_star_map{star_map_id = 483,cons_id = 7,class_id = 1,point_id = 2,cons_name = "天秤座",consume = 555,attr = [{1,12070},{2,241400},{3,5970},{4,5970},{15,5970},{16,5970}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(484) ->
	#base_star_map{star_map_id = 484,cons_id = 7,class_id = 1,point_id = 3,cons_name = "天秤座",consume = 560,attr = [{1,12070},{2,241400},{3,6100},{4,5970},{15,5970},{16,5970}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(485) ->
	#base_star_map{star_map_id = 485,cons_id = 7,class_id = 1,point_id = 4,cons_name = "天秤座",consume = 565,attr = [{1,12070},{2,241400},{3,6100},{4,6100},{15,5970},{16,5970}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(486) ->
	#base_star_map{star_map_id = 486,cons_id = 7,class_id = 1,point_id = 5,cons_name = "天秤座",consume = 570,attr = [{1,12070},{2,241400},{3,6100},{4,6100},{15,6100},{16,5970}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(487) ->
	#base_star_map{star_map_id = 487,cons_id = 7,class_id = 1,point_id = 6,cons_name = "天秤座",consume = 575,attr = [{1,12070},{2,241400},{3,6100},{4,6100},{15,6100},{16,6100}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(488) ->
	#base_star_map{star_map_id = 488,cons_id = 7,class_id = 1,point_id = 7,cons_name = "天秤座",consume = 580,attr = [{1,12070},{2,244000},{3,6100},{4,6100},{15,6100},{16,6100}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(489) ->
	#base_star_map{star_map_id = 489,cons_id = 7,class_id = 1,point_id = 8,cons_name = "天秤座",consume = 585,attr = [{1,12200},{2,244000},{3,6100},{4,6100},{15,6100},{16,6100}],extra_attr = [{15,6100},{16,6100},{68,12200}]};

get_starmap_cfg(490) ->
	#base_star_map{star_map_id = 490,cons_id = 7,class_id = 2,point_id = 1,cons_name = "天秤座",consume = 559,attr = [{1,12331},{2,244000},{3,6100},{4,6100},{15,6100},{16,6100}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(491) ->
	#base_star_map{star_map_id = 491,cons_id = 7,class_id = 2,point_id = 2,cons_name = "天秤座",consume = 564,attr = [{1,12331},{2,246620},{3,6100},{4,6100},{15,6100},{16,6100}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(492) ->
	#base_star_map{star_map_id = 492,cons_id = 7,class_id = 2,point_id = 3,cons_name = "天秤座",consume = 569,attr = [{1,12331},{2,246620},{3,6231},{4,6100},{15,6100},{16,6100}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(493) ->
	#base_star_map{star_map_id = 493,cons_id = 7,class_id = 2,point_id = 4,cons_name = "天秤座",consume = 574,attr = [{1,12331},{2,246620},{3,6231},{4,6231},{15,6100},{16,6100}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(494) ->
	#base_star_map{star_map_id = 494,cons_id = 7,class_id = 2,point_id = 5,cons_name = "天秤座",consume = 579,attr = [{1,12331},{2,246620},{3,6231},{4,6231},{15,6231},{16,6100}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(495) ->
	#base_star_map{star_map_id = 495,cons_id = 7,class_id = 2,point_id = 6,cons_name = "天秤座",consume = 584,attr = [{1,12331},{2,246620},{3,6231},{4,6231},{15,6231},{16,6231}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(496) ->
	#base_star_map{star_map_id = 496,cons_id = 7,class_id = 2,point_id = 7,cons_name = "天秤座",consume = 589,attr = [{1,12331},{2,249240},{3,6231},{4,6231},{15,6231},{16,6231}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(497) ->
	#base_star_map{star_map_id = 497,cons_id = 7,class_id = 2,point_id = 8,cons_name = "天秤座",consume = 594,attr = [{1,12462},{2,249240},{3,6231},{4,6231},{15,6231},{16,6231}],extra_attr = [{15,6231},{16,6231},{68,12400}]};

get_starmap_cfg(498) ->
	#base_star_map{star_map_id = 498,cons_id = 7,class_id = 3,point_id = 1,cons_name = "天秤座",consume = 568,attr = [{1,12594},{2,249240},{3,6231},{4,6231},{15,6231},{16,6231}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(499) ->
	#base_star_map{star_map_id = 499,cons_id = 7,class_id = 3,point_id = 2,cons_name = "天秤座",consume = 573,attr = [{1,12594},{2,251880},{3,6231},{4,6231},{15,6231},{16,6231}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(500) ->
	#base_star_map{star_map_id = 500,cons_id = 7,class_id = 3,point_id = 3,cons_name = "天秤座",consume = 578,attr = [{1,12594},{2,251880},{3,6363},{4,6231},{15,6231},{16,6231}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(501) ->
	#base_star_map{star_map_id = 501,cons_id = 7,class_id = 3,point_id = 4,cons_name = "天秤座",consume = 583,attr = [{1,12594},{2,251880},{3,6363},{4,6363},{15,6231},{16,6231}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(502) ->
	#base_star_map{star_map_id = 502,cons_id = 7,class_id = 3,point_id = 5,cons_name = "天秤座",consume = 588,attr = [{1,12594},{2,251880},{3,6363},{4,6363},{15,6363},{16,6231}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(503) ->
	#base_star_map{star_map_id = 503,cons_id = 7,class_id = 3,point_id = 6,cons_name = "天秤座",consume = 593,attr = [{1,12594},{2,251880},{3,6363},{4,6363},{15,6363},{16,6363}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(504) ->
	#base_star_map{star_map_id = 504,cons_id = 7,class_id = 3,point_id = 7,cons_name = "天秤座",consume = 598,attr = [{1,12594},{2,254520},{3,6363},{4,6363},{15,6363},{16,6363}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(505) ->
	#base_star_map{star_map_id = 505,cons_id = 7,class_id = 3,point_id = 8,cons_name = "天秤座",consume = 603,attr = [{1,12726},{2,254520},{3,6363},{4,6363},{15,6363},{16,6363}],extra_attr = [{15,6363},{16,6363},{68,12600}]};

get_starmap_cfg(506) ->
	#base_star_map{star_map_id = 506,cons_id = 7,class_id = 4,point_id = 1,cons_name = "天秤座",consume = 577,attr = [{1,12859},{2,254520},{3,6363},{4,6363},{15,6363},{16,6363}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(507) ->
	#base_star_map{star_map_id = 507,cons_id = 7,class_id = 4,point_id = 2,cons_name = "天秤座",consume = 582,attr = [{1,12859},{2,257180},{3,6363},{4,6363},{15,6363},{16,6363}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(508) ->
	#base_star_map{star_map_id = 508,cons_id = 7,class_id = 4,point_id = 3,cons_name = "天秤座",consume = 587,attr = [{1,12859},{2,257180},{3,6496},{4,6363},{15,6363},{16,6363}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(509) ->
	#base_star_map{star_map_id = 509,cons_id = 7,class_id = 4,point_id = 4,cons_name = "天秤座",consume = 592,attr = [{1,12859},{2,257180},{3,6496},{4,6496},{15,6363},{16,6363}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(510) ->
	#base_star_map{star_map_id = 510,cons_id = 7,class_id = 4,point_id = 5,cons_name = "天秤座",consume = 597,attr = [{1,12859},{2,257180},{3,6496},{4,6496},{15,6496},{16,6363}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(511) ->
	#base_star_map{star_map_id = 511,cons_id = 7,class_id = 4,point_id = 6,cons_name = "天秤座",consume = 602,attr = [{1,12859},{2,257180},{3,6496},{4,6496},{15,6496},{16,6496}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(512) ->
	#base_star_map{star_map_id = 512,cons_id = 7,class_id = 4,point_id = 7,cons_name = "天秤座",consume = 607,attr = [{1,12859},{2,259840},{3,6496},{4,6496},{15,6496},{16,6496}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(513) ->
	#base_star_map{star_map_id = 513,cons_id = 7,class_id = 4,point_id = 8,cons_name = "天秤座",consume = 612,attr = [{1,12992},{2,259840},{3,6496},{4,6496},{15,6496},{16,6496}],extra_attr = [{15,6496},{16,6496},{68,12800}]};

get_starmap_cfg(514) ->
	#base_star_map{star_map_id = 514,cons_id = 7,class_id = 5,point_id = 1,cons_name = "天秤座",consume = 586,attr = [{1,13126},{2,259840},{3,6496},{4,6496},{15,6496},{16,6496}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(515) ->
	#base_star_map{star_map_id = 515,cons_id = 7,class_id = 5,point_id = 2,cons_name = "天秤座",consume = 591,attr = [{1,13126},{2,262520},{3,6496},{4,6496},{15,6496},{16,6496}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(516) ->
	#base_star_map{star_map_id = 516,cons_id = 7,class_id = 5,point_id = 3,cons_name = "天秤座",consume = 596,attr = [{1,13126},{2,262520},{3,6630},{4,6496},{15,6496},{16,6496}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(517) ->
	#base_star_map{star_map_id = 517,cons_id = 7,class_id = 5,point_id = 4,cons_name = "天秤座",consume = 601,attr = [{1,13126},{2,262520},{3,6630},{4,6630},{15,6496},{16,6496}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(518) ->
	#base_star_map{star_map_id = 518,cons_id = 7,class_id = 5,point_id = 5,cons_name = "天秤座",consume = 606,attr = [{1,13126},{2,262520},{3,6630},{4,6630},{15,6630},{16,6496}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(519) ->
	#base_star_map{star_map_id = 519,cons_id = 7,class_id = 5,point_id = 6,cons_name = "天秤座",consume = 611,attr = [{1,13126},{2,262520},{3,6630},{4,6630},{15,6630},{16,6630}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(520) ->
	#base_star_map{star_map_id = 520,cons_id = 7,class_id = 5,point_id = 7,cons_name = "天秤座",consume = 616,attr = [{1,13126},{2,265200},{3,6630},{4,6630},{15,6630},{16,6630}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(521) ->
	#base_star_map{star_map_id = 521,cons_id = 7,class_id = 5,point_id = 8,cons_name = "天秤座",consume = 621,attr = [{1,13260},{2,265200},{3,6630},{4,6630},{15,6630},{16,6630}],extra_attr = [{15,6630},{16,6630},{68,13000}]};

get_starmap_cfg(522) ->
	#base_star_map{star_map_id = 522,cons_id = 7,class_id = 6,point_id = 1,cons_name = "天秤座",consume = 595,attr = [{1,13395},{2,265200},{3,6630},{4,6630},{15,6630},{16,6630}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(523) ->
	#base_star_map{star_map_id = 523,cons_id = 7,class_id = 6,point_id = 2,cons_name = "天秤座",consume = 600,attr = [{1,13395},{2,267900},{3,6630},{4,6630},{15,6630},{16,6630}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(524) ->
	#base_star_map{star_map_id = 524,cons_id = 7,class_id = 6,point_id = 3,cons_name = "天秤座",consume = 605,attr = [{1,13395},{2,267900},{3,6765},{4,6630},{15,6630},{16,6630}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(525) ->
	#base_star_map{star_map_id = 525,cons_id = 7,class_id = 6,point_id = 4,cons_name = "天秤座",consume = 610,attr = [{1,13395},{2,267900},{3,6765},{4,6765},{15,6630},{16,6630}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(526) ->
	#base_star_map{star_map_id = 526,cons_id = 7,class_id = 6,point_id = 5,cons_name = "天秤座",consume = 615,attr = [{1,13395},{2,267900},{3,6765},{4,6765},{15,6765},{16,6630}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(527) ->
	#base_star_map{star_map_id = 527,cons_id = 7,class_id = 6,point_id = 6,cons_name = "天秤座",consume = 620,attr = [{1,13395},{2,267900},{3,6765},{4,6765},{15,6765},{16,6765}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(528) ->
	#base_star_map{star_map_id = 528,cons_id = 7,class_id = 6,point_id = 7,cons_name = "天秤座",consume = 625,attr = [{1,13395},{2,270600},{3,6765},{4,6765},{15,6765},{16,6765}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(529) ->
	#base_star_map{star_map_id = 529,cons_id = 7,class_id = 6,point_id = 8,cons_name = "天秤座",consume = 630,attr = [{1,13530},{2,270600},{3,6765},{4,6765},{15,6765},{16,6765}],extra_attr = [{15,6765},{16,6765},{68,13200}]};

get_starmap_cfg(530) ->
	#base_star_map{star_map_id = 530,cons_id = 7,class_id = 7,point_id = 1,cons_name = "天秤座",consume = 604,attr = [{1,13666},{2,270600},{3,6765},{4,6765},{15,6765},{16,6765}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(531) ->
	#base_star_map{star_map_id = 531,cons_id = 7,class_id = 7,point_id = 2,cons_name = "天秤座",consume = 609,attr = [{1,13666},{2,273320},{3,6765},{4,6765},{15,6765},{16,6765}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(532) ->
	#base_star_map{star_map_id = 532,cons_id = 7,class_id = 7,point_id = 3,cons_name = "天秤座",consume = 614,attr = [{1,13666},{2,273320},{3,6901},{4,6765},{15,6765},{16,6765}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(533) ->
	#base_star_map{star_map_id = 533,cons_id = 7,class_id = 7,point_id = 4,cons_name = "天秤座",consume = 619,attr = [{1,13666},{2,273320},{3,6901},{4,6901},{15,6765},{16,6765}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(534) ->
	#base_star_map{star_map_id = 534,cons_id = 7,class_id = 7,point_id = 5,cons_name = "天秤座",consume = 624,attr = [{1,13666},{2,273320},{3,6901},{4,6901},{15,6901},{16,6765}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(535) ->
	#base_star_map{star_map_id = 535,cons_id = 7,class_id = 7,point_id = 6,cons_name = "天秤座",consume = 629,attr = [{1,13666},{2,273320},{3,6901},{4,6901},{15,6901},{16,6901}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(536) ->
	#base_star_map{star_map_id = 536,cons_id = 7,class_id = 7,point_id = 7,cons_name = "天秤座",consume = 634,attr = [{1,13666},{2,276040},{3,6901},{4,6901},{15,6901},{16,6901}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(537) ->
	#base_star_map{star_map_id = 537,cons_id = 7,class_id = 7,point_id = 8,cons_name = "天秤座",consume = 639,attr = [{1,13802},{2,276040},{3,6901},{4,6901},{15,6901},{16,6901}],extra_attr = [{15,6901},{16,6901},{68,13400}]};

get_starmap_cfg(538) ->
	#base_star_map{star_map_id = 538,cons_id = 7,class_id = 8,point_id = 1,cons_name = "天秤座",consume = 613,attr = [{1,13939},{2,276040},{3,6901},{4,6901},{15,6901},{16,6901}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(539) ->
	#base_star_map{star_map_id = 539,cons_id = 7,class_id = 8,point_id = 2,cons_name = "天秤座",consume = 618,attr = [{1,13939},{2,278780},{3,6901},{4,6901},{15,6901},{16,6901}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(540) ->
	#base_star_map{star_map_id = 540,cons_id = 7,class_id = 8,point_id = 3,cons_name = "天秤座",consume = 623,attr = [{1,13939},{2,278780},{3,7038},{4,6901},{15,6901},{16,6901}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(541) ->
	#base_star_map{star_map_id = 541,cons_id = 7,class_id = 8,point_id = 4,cons_name = "天秤座",consume = 628,attr = [{1,13939},{2,278780},{3,7038},{4,7038},{15,6901},{16,6901}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(542) ->
	#base_star_map{star_map_id = 542,cons_id = 7,class_id = 8,point_id = 5,cons_name = "天秤座",consume = 633,attr = [{1,13939},{2,278780},{3,7038},{4,7038},{15,7038},{16,6901}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(543) ->
	#base_star_map{star_map_id = 543,cons_id = 7,class_id = 8,point_id = 6,cons_name = "天秤座",consume = 638,attr = [{1,13939},{2,278780},{3,7038},{4,7038},{15,7038},{16,7038}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(544) ->
	#base_star_map{star_map_id = 544,cons_id = 7,class_id = 8,point_id = 7,cons_name = "天秤座",consume = 643,attr = [{1,13939},{2,281520},{3,7038},{4,7038},{15,7038},{16,7038}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(545) ->
	#base_star_map{star_map_id = 545,cons_id = 7,class_id = 8,point_id = 8,cons_name = "天秤座",consume = 648,attr = [{1,14076},{2,281520},{3,7038},{4,7038},{15,7038},{16,7038}],extra_attr = [{15,7038},{16,7038},{68,13600}]};

get_starmap_cfg(546) ->
	#base_star_map{star_map_id = 546,cons_id = 7,class_id = 9,point_id = 1,cons_name = "天秤座",consume = 622,attr = [{1,14214},{2,281520},{3,7038},{4,7038},{15,7038},{16,7038}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(547) ->
	#base_star_map{star_map_id = 547,cons_id = 7,class_id = 9,point_id = 2,cons_name = "天秤座",consume = 627,attr = [{1,14214},{2,284280},{3,7038},{4,7038},{15,7038},{16,7038}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(548) ->
	#base_star_map{star_map_id = 548,cons_id = 7,class_id = 9,point_id = 3,cons_name = "天秤座",consume = 632,attr = [{1,14214},{2,284280},{3,7176},{4,7038},{15,7038},{16,7038}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(549) ->
	#base_star_map{star_map_id = 549,cons_id = 7,class_id = 9,point_id = 4,cons_name = "天秤座",consume = 637,attr = [{1,14214},{2,284280},{3,7176},{4,7176},{15,7038},{16,7038}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(550) ->
	#base_star_map{star_map_id = 550,cons_id = 7,class_id = 9,point_id = 5,cons_name = "天秤座",consume = 642,attr = [{1,14214},{2,284280},{3,7176},{4,7176},{15,7176},{16,7038}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(551) ->
	#base_star_map{star_map_id = 551,cons_id = 7,class_id = 9,point_id = 6,cons_name = "天秤座",consume = 647,attr = [{1,14214},{2,284280},{3,7176},{4,7176},{15,7176},{16,7176}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(552) ->
	#base_star_map{star_map_id = 552,cons_id = 7,class_id = 9,point_id = 7,cons_name = "天秤座",consume = 652,attr = [{1,14214},{2,287040},{3,7176},{4,7176},{15,7176},{16,7176}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(553) ->
	#base_star_map{star_map_id = 553,cons_id = 7,class_id = 9,point_id = 8,cons_name = "天秤座",consume = 657,attr = [{1,14352},{2,287040},{3,7176},{4,7176},{15,7176},{16,7176}],extra_attr = [{15,7176},{16,7176},{68,13800}]};

get_starmap_cfg(554) ->
	#base_star_map{star_map_id = 554,cons_id = 7,class_id = 10,point_id = 1,cons_name = "天秤座",consume = 631,attr = [{1,14491},{2,287040},{3,7176},{4,7176},{15,7176},{16,7176}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(555) ->
	#base_star_map{star_map_id = 555,cons_id = 7,class_id = 10,point_id = 2,cons_name = "天秤座",consume = 636,attr = [{1,14491},{2,289820},{3,7176},{4,7176},{15,7176},{16,7176}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(556) ->
	#base_star_map{star_map_id = 556,cons_id = 7,class_id = 10,point_id = 3,cons_name = "天秤座",consume = 641,attr = [{1,14491},{2,289820},{3,7315},{4,7176},{15,7176},{16,7176}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(557) ->
	#base_star_map{star_map_id = 557,cons_id = 7,class_id = 10,point_id = 4,cons_name = "天秤座",consume = 646,attr = [{1,14491},{2,289820},{3,7315},{4,7315},{15,7176},{16,7176}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(558) ->
	#base_star_map{star_map_id = 558,cons_id = 7,class_id = 10,point_id = 5,cons_name = "天秤座",consume = 651,attr = [{1,14491},{2,289820},{3,7315},{4,7315},{15,7315},{16,7176}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(559) ->
	#base_star_map{star_map_id = 559,cons_id = 7,class_id = 10,point_id = 6,cons_name = "天秤座",consume = 656,attr = [{1,14491},{2,289820},{3,7315},{4,7315},{15,7315},{16,7315}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(560) ->
	#base_star_map{star_map_id = 560,cons_id = 7,class_id = 10,point_id = 7,cons_name = "天秤座",consume = 661,attr = [{1,14491},{2,292600},{3,7315},{4,7315},{15,7315},{16,7315}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(561) ->
	#base_star_map{star_map_id = 561,cons_id = 7,class_id = 10,point_id = 8,cons_name = "天秤座",consume = 666,attr = [{1,14630},{2,292600},{3,7315},{4,7315},{15,7315},{16,7315}],extra_attr = [{15,7315},{16,7315},{68,14000}]};

get_starmap_cfg(562) ->
	#base_star_map{star_map_id = 562,cons_id = 8,class_id = 1,point_id = 1,cons_name = "天蝎座",consume = 640,attr = [{1,14770},{2,292600},{3,7315},{4,7315},{15,7315},{16,7315}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(563) ->
	#base_star_map{star_map_id = 563,cons_id = 8,class_id = 1,point_id = 2,cons_name = "天蝎座",consume = 645,attr = [{1,14770},{2,295400},{3,7315},{4,7315},{15,7315},{16,7315}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(564) ->
	#base_star_map{star_map_id = 564,cons_id = 8,class_id = 1,point_id = 3,cons_name = "天蝎座",consume = 650,attr = [{1,14770},{2,295400},{3,7455},{4,7315},{15,7315},{16,7315}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(565) ->
	#base_star_map{star_map_id = 565,cons_id = 8,class_id = 1,point_id = 4,cons_name = "天蝎座",consume = 655,attr = [{1,14770},{2,295400},{3,7455},{4,7455},{15,7315},{16,7315}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(566) ->
	#base_star_map{star_map_id = 566,cons_id = 8,class_id = 1,point_id = 5,cons_name = "天蝎座",consume = 660,attr = [{1,14770},{2,295400},{3,7455},{4,7455},{15,7455},{16,7315}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(567) ->
	#base_star_map{star_map_id = 567,cons_id = 8,class_id = 1,point_id = 6,cons_name = "天蝎座",consume = 665,attr = [{1,14770},{2,295400},{3,7455},{4,7455},{15,7455},{16,7455}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(568) ->
	#base_star_map{star_map_id = 568,cons_id = 8,class_id = 1,point_id = 7,cons_name = "天蝎座",consume = 670,attr = [{1,14770},{2,298200},{3,7455},{4,7455},{15,7455},{16,7455}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(569) ->
	#base_star_map{star_map_id = 569,cons_id = 8,class_id = 1,point_id = 8,cons_name = "天蝎座",consume = 675,attr = [{1,14910},{2,298200},{3,7455},{4,7455},{15,7455},{16,7455}],extra_attr = [{15,7455},{16,7455},{68,14200}]};

get_starmap_cfg(570) ->
	#base_star_map{star_map_id = 570,cons_id = 8,class_id = 2,point_id = 1,cons_name = "天蝎座",consume = 649,attr = [{1,15051},{2,298200},{3,7455},{4,7455},{15,7455},{16,7455}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(571) ->
	#base_star_map{star_map_id = 571,cons_id = 8,class_id = 2,point_id = 2,cons_name = "天蝎座",consume = 654,attr = [{1,15051},{2,301020},{3,7455},{4,7455},{15,7455},{16,7455}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(572) ->
	#base_star_map{star_map_id = 572,cons_id = 8,class_id = 2,point_id = 3,cons_name = "天蝎座",consume = 659,attr = [{1,15051},{2,301020},{3,7596},{4,7455},{15,7455},{16,7455}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(573) ->
	#base_star_map{star_map_id = 573,cons_id = 8,class_id = 2,point_id = 4,cons_name = "天蝎座",consume = 664,attr = [{1,15051},{2,301020},{3,7596},{4,7596},{15,7455},{16,7455}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(574) ->
	#base_star_map{star_map_id = 574,cons_id = 8,class_id = 2,point_id = 5,cons_name = "天蝎座",consume = 669,attr = [{1,15051},{2,301020},{3,7596},{4,7596},{15,7596},{16,7455}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(575) ->
	#base_star_map{star_map_id = 575,cons_id = 8,class_id = 2,point_id = 6,cons_name = "天蝎座",consume = 674,attr = [{1,15051},{2,301020},{3,7596},{4,7596},{15,7596},{16,7596}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(576) ->
	#base_star_map{star_map_id = 576,cons_id = 8,class_id = 2,point_id = 7,cons_name = "天蝎座",consume = 679,attr = [{1,15051},{2,303840},{3,7596},{4,7596},{15,7596},{16,7596}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(577) ->
	#base_star_map{star_map_id = 577,cons_id = 8,class_id = 2,point_id = 8,cons_name = "天蝎座",consume = 684,attr = [{1,15192},{2,303840},{3,7596},{4,7596},{15,7596},{16,7596}],extra_attr = [{15,7596},{16,7596},{68,14400}]};

get_starmap_cfg(578) ->
	#base_star_map{star_map_id = 578,cons_id = 8,class_id = 3,point_id = 1,cons_name = "天蝎座",consume = 658,attr = [{1,15334},{2,303840},{3,7596},{4,7596},{15,7596},{16,7596}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(579) ->
	#base_star_map{star_map_id = 579,cons_id = 8,class_id = 3,point_id = 2,cons_name = "天蝎座",consume = 663,attr = [{1,15334},{2,306680},{3,7596},{4,7596},{15,7596},{16,7596}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(580) ->
	#base_star_map{star_map_id = 580,cons_id = 8,class_id = 3,point_id = 3,cons_name = "天蝎座",consume = 668,attr = [{1,15334},{2,306680},{3,7738},{4,7596},{15,7596},{16,7596}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(581) ->
	#base_star_map{star_map_id = 581,cons_id = 8,class_id = 3,point_id = 4,cons_name = "天蝎座",consume = 673,attr = [{1,15334},{2,306680},{3,7738},{4,7738},{15,7596},{16,7596}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(582) ->
	#base_star_map{star_map_id = 582,cons_id = 8,class_id = 3,point_id = 5,cons_name = "天蝎座",consume = 678,attr = [{1,15334},{2,306680},{3,7738},{4,7738},{15,7738},{16,7596}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(583) ->
	#base_star_map{star_map_id = 583,cons_id = 8,class_id = 3,point_id = 6,cons_name = "天蝎座",consume = 683,attr = [{1,15334},{2,306680},{3,7738},{4,7738},{15,7738},{16,7738}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(584) ->
	#base_star_map{star_map_id = 584,cons_id = 8,class_id = 3,point_id = 7,cons_name = "天蝎座",consume = 688,attr = [{1,15334},{2,309520},{3,7738},{4,7738},{15,7738},{16,7738}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(585) ->
	#base_star_map{star_map_id = 585,cons_id = 8,class_id = 3,point_id = 8,cons_name = "天蝎座",consume = 693,attr = [{1,15476},{2,309520},{3,7738},{4,7738},{15,7738},{16,7738}],extra_attr = [{15,7738},{16,7738},{68,14600}]};

get_starmap_cfg(586) ->
	#base_star_map{star_map_id = 586,cons_id = 8,class_id = 4,point_id = 1,cons_name = "天蝎座",consume = 667,attr = [{1,15619},{2,309520},{3,7738},{4,7738},{15,7738},{16,7738}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(587) ->
	#base_star_map{star_map_id = 587,cons_id = 8,class_id = 4,point_id = 2,cons_name = "天蝎座",consume = 672,attr = [{1,15619},{2,312380},{3,7738},{4,7738},{15,7738},{16,7738}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(588) ->
	#base_star_map{star_map_id = 588,cons_id = 8,class_id = 4,point_id = 3,cons_name = "天蝎座",consume = 677,attr = [{1,15619},{2,312380},{3,7881},{4,7738},{15,7738},{16,7738}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(589) ->
	#base_star_map{star_map_id = 589,cons_id = 8,class_id = 4,point_id = 4,cons_name = "天蝎座",consume = 682,attr = [{1,15619},{2,312380},{3,7881},{4,7881},{15,7738},{16,7738}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(590) ->
	#base_star_map{star_map_id = 590,cons_id = 8,class_id = 4,point_id = 5,cons_name = "天蝎座",consume = 687,attr = [{1,15619},{2,312380},{3,7881},{4,7881},{15,7881},{16,7738}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(591) ->
	#base_star_map{star_map_id = 591,cons_id = 8,class_id = 4,point_id = 6,cons_name = "天蝎座",consume = 692,attr = [{1,15619},{2,312380},{3,7881},{4,7881},{15,7881},{16,7881}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(592) ->
	#base_star_map{star_map_id = 592,cons_id = 8,class_id = 4,point_id = 7,cons_name = "天蝎座",consume = 697,attr = [{1,15619},{2,315240},{3,7881},{4,7881},{15,7881},{16,7881}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(593) ->
	#base_star_map{star_map_id = 593,cons_id = 8,class_id = 4,point_id = 8,cons_name = "天蝎座",consume = 702,attr = [{1,15762},{2,315240},{3,7881},{4,7881},{15,7881},{16,7881}],extra_attr = [{15,7881},{16,7881},{68,14800}]};

get_starmap_cfg(594) ->
	#base_star_map{star_map_id = 594,cons_id = 8,class_id = 5,point_id = 1,cons_name = "天蝎座",consume = 676,attr = [{1,15906},{2,315240},{3,7881},{4,7881},{15,7881},{16,7881}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(595) ->
	#base_star_map{star_map_id = 595,cons_id = 8,class_id = 5,point_id = 2,cons_name = "天蝎座",consume = 681,attr = [{1,15906},{2,318120},{3,7881},{4,7881},{15,7881},{16,7881}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(596) ->
	#base_star_map{star_map_id = 596,cons_id = 8,class_id = 5,point_id = 3,cons_name = "天蝎座",consume = 686,attr = [{1,15906},{2,318120},{3,8025},{4,7881},{15,7881},{16,7881}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(597) ->
	#base_star_map{star_map_id = 597,cons_id = 8,class_id = 5,point_id = 4,cons_name = "天蝎座",consume = 691,attr = [{1,15906},{2,318120},{3,8025},{4,8025},{15,7881},{16,7881}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(598) ->
	#base_star_map{star_map_id = 598,cons_id = 8,class_id = 5,point_id = 5,cons_name = "天蝎座",consume = 696,attr = [{1,15906},{2,318120},{3,8025},{4,8025},{15,8025},{16,7881}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(599) ->
	#base_star_map{star_map_id = 599,cons_id = 8,class_id = 5,point_id = 6,cons_name = "天蝎座",consume = 701,attr = [{1,15906},{2,318120},{3,8025},{4,8025},{15,8025},{16,8025}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(600) ->
	#base_star_map{star_map_id = 600,cons_id = 8,class_id = 5,point_id = 7,cons_name = "天蝎座",consume = 706,attr = [{1,15906},{2,321000},{3,8025},{4,8025},{15,8025},{16,8025}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(601) ->
	#base_star_map{star_map_id = 601,cons_id = 8,class_id = 5,point_id = 8,cons_name = "天蝎座",consume = 711,attr = [{1,16050},{2,321000},{3,8025},{4,8025},{15,8025},{16,8025}],extra_attr = [{15,8025},{16,8025},{68,15000}]};

get_starmap_cfg(602) ->
	#base_star_map{star_map_id = 602,cons_id = 8,class_id = 6,point_id = 1,cons_name = "天蝎座",consume = 685,attr = [{1,16195},{2,321000},{3,8025},{4,8025},{15,8025},{16,8025}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(603) ->
	#base_star_map{star_map_id = 603,cons_id = 8,class_id = 6,point_id = 2,cons_name = "天蝎座",consume = 690,attr = [{1,16195},{2,323900},{3,8025},{4,8025},{15,8025},{16,8025}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(604) ->
	#base_star_map{star_map_id = 604,cons_id = 8,class_id = 6,point_id = 3,cons_name = "天蝎座",consume = 695,attr = [{1,16195},{2,323900},{3,8170},{4,8025},{15,8025},{16,8025}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(605) ->
	#base_star_map{star_map_id = 605,cons_id = 8,class_id = 6,point_id = 4,cons_name = "天蝎座",consume = 700,attr = [{1,16195},{2,323900},{3,8170},{4,8170},{15,8025},{16,8025}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(606) ->
	#base_star_map{star_map_id = 606,cons_id = 8,class_id = 6,point_id = 5,cons_name = "天蝎座",consume = 705,attr = [{1,16195},{2,323900},{3,8170},{4,8170},{15,8170},{16,8025}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(607) ->
	#base_star_map{star_map_id = 607,cons_id = 8,class_id = 6,point_id = 6,cons_name = "天蝎座",consume = 710,attr = [{1,16195},{2,323900},{3,8170},{4,8170},{15,8170},{16,8170}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(608) ->
	#base_star_map{star_map_id = 608,cons_id = 8,class_id = 6,point_id = 7,cons_name = "天蝎座",consume = 715,attr = [{1,16195},{2,326800},{3,8170},{4,8170},{15,8170},{16,8170}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(609) ->
	#base_star_map{star_map_id = 609,cons_id = 8,class_id = 6,point_id = 8,cons_name = "天蝎座",consume = 720,attr = [{1,16340},{2,326800},{3,8170},{4,8170},{15,8170},{16,8170}],extra_attr = [{15,8170},{16,8170},{68,15200}]};

get_starmap_cfg(610) ->
	#base_star_map{star_map_id = 610,cons_id = 8,class_id = 7,point_id = 1,cons_name = "天蝎座",consume = 694,attr = [{1,16486},{2,326800},{3,8170},{4,8170},{15,8170},{16,8170}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(611) ->
	#base_star_map{star_map_id = 611,cons_id = 8,class_id = 7,point_id = 2,cons_name = "天蝎座",consume = 699,attr = [{1,16486},{2,329720},{3,8170},{4,8170},{15,8170},{16,8170}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(612) ->
	#base_star_map{star_map_id = 612,cons_id = 8,class_id = 7,point_id = 3,cons_name = "天蝎座",consume = 704,attr = [{1,16486},{2,329720},{3,8316},{4,8170},{15,8170},{16,8170}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(613) ->
	#base_star_map{star_map_id = 613,cons_id = 8,class_id = 7,point_id = 4,cons_name = "天蝎座",consume = 709,attr = [{1,16486},{2,329720},{3,8316},{4,8316},{15,8170},{16,8170}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(614) ->
	#base_star_map{star_map_id = 614,cons_id = 8,class_id = 7,point_id = 5,cons_name = "天蝎座",consume = 714,attr = [{1,16486},{2,329720},{3,8316},{4,8316},{15,8316},{16,8170}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(615) ->
	#base_star_map{star_map_id = 615,cons_id = 8,class_id = 7,point_id = 6,cons_name = "天蝎座",consume = 719,attr = [{1,16486},{2,329720},{3,8316},{4,8316},{15,8316},{16,8316}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(616) ->
	#base_star_map{star_map_id = 616,cons_id = 8,class_id = 7,point_id = 7,cons_name = "天蝎座",consume = 724,attr = [{1,16486},{2,332640},{3,8316},{4,8316},{15,8316},{16,8316}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(617) ->
	#base_star_map{star_map_id = 617,cons_id = 8,class_id = 7,point_id = 8,cons_name = "天蝎座",consume = 729,attr = [{1,16632},{2,332640},{3,8316},{4,8316},{15,8316},{16,8316}],extra_attr = [{15,8316},{16,8316},{68,15400}]};

get_starmap_cfg(618) ->
	#base_star_map{star_map_id = 618,cons_id = 8,class_id = 8,point_id = 1,cons_name = "天蝎座",consume = 703,attr = [{1,16779},{2,332640},{3,8316},{4,8316},{15,8316},{16,8316}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(619) ->
	#base_star_map{star_map_id = 619,cons_id = 8,class_id = 8,point_id = 2,cons_name = "天蝎座",consume = 708,attr = [{1,16779},{2,335580},{3,8316},{4,8316},{15,8316},{16,8316}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(620) ->
	#base_star_map{star_map_id = 620,cons_id = 8,class_id = 8,point_id = 3,cons_name = "天蝎座",consume = 713,attr = [{1,16779},{2,335580},{3,8463},{4,8316},{15,8316},{16,8316}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(621) ->
	#base_star_map{star_map_id = 621,cons_id = 8,class_id = 8,point_id = 4,cons_name = "天蝎座",consume = 718,attr = [{1,16779},{2,335580},{3,8463},{4,8463},{15,8316},{16,8316}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(622) ->
	#base_star_map{star_map_id = 622,cons_id = 8,class_id = 8,point_id = 5,cons_name = "天蝎座",consume = 723,attr = [{1,16779},{2,335580},{3,8463},{4,8463},{15,8463},{16,8316}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(623) ->
	#base_star_map{star_map_id = 623,cons_id = 8,class_id = 8,point_id = 6,cons_name = "天蝎座",consume = 728,attr = [{1,16779},{2,335580},{3,8463},{4,8463},{15,8463},{16,8463}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(624) ->
	#base_star_map{star_map_id = 624,cons_id = 8,class_id = 8,point_id = 7,cons_name = "天蝎座",consume = 733,attr = [{1,16779},{2,338520},{3,8463},{4,8463},{15,8463},{16,8463}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(625) ->
	#base_star_map{star_map_id = 625,cons_id = 8,class_id = 8,point_id = 8,cons_name = "天蝎座",consume = 738,attr = [{1,16926},{2,338520},{3,8463},{4,8463},{15,8463},{16,8463}],extra_attr = [{15,8463},{16,8463},{68,15600}]};

get_starmap_cfg(626) ->
	#base_star_map{star_map_id = 626,cons_id = 8,class_id = 9,point_id = 1,cons_name = "天蝎座",consume = 712,attr = [{1,17074},{2,338520},{3,8463},{4,8463},{15,8463},{16,8463}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(627) ->
	#base_star_map{star_map_id = 627,cons_id = 8,class_id = 9,point_id = 2,cons_name = "天蝎座",consume = 717,attr = [{1,17074},{2,341480},{3,8463},{4,8463},{15,8463},{16,8463}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(628) ->
	#base_star_map{star_map_id = 628,cons_id = 8,class_id = 9,point_id = 3,cons_name = "天蝎座",consume = 722,attr = [{1,17074},{2,341480},{3,8611},{4,8463},{15,8463},{16,8463}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(629) ->
	#base_star_map{star_map_id = 629,cons_id = 8,class_id = 9,point_id = 4,cons_name = "天蝎座",consume = 727,attr = [{1,17074},{2,341480},{3,8611},{4,8611},{15,8463},{16,8463}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(630) ->
	#base_star_map{star_map_id = 630,cons_id = 8,class_id = 9,point_id = 5,cons_name = "天蝎座",consume = 732,attr = [{1,17074},{2,341480},{3,8611},{4,8611},{15,8611},{16,8463}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(631) ->
	#base_star_map{star_map_id = 631,cons_id = 8,class_id = 9,point_id = 6,cons_name = "天蝎座",consume = 737,attr = [{1,17074},{2,341480},{3,8611},{4,8611},{15,8611},{16,8611}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(632) ->
	#base_star_map{star_map_id = 632,cons_id = 8,class_id = 9,point_id = 7,cons_name = "天蝎座",consume = 742,attr = [{1,17074},{2,344440},{3,8611},{4,8611},{15,8611},{16,8611}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(633) ->
	#base_star_map{star_map_id = 633,cons_id = 8,class_id = 9,point_id = 8,cons_name = "天蝎座",consume = 747,attr = [{1,17222},{2,344440},{3,8611},{4,8611},{15,8611},{16,8611}],extra_attr = [{15,8611},{16,8611},{68,15800}]};

get_starmap_cfg(634) ->
	#base_star_map{star_map_id = 634,cons_id = 8,class_id = 10,point_id = 1,cons_name = "天蝎座",consume = 721,attr = [{1,17371},{2,344440},{3,8611},{4,8611},{15,8611},{16,8611}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(635) ->
	#base_star_map{star_map_id = 635,cons_id = 8,class_id = 10,point_id = 2,cons_name = "天蝎座",consume = 726,attr = [{1,17371},{2,347420},{3,8611},{4,8611},{15,8611},{16,8611}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(636) ->
	#base_star_map{star_map_id = 636,cons_id = 8,class_id = 10,point_id = 3,cons_name = "天蝎座",consume = 731,attr = [{1,17371},{2,347420},{3,8760},{4,8611},{15,8611},{16,8611}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(637) ->
	#base_star_map{star_map_id = 637,cons_id = 8,class_id = 10,point_id = 4,cons_name = "天蝎座",consume = 736,attr = [{1,17371},{2,347420},{3,8760},{4,8760},{15,8611},{16,8611}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(638) ->
	#base_star_map{star_map_id = 638,cons_id = 8,class_id = 10,point_id = 5,cons_name = "天蝎座",consume = 741,attr = [{1,17371},{2,347420},{3,8760},{4,8760},{15,8760},{16,8611}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(639) ->
	#base_star_map{star_map_id = 639,cons_id = 8,class_id = 10,point_id = 6,cons_name = "天蝎座",consume = 746,attr = [{1,17371},{2,347420},{3,8760},{4,8760},{15,8760},{16,8760}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(640) ->
	#base_star_map{star_map_id = 640,cons_id = 8,class_id = 10,point_id = 7,cons_name = "天蝎座",consume = 751,attr = [{1,17371},{2,350400},{3,8760},{4,8760},{15,8760},{16,8760}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(641) ->
	#base_star_map{star_map_id = 641,cons_id = 8,class_id = 10,point_id = 8,cons_name = "天蝎座",consume = 756,attr = [{1,17520},{2,350400},{3,8760},{4,8760},{15,8760},{16,8760}],extra_attr = [{15,8760},{16,8760},{68,16000}]};

get_starmap_cfg(642) ->
	#base_star_map{star_map_id = 642,cons_id = 9,class_id = 1,point_id = 1,cons_name = "射手座",consume = 730,attr = [{1,17670},{2,350400},{3,8760},{4,8760},{15,8760},{16,8760}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(643) ->
	#base_star_map{star_map_id = 643,cons_id = 9,class_id = 1,point_id = 2,cons_name = "射手座",consume = 735,attr = [{1,17670},{2,353400},{3,8760},{4,8760},{15,8760},{16,8760}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(644) ->
	#base_star_map{star_map_id = 644,cons_id = 9,class_id = 1,point_id = 3,cons_name = "射手座",consume = 740,attr = [{1,17670},{2,353400},{3,8910},{4,8760},{15,8760},{16,8760}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(645) ->
	#base_star_map{star_map_id = 645,cons_id = 9,class_id = 1,point_id = 4,cons_name = "射手座",consume = 745,attr = [{1,17670},{2,353400},{3,8910},{4,8910},{15,8760},{16,8760}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(646) ->
	#base_star_map{star_map_id = 646,cons_id = 9,class_id = 1,point_id = 5,cons_name = "射手座",consume = 750,attr = [{1,17670},{2,353400},{3,8910},{4,8910},{15,8910},{16,8760}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(647) ->
	#base_star_map{star_map_id = 647,cons_id = 9,class_id = 1,point_id = 6,cons_name = "射手座",consume = 755,attr = [{1,17670},{2,353400},{3,8910},{4,8910},{15,8910},{16,8910}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(648) ->
	#base_star_map{star_map_id = 648,cons_id = 9,class_id = 1,point_id = 7,cons_name = "射手座",consume = 760,attr = [{1,17670},{2,356400},{3,8910},{4,8910},{15,8910},{16,8910}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(649) ->
	#base_star_map{star_map_id = 649,cons_id = 9,class_id = 1,point_id = 8,cons_name = "射手座",consume = 765,attr = [{1,17820},{2,356400},{3,8910},{4,8910},{15,8910},{16,8910}],extra_attr = [{15,8910},{16,8910},{68,16200}]};

get_starmap_cfg(650) ->
	#base_star_map{star_map_id = 650,cons_id = 9,class_id = 2,point_id = 1,cons_name = "射手座",consume = 739,attr = [{1,17971},{2,356400},{3,8910},{4,8910},{15,8910},{16,8910}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(651) ->
	#base_star_map{star_map_id = 651,cons_id = 9,class_id = 2,point_id = 2,cons_name = "射手座",consume = 744,attr = [{1,17971},{2,359420},{3,8910},{4,8910},{15,8910},{16,8910}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(652) ->
	#base_star_map{star_map_id = 652,cons_id = 9,class_id = 2,point_id = 3,cons_name = "射手座",consume = 749,attr = [{1,17971},{2,359420},{3,9061},{4,8910},{15,8910},{16,8910}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(653) ->
	#base_star_map{star_map_id = 653,cons_id = 9,class_id = 2,point_id = 4,cons_name = "射手座",consume = 754,attr = [{1,17971},{2,359420},{3,9061},{4,9061},{15,8910},{16,8910}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(654) ->
	#base_star_map{star_map_id = 654,cons_id = 9,class_id = 2,point_id = 5,cons_name = "射手座",consume = 759,attr = [{1,17971},{2,359420},{3,9061},{4,9061},{15,9061},{16,8910}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(655) ->
	#base_star_map{star_map_id = 655,cons_id = 9,class_id = 2,point_id = 6,cons_name = "射手座",consume = 764,attr = [{1,17971},{2,359420},{3,9061},{4,9061},{15,9061},{16,9061}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(656) ->
	#base_star_map{star_map_id = 656,cons_id = 9,class_id = 2,point_id = 7,cons_name = "射手座",consume = 769,attr = [{1,17971},{2,362440},{3,9061},{4,9061},{15,9061},{16,9061}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(657) ->
	#base_star_map{star_map_id = 657,cons_id = 9,class_id = 2,point_id = 8,cons_name = "射手座",consume = 774,attr = [{1,18122},{2,362440},{3,9061},{4,9061},{15,9061},{16,9061}],extra_attr = [{15,9061},{16,9061},{68,16400}]};

get_starmap_cfg(658) ->
	#base_star_map{star_map_id = 658,cons_id = 9,class_id = 3,point_id = 1,cons_name = "射手座",consume = 748,attr = [{1,18274},{2,362440},{3,9061},{4,9061},{15,9061},{16,9061}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(659) ->
	#base_star_map{star_map_id = 659,cons_id = 9,class_id = 3,point_id = 2,cons_name = "射手座",consume = 753,attr = [{1,18274},{2,365480},{3,9061},{4,9061},{15,9061},{16,9061}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(660) ->
	#base_star_map{star_map_id = 660,cons_id = 9,class_id = 3,point_id = 3,cons_name = "射手座",consume = 758,attr = [{1,18274},{2,365480},{3,9213},{4,9061},{15,9061},{16,9061}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(661) ->
	#base_star_map{star_map_id = 661,cons_id = 9,class_id = 3,point_id = 4,cons_name = "射手座",consume = 763,attr = [{1,18274},{2,365480},{3,9213},{4,9213},{15,9061},{16,9061}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(662) ->
	#base_star_map{star_map_id = 662,cons_id = 9,class_id = 3,point_id = 5,cons_name = "射手座",consume = 768,attr = [{1,18274},{2,365480},{3,9213},{4,9213},{15,9213},{16,9061}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(663) ->
	#base_star_map{star_map_id = 663,cons_id = 9,class_id = 3,point_id = 6,cons_name = "射手座",consume = 773,attr = [{1,18274},{2,365480},{3,9213},{4,9213},{15,9213},{16,9213}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(664) ->
	#base_star_map{star_map_id = 664,cons_id = 9,class_id = 3,point_id = 7,cons_name = "射手座",consume = 778,attr = [{1,18274},{2,368520},{3,9213},{4,9213},{15,9213},{16,9213}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(665) ->
	#base_star_map{star_map_id = 665,cons_id = 9,class_id = 3,point_id = 8,cons_name = "射手座",consume = 783,attr = [{1,18426},{2,368520},{3,9213},{4,9213},{15,9213},{16,9213}],extra_attr = [{15,9213},{16,9213},{68,16600}]};

get_starmap_cfg(666) ->
	#base_star_map{star_map_id = 666,cons_id = 9,class_id = 4,point_id = 1,cons_name = "射手座",consume = 757,attr = [{1,18579},{2,368520},{3,9213},{4,9213},{15,9213},{16,9213}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(667) ->
	#base_star_map{star_map_id = 667,cons_id = 9,class_id = 4,point_id = 2,cons_name = "射手座",consume = 762,attr = [{1,18579},{2,371580},{3,9213},{4,9213},{15,9213},{16,9213}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(668) ->
	#base_star_map{star_map_id = 668,cons_id = 9,class_id = 4,point_id = 3,cons_name = "射手座",consume = 767,attr = [{1,18579},{2,371580},{3,9366},{4,9213},{15,9213},{16,9213}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(669) ->
	#base_star_map{star_map_id = 669,cons_id = 9,class_id = 4,point_id = 4,cons_name = "射手座",consume = 772,attr = [{1,18579},{2,371580},{3,9366},{4,9366},{15,9213},{16,9213}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(670) ->
	#base_star_map{star_map_id = 670,cons_id = 9,class_id = 4,point_id = 5,cons_name = "射手座",consume = 777,attr = [{1,18579},{2,371580},{3,9366},{4,9366},{15,9366},{16,9213}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(671) ->
	#base_star_map{star_map_id = 671,cons_id = 9,class_id = 4,point_id = 6,cons_name = "射手座",consume = 782,attr = [{1,18579},{2,371580},{3,9366},{4,9366},{15,9366},{16,9366}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(672) ->
	#base_star_map{star_map_id = 672,cons_id = 9,class_id = 4,point_id = 7,cons_name = "射手座",consume = 787,attr = [{1,18579},{2,374640},{3,9366},{4,9366},{15,9366},{16,9366}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(673) ->
	#base_star_map{star_map_id = 673,cons_id = 9,class_id = 4,point_id = 8,cons_name = "射手座",consume = 792,attr = [{1,18732},{2,374640},{3,9366},{4,9366},{15,9366},{16,9366}],extra_attr = [{15,9366},{16,9366},{68,16800}]};

get_starmap_cfg(674) ->
	#base_star_map{star_map_id = 674,cons_id = 9,class_id = 5,point_id = 1,cons_name = "射手座",consume = 766,attr = [{1,18886},{2,374640},{3,9366},{4,9366},{15,9366},{16,9366}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(675) ->
	#base_star_map{star_map_id = 675,cons_id = 9,class_id = 5,point_id = 2,cons_name = "射手座",consume = 771,attr = [{1,18886},{2,377720},{3,9366},{4,9366},{15,9366},{16,9366}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(676) ->
	#base_star_map{star_map_id = 676,cons_id = 9,class_id = 5,point_id = 3,cons_name = "射手座",consume = 776,attr = [{1,18886},{2,377720},{3,9520},{4,9366},{15,9366},{16,9366}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(677) ->
	#base_star_map{star_map_id = 677,cons_id = 9,class_id = 5,point_id = 4,cons_name = "射手座",consume = 781,attr = [{1,18886},{2,377720},{3,9520},{4,9520},{15,9366},{16,9366}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(678) ->
	#base_star_map{star_map_id = 678,cons_id = 9,class_id = 5,point_id = 5,cons_name = "射手座",consume = 786,attr = [{1,18886},{2,377720},{3,9520},{4,9520},{15,9520},{16,9366}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(679) ->
	#base_star_map{star_map_id = 679,cons_id = 9,class_id = 5,point_id = 6,cons_name = "射手座",consume = 791,attr = [{1,18886},{2,377720},{3,9520},{4,9520},{15,9520},{16,9520}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(680) ->
	#base_star_map{star_map_id = 680,cons_id = 9,class_id = 5,point_id = 7,cons_name = "射手座",consume = 796,attr = [{1,18886},{2,380800},{3,9520},{4,9520},{15,9520},{16,9520}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(681) ->
	#base_star_map{star_map_id = 681,cons_id = 9,class_id = 5,point_id = 8,cons_name = "射手座",consume = 801,attr = [{1,19040},{2,380800},{3,9520},{4,9520},{15,9520},{16,9520}],extra_attr = [{15,9520},{16,9520},{68,17000}]};

get_starmap_cfg(682) ->
	#base_star_map{star_map_id = 682,cons_id = 9,class_id = 6,point_id = 1,cons_name = "射手座",consume = 775,attr = [{1,19195},{2,380800},{3,9520},{4,9520},{15,9520},{16,9520}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(683) ->
	#base_star_map{star_map_id = 683,cons_id = 9,class_id = 6,point_id = 2,cons_name = "射手座",consume = 780,attr = [{1,19195},{2,383900},{3,9520},{4,9520},{15,9520},{16,9520}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(684) ->
	#base_star_map{star_map_id = 684,cons_id = 9,class_id = 6,point_id = 3,cons_name = "射手座",consume = 785,attr = [{1,19195},{2,383900},{3,9675},{4,9520},{15,9520},{16,9520}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(685) ->
	#base_star_map{star_map_id = 685,cons_id = 9,class_id = 6,point_id = 4,cons_name = "射手座",consume = 790,attr = [{1,19195},{2,383900},{3,9675},{4,9675},{15,9520},{16,9520}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(686) ->
	#base_star_map{star_map_id = 686,cons_id = 9,class_id = 6,point_id = 5,cons_name = "射手座",consume = 795,attr = [{1,19195},{2,383900},{3,9675},{4,9675},{15,9675},{16,9520}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(687) ->
	#base_star_map{star_map_id = 687,cons_id = 9,class_id = 6,point_id = 6,cons_name = "射手座",consume = 800,attr = [{1,19195},{2,383900},{3,9675},{4,9675},{15,9675},{16,9675}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(688) ->
	#base_star_map{star_map_id = 688,cons_id = 9,class_id = 6,point_id = 7,cons_name = "射手座",consume = 805,attr = [{1,19195},{2,387000},{3,9675},{4,9675},{15,9675},{16,9675}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(689) ->
	#base_star_map{star_map_id = 689,cons_id = 9,class_id = 6,point_id = 8,cons_name = "射手座",consume = 810,attr = [{1,19350},{2,387000},{3,9675},{4,9675},{15,9675},{16,9675}],extra_attr = [{15,9675},{16,9675},{68,17200}]};

get_starmap_cfg(690) ->
	#base_star_map{star_map_id = 690,cons_id = 9,class_id = 7,point_id = 1,cons_name = "射手座",consume = 784,attr = [{1,19506},{2,387000},{3,9675},{4,9675},{15,9675},{16,9675}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(691) ->
	#base_star_map{star_map_id = 691,cons_id = 9,class_id = 7,point_id = 2,cons_name = "射手座",consume = 789,attr = [{1,19506},{2,390120},{3,9675},{4,9675},{15,9675},{16,9675}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(692) ->
	#base_star_map{star_map_id = 692,cons_id = 9,class_id = 7,point_id = 3,cons_name = "射手座",consume = 794,attr = [{1,19506},{2,390120},{3,9831},{4,9675},{15,9675},{16,9675}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(693) ->
	#base_star_map{star_map_id = 693,cons_id = 9,class_id = 7,point_id = 4,cons_name = "射手座",consume = 799,attr = [{1,19506},{2,390120},{3,9831},{4,9831},{15,9675},{16,9675}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(694) ->
	#base_star_map{star_map_id = 694,cons_id = 9,class_id = 7,point_id = 5,cons_name = "射手座",consume = 804,attr = [{1,19506},{2,390120},{3,9831},{4,9831},{15,9831},{16,9675}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(695) ->
	#base_star_map{star_map_id = 695,cons_id = 9,class_id = 7,point_id = 6,cons_name = "射手座",consume = 809,attr = [{1,19506},{2,390120},{3,9831},{4,9831},{15,9831},{16,9831}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(696) ->
	#base_star_map{star_map_id = 696,cons_id = 9,class_id = 7,point_id = 7,cons_name = "射手座",consume = 814,attr = [{1,19506},{2,393240},{3,9831},{4,9831},{15,9831},{16,9831}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(697) ->
	#base_star_map{star_map_id = 697,cons_id = 9,class_id = 7,point_id = 8,cons_name = "射手座",consume = 819,attr = [{1,19662},{2,393240},{3,9831},{4,9831},{15,9831},{16,9831}],extra_attr = [{15,9831},{16,9831},{68,17400}]};

get_starmap_cfg(698) ->
	#base_star_map{star_map_id = 698,cons_id = 9,class_id = 8,point_id = 1,cons_name = "射手座",consume = 793,attr = [{1,19819},{2,393240},{3,9831},{4,9831},{15,9831},{16,9831}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(699) ->
	#base_star_map{star_map_id = 699,cons_id = 9,class_id = 8,point_id = 2,cons_name = "射手座",consume = 798,attr = [{1,19819},{2,396380},{3,9831},{4,9831},{15,9831},{16,9831}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(700) ->
	#base_star_map{star_map_id = 700,cons_id = 9,class_id = 8,point_id = 3,cons_name = "射手座",consume = 803,attr = [{1,19819},{2,396380},{3,9988},{4,9831},{15,9831},{16,9831}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(701) ->
	#base_star_map{star_map_id = 701,cons_id = 9,class_id = 8,point_id = 4,cons_name = "射手座",consume = 808,attr = [{1,19819},{2,396380},{3,9988},{4,9988},{15,9831},{16,9831}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(702) ->
	#base_star_map{star_map_id = 702,cons_id = 9,class_id = 8,point_id = 5,cons_name = "射手座",consume = 813,attr = [{1,19819},{2,396380},{3,9988},{4,9988},{15,9988},{16,9831}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(703) ->
	#base_star_map{star_map_id = 703,cons_id = 9,class_id = 8,point_id = 6,cons_name = "射手座",consume = 818,attr = [{1,19819},{2,396380},{3,9988},{4,9988},{15,9988},{16,9988}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(704) ->
	#base_star_map{star_map_id = 704,cons_id = 9,class_id = 8,point_id = 7,cons_name = "射手座",consume = 823,attr = [{1,19819},{2,399520},{3,9988},{4,9988},{15,9988},{16,9988}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(705) ->
	#base_star_map{star_map_id = 705,cons_id = 9,class_id = 8,point_id = 8,cons_name = "射手座",consume = 828,attr = [{1,19976},{2,399520},{3,9988},{4,9988},{15,9988},{16,9988}],extra_attr = [{15,9988},{16,9988},{68,17600}]};

get_starmap_cfg(706) ->
	#base_star_map{star_map_id = 706,cons_id = 9,class_id = 9,point_id = 1,cons_name = "射手座",consume = 802,attr = [{1,20134},{2,399520},{3,9988},{4,9988},{15,9988},{16,9988}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(707) ->
	#base_star_map{star_map_id = 707,cons_id = 9,class_id = 9,point_id = 2,cons_name = "射手座",consume = 807,attr = [{1,20134},{2,402680},{3,9988},{4,9988},{15,9988},{16,9988}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(708) ->
	#base_star_map{star_map_id = 708,cons_id = 9,class_id = 9,point_id = 3,cons_name = "射手座",consume = 812,attr = [{1,20134},{2,402680},{3,10146},{4,9988},{15,9988},{16,9988}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(709) ->
	#base_star_map{star_map_id = 709,cons_id = 9,class_id = 9,point_id = 4,cons_name = "射手座",consume = 817,attr = [{1,20134},{2,402680},{3,10146},{4,10146},{15,9988},{16,9988}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(710) ->
	#base_star_map{star_map_id = 710,cons_id = 9,class_id = 9,point_id = 5,cons_name = "射手座",consume = 822,attr = [{1,20134},{2,402680},{3,10146},{4,10146},{15,10146},{16,9988}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(711) ->
	#base_star_map{star_map_id = 711,cons_id = 9,class_id = 9,point_id = 6,cons_name = "射手座",consume = 827,attr = [{1,20134},{2,402680},{3,10146},{4,10146},{15,10146},{16,10146}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(712) ->
	#base_star_map{star_map_id = 712,cons_id = 9,class_id = 9,point_id = 7,cons_name = "射手座",consume = 832,attr = [{1,20134},{2,405840},{3,10146},{4,10146},{15,10146},{16,10146}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(713) ->
	#base_star_map{star_map_id = 713,cons_id = 9,class_id = 9,point_id = 8,cons_name = "射手座",consume = 837,attr = [{1,20292},{2,405840},{3,10146},{4,10146},{15,10146},{16,10146}],extra_attr = [{15,10146},{16,10146},{68,17800}]};

get_starmap_cfg(714) ->
	#base_star_map{star_map_id = 714,cons_id = 9,class_id = 10,point_id = 1,cons_name = "射手座",consume = 811,attr = [{1,20451},{2,405840},{3,10146},{4,10146},{15,10146},{16,10146}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(715) ->
	#base_star_map{star_map_id = 715,cons_id = 9,class_id = 10,point_id = 2,cons_name = "射手座",consume = 816,attr = [{1,20451},{2,409020},{3,10146},{4,10146},{15,10146},{16,10146}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(716) ->
	#base_star_map{star_map_id = 716,cons_id = 9,class_id = 10,point_id = 3,cons_name = "射手座",consume = 821,attr = [{1,20451},{2,409020},{3,10305},{4,10146},{15,10146},{16,10146}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(717) ->
	#base_star_map{star_map_id = 717,cons_id = 9,class_id = 10,point_id = 4,cons_name = "射手座",consume = 826,attr = [{1,20451},{2,409020},{3,10305},{4,10305},{15,10146},{16,10146}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(718) ->
	#base_star_map{star_map_id = 718,cons_id = 9,class_id = 10,point_id = 5,cons_name = "射手座",consume = 831,attr = [{1,20451},{2,409020},{3,10305},{4,10305},{15,10305},{16,10146}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(719) ->
	#base_star_map{star_map_id = 719,cons_id = 9,class_id = 10,point_id = 6,cons_name = "射手座",consume = 836,attr = [{1,20451},{2,409020},{3,10305},{4,10305},{15,10305},{16,10305}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(720) ->
	#base_star_map{star_map_id = 720,cons_id = 9,class_id = 10,point_id = 7,cons_name = "射手座",consume = 841,attr = [{1,20451},{2,412200},{3,10305},{4,10305},{15,10305},{16,10305}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(721) ->
	#base_star_map{star_map_id = 721,cons_id = 9,class_id = 10,point_id = 8,cons_name = "射手座",consume = 846,attr = [{1,20610},{2,412200},{3,10305},{4,10305},{15,10305},{16,10305}],extra_attr = [{15,10305},{16,10305},{68,18000}]};

get_starmap_cfg(722) ->
	#base_star_map{star_map_id = 722,cons_id = 10,class_id = 1,point_id = 1,cons_name = "摩羯座",consume = 820,attr = [{1,20770},{2,412200},{3,10305},{4,10305},{15,10305},{16,10305}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(723) ->
	#base_star_map{star_map_id = 723,cons_id = 10,class_id = 1,point_id = 2,cons_name = "摩羯座",consume = 825,attr = [{1,20770},{2,415400},{3,10305},{4,10305},{15,10305},{16,10305}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(724) ->
	#base_star_map{star_map_id = 724,cons_id = 10,class_id = 1,point_id = 3,cons_name = "摩羯座",consume = 830,attr = [{1,20770},{2,415400},{3,10465},{4,10305},{15,10305},{16,10305}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(725) ->
	#base_star_map{star_map_id = 725,cons_id = 10,class_id = 1,point_id = 4,cons_name = "摩羯座",consume = 835,attr = [{1,20770},{2,415400},{3,10465},{4,10465},{15,10305},{16,10305}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(726) ->
	#base_star_map{star_map_id = 726,cons_id = 10,class_id = 1,point_id = 5,cons_name = "摩羯座",consume = 840,attr = [{1,20770},{2,415400},{3,10465},{4,10465},{15,10465},{16,10305}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(727) ->
	#base_star_map{star_map_id = 727,cons_id = 10,class_id = 1,point_id = 6,cons_name = "摩羯座",consume = 845,attr = [{1,20770},{2,415400},{3,10465},{4,10465},{15,10465},{16,10465}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(728) ->
	#base_star_map{star_map_id = 728,cons_id = 10,class_id = 1,point_id = 7,cons_name = "摩羯座",consume = 850,attr = [{1,20770},{2,418600},{3,10465},{4,10465},{15,10465},{16,10465}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(729) ->
	#base_star_map{star_map_id = 729,cons_id = 10,class_id = 1,point_id = 8,cons_name = "摩羯座",consume = 855,attr = [{1,20930},{2,418600},{3,10465},{4,10465},{15,10465},{16,10465}],extra_attr = [{15,10465},{16,10465},{68,18200}]};

get_starmap_cfg(730) ->
	#base_star_map{star_map_id = 730,cons_id = 10,class_id = 2,point_id = 1,cons_name = "摩羯座",consume = 829,attr = [{1,21091},{2,418600},{3,10465},{4,10465},{15,10465},{16,10465}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(731) ->
	#base_star_map{star_map_id = 731,cons_id = 10,class_id = 2,point_id = 2,cons_name = "摩羯座",consume = 834,attr = [{1,21091},{2,421820},{3,10465},{4,10465},{15,10465},{16,10465}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(732) ->
	#base_star_map{star_map_id = 732,cons_id = 10,class_id = 2,point_id = 3,cons_name = "摩羯座",consume = 839,attr = [{1,21091},{2,421820},{3,10626},{4,10465},{15,10465},{16,10465}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(733) ->
	#base_star_map{star_map_id = 733,cons_id = 10,class_id = 2,point_id = 4,cons_name = "摩羯座",consume = 844,attr = [{1,21091},{2,421820},{3,10626},{4,10626},{15,10465},{16,10465}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(734) ->
	#base_star_map{star_map_id = 734,cons_id = 10,class_id = 2,point_id = 5,cons_name = "摩羯座",consume = 849,attr = [{1,21091},{2,421820},{3,10626},{4,10626},{15,10626},{16,10465}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(735) ->
	#base_star_map{star_map_id = 735,cons_id = 10,class_id = 2,point_id = 6,cons_name = "摩羯座",consume = 854,attr = [{1,21091},{2,421820},{3,10626},{4,10626},{15,10626},{16,10626}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(736) ->
	#base_star_map{star_map_id = 736,cons_id = 10,class_id = 2,point_id = 7,cons_name = "摩羯座",consume = 859,attr = [{1,21091},{2,425040},{3,10626},{4,10626},{15,10626},{16,10626}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(737) ->
	#base_star_map{star_map_id = 737,cons_id = 10,class_id = 2,point_id = 8,cons_name = "摩羯座",consume = 864,attr = [{1,21252},{2,425040},{3,10626},{4,10626},{15,10626},{16,10626}],extra_attr = [{15,10626},{16,10626},{68,18400}]};

get_starmap_cfg(738) ->
	#base_star_map{star_map_id = 738,cons_id = 10,class_id = 3,point_id = 1,cons_name = "摩羯座",consume = 838,attr = [{1,21414},{2,425040},{3,10626},{4,10626},{15,10626},{16,10626}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(739) ->
	#base_star_map{star_map_id = 739,cons_id = 10,class_id = 3,point_id = 2,cons_name = "摩羯座",consume = 843,attr = [{1,21414},{2,428280},{3,10626},{4,10626},{15,10626},{16,10626}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(740) ->
	#base_star_map{star_map_id = 740,cons_id = 10,class_id = 3,point_id = 3,cons_name = "摩羯座",consume = 848,attr = [{1,21414},{2,428280},{3,10788},{4,10626},{15,10626},{16,10626}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(741) ->
	#base_star_map{star_map_id = 741,cons_id = 10,class_id = 3,point_id = 4,cons_name = "摩羯座",consume = 853,attr = [{1,21414},{2,428280},{3,10788},{4,10788},{15,10626},{16,10626}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(742) ->
	#base_star_map{star_map_id = 742,cons_id = 10,class_id = 3,point_id = 5,cons_name = "摩羯座",consume = 858,attr = [{1,21414},{2,428280},{3,10788},{4,10788},{15,10788},{16,10626}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(743) ->
	#base_star_map{star_map_id = 743,cons_id = 10,class_id = 3,point_id = 6,cons_name = "摩羯座",consume = 863,attr = [{1,21414},{2,428280},{3,10788},{4,10788},{15,10788},{16,10788}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(744) ->
	#base_star_map{star_map_id = 744,cons_id = 10,class_id = 3,point_id = 7,cons_name = "摩羯座",consume = 868,attr = [{1,21414},{2,431520},{3,10788},{4,10788},{15,10788},{16,10788}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(745) ->
	#base_star_map{star_map_id = 745,cons_id = 10,class_id = 3,point_id = 8,cons_name = "摩羯座",consume = 873,attr = [{1,21576},{2,431520},{3,10788},{4,10788},{15,10788},{16,10788}],extra_attr = [{15,10788},{16,10788},{68,18600}]};

get_starmap_cfg(746) ->
	#base_star_map{star_map_id = 746,cons_id = 10,class_id = 4,point_id = 1,cons_name = "摩羯座",consume = 847,attr = [{1,21739},{2,431520},{3,10788},{4,10788},{15,10788},{16,10788}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(747) ->
	#base_star_map{star_map_id = 747,cons_id = 10,class_id = 4,point_id = 2,cons_name = "摩羯座",consume = 852,attr = [{1,21739},{2,434780},{3,10788},{4,10788},{15,10788},{16,10788}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(748) ->
	#base_star_map{star_map_id = 748,cons_id = 10,class_id = 4,point_id = 3,cons_name = "摩羯座",consume = 857,attr = [{1,21739},{2,434780},{3,10951},{4,10788},{15,10788},{16,10788}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(749) ->
	#base_star_map{star_map_id = 749,cons_id = 10,class_id = 4,point_id = 4,cons_name = "摩羯座",consume = 862,attr = [{1,21739},{2,434780},{3,10951},{4,10951},{15,10788},{16,10788}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(750) ->
	#base_star_map{star_map_id = 750,cons_id = 10,class_id = 4,point_id = 5,cons_name = "摩羯座",consume = 867,attr = [{1,21739},{2,434780},{3,10951},{4,10951},{15,10951},{16,10788}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(751) ->
	#base_star_map{star_map_id = 751,cons_id = 10,class_id = 4,point_id = 6,cons_name = "摩羯座",consume = 872,attr = [{1,21739},{2,434780},{3,10951},{4,10951},{15,10951},{16,10951}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(752) ->
	#base_star_map{star_map_id = 752,cons_id = 10,class_id = 4,point_id = 7,cons_name = "摩羯座",consume = 877,attr = [{1,21739},{2,438040},{3,10951},{4,10951},{15,10951},{16,10951}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(753) ->
	#base_star_map{star_map_id = 753,cons_id = 10,class_id = 4,point_id = 8,cons_name = "摩羯座",consume = 882,attr = [{1,21902},{2,438040},{3,10951},{4,10951},{15,10951},{16,10951}],extra_attr = [{15,10951},{16,10951},{68,18800}]};

get_starmap_cfg(754) ->
	#base_star_map{star_map_id = 754,cons_id = 10,class_id = 5,point_id = 1,cons_name = "摩羯座",consume = 856,attr = [{1,22066},{2,438040},{3,10951},{4,10951},{15,10951},{16,10951}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(755) ->
	#base_star_map{star_map_id = 755,cons_id = 10,class_id = 5,point_id = 2,cons_name = "摩羯座",consume = 861,attr = [{1,22066},{2,441320},{3,10951},{4,10951},{15,10951},{16,10951}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(756) ->
	#base_star_map{star_map_id = 756,cons_id = 10,class_id = 5,point_id = 3,cons_name = "摩羯座",consume = 866,attr = [{1,22066},{2,441320},{3,11115},{4,10951},{15,10951},{16,10951}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(757) ->
	#base_star_map{star_map_id = 757,cons_id = 10,class_id = 5,point_id = 4,cons_name = "摩羯座",consume = 871,attr = [{1,22066},{2,441320},{3,11115},{4,11115},{15,10951},{16,10951}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(758) ->
	#base_star_map{star_map_id = 758,cons_id = 10,class_id = 5,point_id = 5,cons_name = "摩羯座",consume = 876,attr = [{1,22066},{2,441320},{3,11115},{4,11115},{15,11115},{16,10951}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(759) ->
	#base_star_map{star_map_id = 759,cons_id = 10,class_id = 5,point_id = 6,cons_name = "摩羯座",consume = 881,attr = [{1,22066},{2,441320},{3,11115},{4,11115},{15,11115},{16,11115}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(760) ->
	#base_star_map{star_map_id = 760,cons_id = 10,class_id = 5,point_id = 7,cons_name = "摩羯座",consume = 886,attr = [{1,22066},{2,444600},{3,11115},{4,11115},{15,11115},{16,11115}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(761) ->
	#base_star_map{star_map_id = 761,cons_id = 10,class_id = 5,point_id = 8,cons_name = "摩羯座",consume = 891,attr = [{1,22230},{2,444600},{3,11115},{4,11115},{15,11115},{16,11115}],extra_attr = [{15,11115},{16,11115},{68,19000}]};

get_starmap_cfg(762) ->
	#base_star_map{star_map_id = 762,cons_id = 10,class_id = 6,point_id = 1,cons_name = "摩羯座",consume = 865,attr = [{1,22395},{2,444600},{3,11115},{4,11115},{15,11115},{16,11115}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(763) ->
	#base_star_map{star_map_id = 763,cons_id = 10,class_id = 6,point_id = 2,cons_name = "摩羯座",consume = 870,attr = [{1,22395},{2,447900},{3,11115},{4,11115},{15,11115},{16,11115}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(764) ->
	#base_star_map{star_map_id = 764,cons_id = 10,class_id = 6,point_id = 3,cons_name = "摩羯座",consume = 875,attr = [{1,22395},{2,447900},{3,11280},{4,11115},{15,11115},{16,11115}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(765) ->
	#base_star_map{star_map_id = 765,cons_id = 10,class_id = 6,point_id = 4,cons_name = "摩羯座",consume = 880,attr = [{1,22395},{2,447900},{3,11280},{4,11280},{15,11115},{16,11115}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(766) ->
	#base_star_map{star_map_id = 766,cons_id = 10,class_id = 6,point_id = 5,cons_name = "摩羯座",consume = 885,attr = [{1,22395},{2,447900},{3,11280},{4,11280},{15,11280},{16,11115}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(767) ->
	#base_star_map{star_map_id = 767,cons_id = 10,class_id = 6,point_id = 6,cons_name = "摩羯座",consume = 890,attr = [{1,22395},{2,447900},{3,11280},{4,11280},{15,11280},{16,11280}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(768) ->
	#base_star_map{star_map_id = 768,cons_id = 10,class_id = 6,point_id = 7,cons_name = "摩羯座",consume = 895,attr = [{1,22395},{2,451200},{3,11280},{4,11280},{15,11280},{16,11280}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(769) ->
	#base_star_map{star_map_id = 769,cons_id = 10,class_id = 6,point_id = 8,cons_name = "摩羯座",consume = 900,attr = [{1,22560},{2,451200},{3,11280},{4,11280},{15,11280},{16,11280}],extra_attr = [{15,11280},{16,11280},{68,19200}]};

get_starmap_cfg(770) ->
	#base_star_map{star_map_id = 770,cons_id = 10,class_id = 7,point_id = 1,cons_name = "摩羯座",consume = 874,attr = [{1,22726},{2,451200},{3,11280},{4,11280},{15,11280},{16,11280}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(771) ->
	#base_star_map{star_map_id = 771,cons_id = 10,class_id = 7,point_id = 2,cons_name = "摩羯座",consume = 879,attr = [{1,22726},{2,454520},{3,11280},{4,11280},{15,11280},{16,11280}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(772) ->
	#base_star_map{star_map_id = 772,cons_id = 10,class_id = 7,point_id = 3,cons_name = "摩羯座",consume = 884,attr = [{1,22726},{2,454520},{3,11446},{4,11280},{15,11280},{16,11280}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(773) ->
	#base_star_map{star_map_id = 773,cons_id = 10,class_id = 7,point_id = 4,cons_name = "摩羯座",consume = 889,attr = [{1,22726},{2,454520},{3,11446},{4,11446},{15,11280},{16,11280}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(774) ->
	#base_star_map{star_map_id = 774,cons_id = 10,class_id = 7,point_id = 5,cons_name = "摩羯座",consume = 894,attr = [{1,22726},{2,454520},{3,11446},{4,11446},{15,11446},{16,11280}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(775) ->
	#base_star_map{star_map_id = 775,cons_id = 10,class_id = 7,point_id = 6,cons_name = "摩羯座",consume = 899,attr = [{1,22726},{2,454520},{3,11446},{4,11446},{15,11446},{16,11446}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(776) ->
	#base_star_map{star_map_id = 776,cons_id = 10,class_id = 7,point_id = 7,cons_name = "摩羯座",consume = 904,attr = [{1,22726},{2,457840},{3,11446},{4,11446},{15,11446},{16,11446}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(777) ->
	#base_star_map{star_map_id = 777,cons_id = 10,class_id = 7,point_id = 8,cons_name = "摩羯座",consume = 909,attr = [{1,22892},{2,457840},{3,11446},{4,11446},{15,11446},{16,11446}],extra_attr = [{15,11446},{16,11446},{68,19400}]};

get_starmap_cfg(778) ->
	#base_star_map{star_map_id = 778,cons_id = 10,class_id = 8,point_id = 1,cons_name = "摩羯座",consume = 883,attr = [{1,23059},{2,457840},{3,11446},{4,11446},{15,11446},{16,11446}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(779) ->
	#base_star_map{star_map_id = 779,cons_id = 10,class_id = 8,point_id = 2,cons_name = "摩羯座",consume = 888,attr = [{1,23059},{2,461180},{3,11446},{4,11446},{15,11446},{16,11446}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(780) ->
	#base_star_map{star_map_id = 780,cons_id = 10,class_id = 8,point_id = 3,cons_name = "摩羯座",consume = 893,attr = [{1,23059},{2,461180},{3,11613},{4,11446},{15,11446},{16,11446}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(781) ->
	#base_star_map{star_map_id = 781,cons_id = 10,class_id = 8,point_id = 4,cons_name = "摩羯座",consume = 898,attr = [{1,23059},{2,461180},{3,11613},{4,11613},{15,11446},{16,11446}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(782) ->
	#base_star_map{star_map_id = 782,cons_id = 10,class_id = 8,point_id = 5,cons_name = "摩羯座",consume = 903,attr = [{1,23059},{2,461180},{3,11613},{4,11613},{15,11613},{16,11446}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(783) ->
	#base_star_map{star_map_id = 783,cons_id = 10,class_id = 8,point_id = 6,cons_name = "摩羯座",consume = 908,attr = [{1,23059},{2,461180},{3,11613},{4,11613},{15,11613},{16,11613}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(784) ->
	#base_star_map{star_map_id = 784,cons_id = 10,class_id = 8,point_id = 7,cons_name = "摩羯座",consume = 913,attr = [{1,23059},{2,464520},{3,11613},{4,11613},{15,11613},{16,11613}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(785) ->
	#base_star_map{star_map_id = 785,cons_id = 10,class_id = 8,point_id = 8,cons_name = "摩羯座",consume = 918,attr = [{1,23226},{2,464520},{3,11613},{4,11613},{15,11613},{16,11613}],extra_attr = [{15,11613},{16,11613},{68,19600}]};

get_starmap_cfg(786) ->
	#base_star_map{star_map_id = 786,cons_id = 10,class_id = 9,point_id = 1,cons_name = "摩羯座",consume = 892,attr = [{1,23394},{2,464520},{3,11613},{4,11613},{15,11613},{16,11613}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(787) ->
	#base_star_map{star_map_id = 787,cons_id = 10,class_id = 9,point_id = 2,cons_name = "摩羯座",consume = 897,attr = [{1,23394},{2,467880},{3,11613},{4,11613},{15,11613},{16,11613}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(788) ->
	#base_star_map{star_map_id = 788,cons_id = 10,class_id = 9,point_id = 3,cons_name = "摩羯座",consume = 902,attr = [{1,23394},{2,467880},{3,11781},{4,11613},{15,11613},{16,11613}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(789) ->
	#base_star_map{star_map_id = 789,cons_id = 10,class_id = 9,point_id = 4,cons_name = "摩羯座",consume = 907,attr = [{1,23394},{2,467880},{3,11781},{4,11781},{15,11613},{16,11613}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(790) ->
	#base_star_map{star_map_id = 790,cons_id = 10,class_id = 9,point_id = 5,cons_name = "摩羯座",consume = 912,attr = [{1,23394},{2,467880},{3,11781},{4,11781},{15,11781},{16,11613}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(791) ->
	#base_star_map{star_map_id = 791,cons_id = 10,class_id = 9,point_id = 6,cons_name = "摩羯座",consume = 917,attr = [{1,23394},{2,467880},{3,11781},{4,11781},{15,11781},{16,11781}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(792) ->
	#base_star_map{star_map_id = 792,cons_id = 10,class_id = 9,point_id = 7,cons_name = "摩羯座",consume = 922,attr = [{1,23394},{2,471240},{3,11781},{4,11781},{15,11781},{16,11781}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(793) ->
	#base_star_map{star_map_id = 793,cons_id = 10,class_id = 9,point_id = 8,cons_name = "摩羯座",consume = 927,attr = [{1,23562},{2,471240},{3,11781},{4,11781},{15,11781},{16,11781}],extra_attr = [{15,11781},{16,11781},{68,19800}]};

get_starmap_cfg(794) ->
	#base_star_map{star_map_id = 794,cons_id = 10,class_id = 10,point_id = 1,cons_name = "摩羯座",consume = 901,attr = [{1,23731},{2,471240},{3,11781},{4,11781},{15,11781},{16,11781}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(795) ->
	#base_star_map{star_map_id = 795,cons_id = 10,class_id = 10,point_id = 2,cons_name = "摩羯座",consume = 906,attr = [{1,23731},{2,474620},{3,11781},{4,11781},{15,11781},{16,11781}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(796) ->
	#base_star_map{star_map_id = 796,cons_id = 10,class_id = 10,point_id = 3,cons_name = "摩羯座",consume = 911,attr = [{1,23731},{2,474620},{3,11950},{4,11781},{15,11781},{16,11781}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(797) ->
	#base_star_map{star_map_id = 797,cons_id = 10,class_id = 10,point_id = 4,cons_name = "摩羯座",consume = 916,attr = [{1,23731},{2,474620},{3,11950},{4,11950},{15,11781},{16,11781}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(798) ->
	#base_star_map{star_map_id = 798,cons_id = 10,class_id = 10,point_id = 5,cons_name = "摩羯座",consume = 921,attr = [{1,23731},{2,474620},{3,11950},{4,11950},{15,11950},{16,11781}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(799) ->
	#base_star_map{star_map_id = 799,cons_id = 10,class_id = 10,point_id = 6,cons_name = "摩羯座",consume = 926,attr = [{1,23731},{2,474620},{3,11950},{4,11950},{15,11950},{16,11950}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(800) ->
	#base_star_map{star_map_id = 800,cons_id = 10,class_id = 10,point_id = 7,cons_name = "摩羯座",consume = 931,attr = [{1,23731},{2,478000},{3,11950},{4,11950},{15,11950},{16,11950}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(801) ->
	#base_star_map{star_map_id = 801,cons_id = 10,class_id = 10,point_id = 8,cons_name = "摩羯座",consume = 936,attr = [{1,23900},{2,478000},{3,11950},{4,11950},{15,11950},{16,11950}],extra_attr = [{15,11950},{16,11950},{68,20000}]};

get_starmap_cfg(802) ->
	#base_star_map{star_map_id = 802,cons_id = 11,class_id = 1,point_id = 1,cons_name = "水瓶座",consume = 910,attr = [{1,24070},{2,478000},{3,11950},{4,11950},{15,11950},{16,11950}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(803) ->
	#base_star_map{star_map_id = 803,cons_id = 11,class_id = 1,point_id = 2,cons_name = "水瓶座",consume = 915,attr = [{1,24070},{2,481400},{3,11950},{4,11950},{15,11950},{16,11950}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(804) ->
	#base_star_map{star_map_id = 804,cons_id = 11,class_id = 1,point_id = 3,cons_name = "水瓶座",consume = 920,attr = [{1,24070},{2,481400},{3,12120},{4,11950},{15,11950},{16,11950}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(805) ->
	#base_star_map{star_map_id = 805,cons_id = 11,class_id = 1,point_id = 4,cons_name = "水瓶座",consume = 925,attr = [{1,24070},{2,481400},{3,12120},{4,12120},{15,11950},{16,11950}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(806) ->
	#base_star_map{star_map_id = 806,cons_id = 11,class_id = 1,point_id = 5,cons_name = "水瓶座",consume = 930,attr = [{1,24070},{2,481400},{3,12120},{4,12120},{15,12120},{16,11950}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(807) ->
	#base_star_map{star_map_id = 807,cons_id = 11,class_id = 1,point_id = 6,cons_name = "水瓶座",consume = 935,attr = [{1,24070},{2,481400},{3,12120},{4,12120},{15,12120},{16,12120}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(808) ->
	#base_star_map{star_map_id = 808,cons_id = 11,class_id = 1,point_id = 7,cons_name = "水瓶座",consume = 940,attr = [{1,24070},{2,484800},{3,12120},{4,12120},{15,12120},{16,12120}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(809) ->
	#base_star_map{star_map_id = 809,cons_id = 11,class_id = 1,point_id = 8,cons_name = "水瓶座",consume = 945,attr = [{1,24240},{2,484800},{3,12120},{4,12120},{15,12120},{16,12120}],extra_attr = [{15,12120},{16,12120},{68,20200}]};

get_starmap_cfg(810) ->
	#base_star_map{star_map_id = 810,cons_id = 11,class_id = 2,point_id = 1,cons_name = "水瓶座",consume = 919,attr = [{1,24411},{2,484800},{3,12120},{4,12120},{15,12120},{16,12120}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(811) ->
	#base_star_map{star_map_id = 811,cons_id = 11,class_id = 2,point_id = 2,cons_name = "水瓶座",consume = 924,attr = [{1,24411},{2,488220},{3,12120},{4,12120},{15,12120},{16,12120}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(812) ->
	#base_star_map{star_map_id = 812,cons_id = 11,class_id = 2,point_id = 3,cons_name = "水瓶座",consume = 929,attr = [{1,24411},{2,488220},{3,12291},{4,12120},{15,12120},{16,12120}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(813) ->
	#base_star_map{star_map_id = 813,cons_id = 11,class_id = 2,point_id = 4,cons_name = "水瓶座",consume = 934,attr = [{1,24411},{2,488220},{3,12291},{4,12291},{15,12120},{16,12120}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(814) ->
	#base_star_map{star_map_id = 814,cons_id = 11,class_id = 2,point_id = 5,cons_name = "水瓶座",consume = 939,attr = [{1,24411},{2,488220},{3,12291},{4,12291},{15,12291},{16,12120}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(815) ->
	#base_star_map{star_map_id = 815,cons_id = 11,class_id = 2,point_id = 6,cons_name = "水瓶座",consume = 944,attr = [{1,24411},{2,488220},{3,12291},{4,12291},{15,12291},{16,12291}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(816) ->
	#base_star_map{star_map_id = 816,cons_id = 11,class_id = 2,point_id = 7,cons_name = "水瓶座",consume = 949,attr = [{1,24411},{2,491640},{3,12291},{4,12291},{15,12291},{16,12291}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(817) ->
	#base_star_map{star_map_id = 817,cons_id = 11,class_id = 2,point_id = 8,cons_name = "水瓶座",consume = 954,attr = [{1,24582},{2,491640},{3,12291},{4,12291},{15,12291},{16,12291}],extra_attr = [{15,12291},{16,12291},{68,20400}]};

get_starmap_cfg(818) ->
	#base_star_map{star_map_id = 818,cons_id = 11,class_id = 3,point_id = 1,cons_name = "水瓶座",consume = 928,attr = [{1,24754},{2,491640},{3,12291},{4,12291},{15,12291},{16,12291}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(819) ->
	#base_star_map{star_map_id = 819,cons_id = 11,class_id = 3,point_id = 2,cons_name = "水瓶座",consume = 933,attr = [{1,24754},{2,495080},{3,12291},{4,12291},{15,12291},{16,12291}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(820) ->
	#base_star_map{star_map_id = 820,cons_id = 11,class_id = 3,point_id = 3,cons_name = "水瓶座",consume = 938,attr = [{1,24754},{2,495080},{3,12463},{4,12291},{15,12291},{16,12291}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(821) ->
	#base_star_map{star_map_id = 821,cons_id = 11,class_id = 3,point_id = 4,cons_name = "水瓶座",consume = 943,attr = [{1,24754},{2,495080},{3,12463},{4,12463},{15,12291},{16,12291}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(822) ->
	#base_star_map{star_map_id = 822,cons_id = 11,class_id = 3,point_id = 5,cons_name = "水瓶座",consume = 948,attr = [{1,24754},{2,495080},{3,12463},{4,12463},{15,12463},{16,12291}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(823) ->
	#base_star_map{star_map_id = 823,cons_id = 11,class_id = 3,point_id = 6,cons_name = "水瓶座",consume = 953,attr = [{1,24754},{2,495080},{3,12463},{4,12463},{15,12463},{16,12463}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(824) ->
	#base_star_map{star_map_id = 824,cons_id = 11,class_id = 3,point_id = 7,cons_name = "水瓶座",consume = 958,attr = [{1,24754},{2,498520},{3,12463},{4,12463},{15,12463},{16,12463}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(825) ->
	#base_star_map{star_map_id = 825,cons_id = 11,class_id = 3,point_id = 8,cons_name = "水瓶座",consume = 963,attr = [{1,24926},{2,498520},{3,12463},{4,12463},{15,12463},{16,12463}],extra_attr = [{15,12463},{16,12463},{68,20600}]};

get_starmap_cfg(826) ->
	#base_star_map{star_map_id = 826,cons_id = 11,class_id = 4,point_id = 1,cons_name = "水瓶座",consume = 937,attr = [{1,25099},{2,498520},{3,12463},{4,12463},{15,12463},{16,12463}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(827) ->
	#base_star_map{star_map_id = 827,cons_id = 11,class_id = 4,point_id = 2,cons_name = "水瓶座",consume = 942,attr = [{1,25099},{2,501980},{3,12463},{4,12463},{15,12463},{16,12463}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(828) ->
	#base_star_map{star_map_id = 828,cons_id = 11,class_id = 4,point_id = 3,cons_name = "水瓶座",consume = 947,attr = [{1,25099},{2,501980},{3,12636},{4,12463},{15,12463},{16,12463}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(829) ->
	#base_star_map{star_map_id = 829,cons_id = 11,class_id = 4,point_id = 4,cons_name = "水瓶座",consume = 952,attr = [{1,25099},{2,501980},{3,12636},{4,12636},{15,12463},{16,12463}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(830) ->
	#base_star_map{star_map_id = 830,cons_id = 11,class_id = 4,point_id = 5,cons_name = "水瓶座",consume = 957,attr = [{1,25099},{2,501980},{3,12636},{4,12636},{15,12636},{16,12463}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(831) ->
	#base_star_map{star_map_id = 831,cons_id = 11,class_id = 4,point_id = 6,cons_name = "水瓶座",consume = 962,attr = [{1,25099},{2,501980},{3,12636},{4,12636},{15,12636},{16,12636}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(832) ->
	#base_star_map{star_map_id = 832,cons_id = 11,class_id = 4,point_id = 7,cons_name = "水瓶座",consume = 967,attr = [{1,25099},{2,505440},{3,12636},{4,12636},{15,12636},{16,12636}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(833) ->
	#base_star_map{star_map_id = 833,cons_id = 11,class_id = 4,point_id = 8,cons_name = "水瓶座",consume = 972,attr = [{1,25272},{2,505440},{3,12636},{4,12636},{15,12636},{16,12636}],extra_attr = [{15,12636},{16,12636},{68,20800}]};

get_starmap_cfg(834) ->
	#base_star_map{star_map_id = 834,cons_id = 11,class_id = 5,point_id = 1,cons_name = "水瓶座",consume = 946,attr = [{1,25446},{2,505440},{3,12636},{4,12636},{15,12636},{16,12636}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(835) ->
	#base_star_map{star_map_id = 835,cons_id = 11,class_id = 5,point_id = 2,cons_name = "水瓶座",consume = 951,attr = [{1,25446},{2,508920},{3,12636},{4,12636},{15,12636},{16,12636}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(836) ->
	#base_star_map{star_map_id = 836,cons_id = 11,class_id = 5,point_id = 3,cons_name = "水瓶座",consume = 956,attr = [{1,25446},{2,508920},{3,12810},{4,12636},{15,12636},{16,12636}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(837) ->
	#base_star_map{star_map_id = 837,cons_id = 11,class_id = 5,point_id = 4,cons_name = "水瓶座",consume = 961,attr = [{1,25446},{2,508920},{3,12810},{4,12810},{15,12636},{16,12636}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(838) ->
	#base_star_map{star_map_id = 838,cons_id = 11,class_id = 5,point_id = 5,cons_name = "水瓶座",consume = 966,attr = [{1,25446},{2,508920},{3,12810},{4,12810},{15,12810},{16,12636}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(839) ->
	#base_star_map{star_map_id = 839,cons_id = 11,class_id = 5,point_id = 6,cons_name = "水瓶座",consume = 971,attr = [{1,25446},{2,508920},{3,12810},{4,12810},{15,12810},{16,12810}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(840) ->
	#base_star_map{star_map_id = 840,cons_id = 11,class_id = 5,point_id = 7,cons_name = "水瓶座",consume = 976,attr = [{1,25446},{2,512400},{3,12810},{4,12810},{15,12810},{16,12810}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(841) ->
	#base_star_map{star_map_id = 841,cons_id = 11,class_id = 5,point_id = 8,cons_name = "水瓶座",consume = 981,attr = [{1,25620},{2,512400},{3,12810},{4,12810},{15,12810},{16,12810}],extra_attr = [{15,12810},{16,12810},{68,21000}]};

get_starmap_cfg(842) ->
	#base_star_map{star_map_id = 842,cons_id = 11,class_id = 6,point_id = 1,cons_name = "水瓶座",consume = 955,attr = [{1,25795},{2,512400},{3,12810},{4,12810},{15,12810},{16,12810}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(843) ->
	#base_star_map{star_map_id = 843,cons_id = 11,class_id = 6,point_id = 2,cons_name = "水瓶座",consume = 960,attr = [{1,25795},{2,515900},{3,12810},{4,12810},{15,12810},{16,12810}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(844) ->
	#base_star_map{star_map_id = 844,cons_id = 11,class_id = 6,point_id = 3,cons_name = "水瓶座",consume = 965,attr = [{1,25795},{2,515900},{3,12985},{4,12810},{15,12810},{16,12810}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(845) ->
	#base_star_map{star_map_id = 845,cons_id = 11,class_id = 6,point_id = 4,cons_name = "水瓶座",consume = 970,attr = [{1,25795},{2,515900},{3,12985},{4,12985},{15,12810},{16,12810}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(846) ->
	#base_star_map{star_map_id = 846,cons_id = 11,class_id = 6,point_id = 5,cons_name = "水瓶座",consume = 975,attr = [{1,25795},{2,515900},{3,12985},{4,12985},{15,12985},{16,12810}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(847) ->
	#base_star_map{star_map_id = 847,cons_id = 11,class_id = 6,point_id = 6,cons_name = "水瓶座",consume = 980,attr = [{1,25795},{2,515900},{3,12985},{4,12985},{15,12985},{16,12985}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(848) ->
	#base_star_map{star_map_id = 848,cons_id = 11,class_id = 6,point_id = 7,cons_name = "水瓶座",consume = 985,attr = [{1,25795},{2,519400},{3,12985},{4,12985},{15,12985},{16,12985}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(849) ->
	#base_star_map{star_map_id = 849,cons_id = 11,class_id = 6,point_id = 8,cons_name = "水瓶座",consume = 990,attr = [{1,25970},{2,519400},{3,12985},{4,12985},{15,12985},{16,12985}],extra_attr = [{15,12985},{16,12985},{68,21200}]};

get_starmap_cfg(850) ->
	#base_star_map{star_map_id = 850,cons_id = 11,class_id = 7,point_id = 1,cons_name = "水瓶座",consume = 964,attr = [{1,26146},{2,519400},{3,12985},{4,12985},{15,12985},{16,12985}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(851) ->
	#base_star_map{star_map_id = 851,cons_id = 11,class_id = 7,point_id = 2,cons_name = "水瓶座",consume = 969,attr = [{1,26146},{2,522920},{3,12985},{4,12985},{15,12985},{16,12985}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(852) ->
	#base_star_map{star_map_id = 852,cons_id = 11,class_id = 7,point_id = 3,cons_name = "水瓶座",consume = 974,attr = [{1,26146},{2,522920},{3,13161},{4,12985},{15,12985},{16,12985}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(853) ->
	#base_star_map{star_map_id = 853,cons_id = 11,class_id = 7,point_id = 4,cons_name = "水瓶座",consume = 979,attr = [{1,26146},{2,522920},{3,13161},{4,13161},{15,12985},{16,12985}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(854) ->
	#base_star_map{star_map_id = 854,cons_id = 11,class_id = 7,point_id = 5,cons_name = "水瓶座",consume = 984,attr = [{1,26146},{2,522920},{3,13161},{4,13161},{15,13161},{16,12985}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(855) ->
	#base_star_map{star_map_id = 855,cons_id = 11,class_id = 7,point_id = 6,cons_name = "水瓶座",consume = 989,attr = [{1,26146},{2,522920},{3,13161},{4,13161},{15,13161},{16,13161}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(856) ->
	#base_star_map{star_map_id = 856,cons_id = 11,class_id = 7,point_id = 7,cons_name = "水瓶座",consume = 994,attr = [{1,26146},{2,526440},{3,13161},{4,13161},{15,13161},{16,13161}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(857) ->
	#base_star_map{star_map_id = 857,cons_id = 11,class_id = 7,point_id = 8,cons_name = "水瓶座",consume = 999,attr = [{1,26322},{2,526440},{3,13161},{4,13161},{15,13161},{16,13161}],extra_attr = [{15,13161},{16,13161},{68,21400}]};

get_starmap_cfg(858) ->
	#base_star_map{star_map_id = 858,cons_id = 11,class_id = 8,point_id = 1,cons_name = "水瓶座",consume = 973,attr = [{1,26499},{2,526440},{3,13161},{4,13161},{15,13161},{16,13161}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(859) ->
	#base_star_map{star_map_id = 859,cons_id = 11,class_id = 8,point_id = 2,cons_name = "水瓶座",consume = 978,attr = [{1,26499},{2,529980},{3,13161},{4,13161},{15,13161},{16,13161}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(860) ->
	#base_star_map{star_map_id = 860,cons_id = 11,class_id = 8,point_id = 3,cons_name = "水瓶座",consume = 983,attr = [{1,26499},{2,529980},{3,13338},{4,13161},{15,13161},{16,13161}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(861) ->
	#base_star_map{star_map_id = 861,cons_id = 11,class_id = 8,point_id = 4,cons_name = "水瓶座",consume = 988,attr = [{1,26499},{2,529980},{3,13338},{4,13338},{15,13161},{16,13161}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(862) ->
	#base_star_map{star_map_id = 862,cons_id = 11,class_id = 8,point_id = 5,cons_name = "水瓶座",consume = 993,attr = [{1,26499},{2,529980},{3,13338},{4,13338},{15,13338},{16,13161}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(863) ->
	#base_star_map{star_map_id = 863,cons_id = 11,class_id = 8,point_id = 6,cons_name = "水瓶座",consume = 998,attr = [{1,26499},{2,529980},{3,13338},{4,13338},{15,13338},{16,13338}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(864) ->
	#base_star_map{star_map_id = 864,cons_id = 11,class_id = 8,point_id = 7,cons_name = "水瓶座",consume = 1003,attr = [{1,26499},{2,533520},{3,13338},{4,13338},{15,13338},{16,13338}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(865) ->
	#base_star_map{star_map_id = 865,cons_id = 11,class_id = 8,point_id = 8,cons_name = "水瓶座",consume = 1008,attr = [{1,26676},{2,533520},{3,13338},{4,13338},{15,13338},{16,13338}],extra_attr = [{15,13338},{16,13338},{68,21600}]};

get_starmap_cfg(866) ->
	#base_star_map{star_map_id = 866,cons_id = 11,class_id = 9,point_id = 1,cons_name = "水瓶座",consume = 982,attr = [{1,26854},{2,533520},{3,13338},{4,13338},{15,13338},{16,13338}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(867) ->
	#base_star_map{star_map_id = 867,cons_id = 11,class_id = 9,point_id = 2,cons_name = "水瓶座",consume = 987,attr = [{1,26854},{2,537080},{3,13338},{4,13338},{15,13338},{16,13338}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(868) ->
	#base_star_map{star_map_id = 868,cons_id = 11,class_id = 9,point_id = 3,cons_name = "水瓶座",consume = 992,attr = [{1,26854},{2,537080},{3,13516},{4,13338},{15,13338},{16,13338}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(869) ->
	#base_star_map{star_map_id = 869,cons_id = 11,class_id = 9,point_id = 4,cons_name = "水瓶座",consume = 997,attr = [{1,26854},{2,537080},{3,13516},{4,13516},{15,13338},{16,13338}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(870) ->
	#base_star_map{star_map_id = 870,cons_id = 11,class_id = 9,point_id = 5,cons_name = "水瓶座",consume = 1002,attr = [{1,26854},{2,537080},{3,13516},{4,13516},{15,13516},{16,13338}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(871) ->
	#base_star_map{star_map_id = 871,cons_id = 11,class_id = 9,point_id = 6,cons_name = "水瓶座",consume = 1007,attr = [{1,26854},{2,537080},{3,13516},{4,13516},{15,13516},{16,13516}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(872) ->
	#base_star_map{star_map_id = 872,cons_id = 11,class_id = 9,point_id = 7,cons_name = "水瓶座",consume = 1012,attr = [{1,26854},{2,540640},{3,13516},{4,13516},{15,13516},{16,13516}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(873) ->
	#base_star_map{star_map_id = 873,cons_id = 11,class_id = 9,point_id = 8,cons_name = "水瓶座",consume = 1017,attr = [{1,27032},{2,540640},{3,13516},{4,13516},{15,13516},{16,13516}],extra_attr = [{15,13516},{16,13516},{68,21800}]};

get_starmap_cfg(874) ->
	#base_star_map{star_map_id = 874,cons_id = 11,class_id = 10,point_id = 1,cons_name = "水瓶座",consume = 991,attr = [{1,27211},{2,540640},{3,13516},{4,13516},{15,13516},{16,13516}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(875) ->
	#base_star_map{star_map_id = 875,cons_id = 11,class_id = 10,point_id = 2,cons_name = "水瓶座",consume = 996,attr = [{1,27211},{2,544220},{3,13516},{4,13516},{15,13516},{16,13516}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(876) ->
	#base_star_map{star_map_id = 876,cons_id = 11,class_id = 10,point_id = 3,cons_name = "水瓶座",consume = 1001,attr = [{1,27211},{2,544220},{3,13695},{4,13516},{15,13516},{16,13516}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(877) ->
	#base_star_map{star_map_id = 877,cons_id = 11,class_id = 10,point_id = 4,cons_name = "水瓶座",consume = 1006,attr = [{1,27211},{2,544220},{3,13695},{4,13695},{15,13516},{16,13516}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(878) ->
	#base_star_map{star_map_id = 878,cons_id = 11,class_id = 10,point_id = 5,cons_name = "水瓶座",consume = 1011,attr = [{1,27211},{2,544220},{3,13695},{4,13695},{15,13695},{16,13516}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(879) ->
	#base_star_map{star_map_id = 879,cons_id = 11,class_id = 10,point_id = 6,cons_name = "水瓶座",consume = 1016,attr = [{1,27211},{2,544220},{3,13695},{4,13695},{15,13695},{16,13695}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(880) ->
	#base_star_map{star_map_id = 880,cons_id = 11,class_id = 10,point_id = 7,cons_name = "水瓶座",consume = 1021,attr = [{1,27211},{2,547800},{3,13695},{4,13695},{15,13695},{16,13695}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(881) ->
	#base_star_map{star_map_id = 881,cons_id = 11,class_id = 10,point_id = 8,cons_name = "水瓶座",consume = 1026,attr = [{1,27390},{2,547800},{3,13695},{4,13695},{15,13695},{16,13695}],extra_attr = [{15,13695},{16,13695},{68,22000}]};

get_starmap_cfg(882) ->
	#base_star_map{star_map_id = 882,cons_id = 12,class_id = 1,point_id = 1,cons_name = "双鱼座",consume = 1000,attr = [{1,27570},{2,547800},{3,13695},{4,13695},{15,13695},{16,13695}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(883) ->
	#base_star_map{star_map_id = 883,cons_id = 12,class_id = 1,point_id = 2,cons_name = "双鱼座",consume = 1005,attr = [{1,27570},{2,551400},{3,13695},{4,13695},{15,13695},{16,13695}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(884) ->
	#base_star_map{star_map_id = 884,cons_id = 12,class_id = 1,point_id = 3,cons_name = "双鱼座",consume = 1010,attr = [{1,27570},{2,551400},{3,13875},{4,13695},{15,13695},{16,13695}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(885) ->
	#base_star_map{star_map_id = 885,cons_id = 12,class_id = 1,point_id = 4,cons_name = "双鱼座",consume = 1015,attr = [{1,27570},{2,551400},{3,13875},{4,13875},{15,13695},{16,13695}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(886) ->
	#base_star_map{star_map_id = 886,cons_id = 12,class_id = 1,point_id = 5,cons_name = "双鱼座",consume = 1020,attr = [{1,27570},{2,551400},{3,13875},{4,13875},{15,13875},{16,13695}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(887) ->
	#base_star_map{star_map_id = 887,cons_id = 12,class_id = 1,point_id = 6,cons_name = "双鱼座",consume = 1025,attr = [{1,27570},{2,551400},{3,13875},{4,13875},{15,13875},{16,13875}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(888) ->
	#base_star_map{star_map_id = 888,cons_id = 12,class_id = 1,point_id = 7,cons_name = "双鱼座",consume = 1030,attr = [{1,27570},{2,555000},{3,13875},{4,13875},{15,13875},{16,13875}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(889) ->
	#base_star_map{star_map_id = 889,cons_id = 12,class_id = 1,point_id = 8,cons_name = "双鱼座",consume = 1035,attr = [{1,27750},{2,555000},{3,13875},{4,13875},{15,13875},{16,13875}],extra_attr = [{15,13875},{16,13875},{68,22200}]};

get_starmap_cfg(890) ->
	#base_star_map{star_map_id = 890,cons_id = 12,class_id = 2,point_id = 1,cons_name = "双鱼座",consume = 1009,attr = [{1,27931},{2,555000},{3,13875},{4,13875},{15,13875},{16,13875}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(891) ->
	#base_star_map{star_map_id = 891,cons_id = 12,class_id = 2,point_id = 2,cons_name = "双鱼座",consume = 1014,attr = [{1,27931},{2,558620},{3,13875},{4,13875},{15,13875},{16,13875}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(892) ->
	#base_star_map{star_map_id = 892,cons_id = 12,class_id = 2,point_id = 3,cons_name = "双鱼座",consume = 1019,attr = [{1,27931},{2,558620},{3,14056},{4,13875},{15,13875},{16,13875}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(893) ->
	#base_star_map{star_map_id = 893,cons_id = 12,class_id = 2,point_id = 4,cons_name = "双鱼座",consume = 1024,attr = [{1,27931},{2,558620},{3,14056},{4,14056},{15,13875},{16,13875}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(894) ->
	#base_star_map{star_map_id = 894,cons_id = 12,class_id = 2,point_id = 5,cons_name = "双鱼座",consume = 1029,attr = [{1,27931},{2,558620},{3,14056},{4,14056},{15,14056},{16,13875}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(895) ->
	#base_star_map{star_map_id = 895,cons_id = 12,class_id = 2,point_id = 6,cons_name = "双鱼座",consume = 1034,attr = [{1,27931},{2,558620},{3,14056},{4,14056},{15,14056},{16,14056}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(896) ->
	#base_star_map{star_map_id = 896,cons_id = 12,class_id = 2,point_id = 7,cons_name = "双鱼座",consume = 1039,attr = [{1,27931},{2,562240},{3,14056},{4,14056},{15,14056},{16,14056}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(897) ->
	#base_star_map{star_map_id = 897,cons_id = 12,class_id = 2,point_id = 8,cons_name = "双鱼座",consume = 1044,attr = [{1,28112},{2,562240},{3,14056},{4,14056},{15,14056},{16,14056}],extra_attr = [{15,14056},{16,14056},{68,22400}]};

get_starmap_cfg(898) ->
	#base_star_map{star_map_id = 898,cons_id = 12,class_id = 3,point_id = 1,cons_name = "双鱼座",consume = 1018,attr = [{1,28294},{2,562240},{3,14056},{4,14056},{15,14056},{16,14056}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(899) ->
	#base_star_map{star_map_id = 899,cons_id = 12,class_id = 3,point_id = 2,cons_name = "双鱼座",consume = 1023,attr = [{1,28294},{2,565880},{3,14056},{4,14056},{15,14056},{16,14056}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(900) ->
	#base_star_map{star_map_id = 900,cons_id = 12,class_id = 3,point_id = 3,cons_name = "双鱼座",consume = 1028,attr = [{1,28294},{2,565880},{3,14238},{4,14056},{15,14056},{16,14056}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(901) ->
	#base_star_map{star_map_id = 901,cons_id = 12,class_id = 3,point_id = 4,cons_name = "双鱼座",consume = 1033,attr = [{1,28294},{2,565880},{3,14238},{4,14238},{15,14056},{16,14056}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(902) ->
	#base_star_map{star_map_id = 902,cons_id = 12,class_id = 3,point_id = 5,cons_name = "双鱼座",consume = 1038,attr = [{1,28294},{2,565880},{3,14238},{4,14238},{15,14238},{16,14056}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(903) ->
	#base_star_map{star_map_id = 903,cons_id = 12,class_id = 3,point_id = 6,cons_name = "双鱼座",consume = 1043,attr = [{1,28294},{2,565880},{3,14238},{4,14238},{15,14238},{16,14238}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(904) ->
	#base_star_map{star_map_id = 904,cons_id = 12,class_id = 3,point_id = 7,cons_name = "双鱼座",consume = 1048,attr = [{1,28294},{2,569520},{3,14238},{4,14238},{15,14238},{16,14238}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(905) ->
	#base_star_map{star_map_id = 905,cons_id = 12,class_id = 3,point_id = 8,cons_name = "双鱼座",consume = 1053,attr = [{1,28476},{2,569520},{3,14238},{4,14238},{15,14238},{16,14238}],extra_attr = [{15,14238},{16,14238},{68,22600}]};

get_starmap_cfg(906) ->
	#base_star_map{star_map_id = 906,cons_id = 12,class_id = 4,point_id = 1,cons_name = "双鱼座",consume = 1027,attr = [{1,28659},{2,569520},{3,14238},{4,14238},{15,14238},{16,14238}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(907) ->
	#base_star_map{star_map_id = 907,cons_id = 12,class_id = 4,point_id = 2,cons_name = "双鱼座",consume = 1032,attr = [{1,28659},{2,573180},{3,14238},{4,14238},{15,14238},{16,14238}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(908) ->
	#base_star_map{star_map_id = 908,cons_id = 12,class_id = 4,point_id = 3,cons_name = "双鱼座",consume = 1037,attr = [{1,28659},{2,573180},{3,14421},{4,14238},{15,14238},{16,14238}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(909) ->
	#base_star_map{star_map_id = 909,cons_id = 12,class_id = 4,point_id = 4,cons_name = "双鱼座",consume = 1042,attr = [{1,28659},{2,573180},{3,14421},{4,14421},{15,14238},{16,14238}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(910) ->
	#base_star_map{star_map_id = 910,cons_id = 12,class_id = 4,point_id = 5,cons_name = "双鱼座",consume = 1047,attr = [{1,28659},{2,573180},{3,14421},{4,14421},{15,14421},{16,14238}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(911) ->
	#base_star_map{star_map_id = 911,cons_id = 12,class_id = 4,point_id = 6,cons_name = "双鱼座",consume = 1052,attr = [{1,28659},{2,573180},{3,14421},{4,14421},{15,14421},{16,14421}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(912) ->
	#base_star_map{star_map_id = 912,cons_id = 12,class_id = 4,point_id = 7,cons_name = "双鱼座",consume = 1057,attr = [{1,28659},{2,576840},{3,14421},{4,14421},{15,14421},{16,14421}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(913) ->
	#base_star_map{star_map_id = 913,cons_id = 12,class_id = 4,point_id = 8,cons_name = "双鱼座",consume = 1062,attr = [{1,28842},{2,576840},{3,14421},{4,14421},{15,14421},{16,14421}],extra_attr = [{15,14421},{16,14421},{68,22800}]};

get_starmap_cfg(914) ->
	#base_star_map{star_map_id = 914,cons_id = 12,class_id = 5,point_id = 1,cons_name = "双鱼座",consume = 1036,attr = [{1,29026},{2,576840},{3,14421},{4,14421},{15,14421},{16,14421}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(915) ->
	#base_star_map{star_map_id = 915,cons_id = 12,class_id = 5,point_id = 2,cons_name = "双鱼座",consume = 1041,attr = [{1,29026},{2,580520},{3,14421},{4,14421},{15,14421},{16,14421}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(916) ->
	#base_star_map{star_map_id = 916,cons_id = 12,class_id = 5,point_id = 3,cons_name = "双鱼座",consume = 1046,attr = [{1,29026},{2,580520},{3,14605},{4,14421},{15,14421},{16,14421}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(917) ->
	#base_star_map{star_map_id = 917,cons_id = 12,class_id = 5,point_id = 4,cons_name = "双鱼座",consume = 1051,attr = [{1,29026},{2,580520},{3,14605},{4,14605},{15,14421},{16,14421}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(918) ->
	#base_star_map{star_map_id = 918,cons_id = 12,class_id = 5,point_id = 5,cons_name = "双鱼座",consume = 1056,attr = [{1,29026},{2,580520},{3,14605},{4,14605},{15,14605},{16,14421}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(919) ->
	#base_star_map{star_map_id = 919,cons_id = 12,class_id = 5,point_id = 6,cons_name = "双鱼座",consume = 1061,attr = [{1,29026},{2,580520},{3,14605},{4,14605},{15,14605},{16,14605}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(920) ->
	#base_star_map{star_map_id = 920,cons_id = 12,class_id = 5,point_id = 7,cons_name = "双鱼座",consume = 1066,attr = [{1,29026},{2,584200},{3,14605},{4,14605},{15,14605},{16,14605}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(921) ->
	#base_star_map{star_map_id = 921,cons_id = 12,class_id = 5,point_id = 8,cons_name = "双鱼座",consume = 1071,attr = [{1,29210},{2,584200},{3,14605},{4,14605},{15,14605},{16,14605}],extra_attr = [{15,14605},{16,14605},{68,23000}]};

get_starmap_cfg(922) ->
	#base_star_map{star_map_id = 922,cons_id = 12,class_id = 6,point_id = 1,cons_name = "双鱼座",consume = 1045,attr = [{1,29395},{2,584200},{3,14605},{4,14605},{15,14605},{16,14605}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(923) ->
	#base_star_map{star_map_id = 923,cons_id = 12,class_id = 6,point_id = 2,cons_name = "双鱼座",consume = 1050,attr = [{1,29395},{2,587900},{3,14605},{4,14605},{15,14605},{16,14605}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(924) ->
	#base_star_map{star_map_id = 924,cons_id = 12,class_id = 6,point_id = 3,cons_name = "双鱼座",consume = 1055,attr = [{1,29395},{2,587900},{3,14790},{4,14605},{15,14605},{16,14605}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(925) ->
	#base_star_map{star_map_id = 925,cons_id = 12,class_id = 6,point_id = 4,cons_name = "双鱼座",consume = 1060,attr = [{1,29395},{2,587900},{3,14790},{4,14790},{15,14605},{16,14605}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(926) ->
	#base_star_map{star_map_id = 926,cons_id = 12,class_id = 6,point_id = 5,cons_name = "双鱼座",consume = 1065,attr = [{1,29395},{2,587900},{3,14790},{4,14790},{15,14790},{16,14605}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(927) ->
	#base_star_map{star_map_id = 927,cons_id = 12,class_id = 6,point_id = 6,cons_name = "双鱼座",consume = 1070,attr = [{1,29395},{2,587900},{3,14790},{4,14790},{15,14790},{16,14790}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(928) ->
	#base_star_map{star_map_id = 928,cons_id = 12,class_id = 6,point_id = 7,cons_name = "双鱼座",consume = 1075,attr = [{1,29395},{2,591600},{3,14790},{4,14790},{15,14790},{16,14790}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(929) ->
	#base_star_map{star_map_id = 929,cons_id = 12,class_id = 6,point_id = 8,cons_name = "双鱼座",consume = 1080,attr = [{1,29580},{2,591600},{3,14790},{4,14790},{15,14790},{16,14790}],extra_attr = [{15,14790},{16,14790},{68,23200}]};

get_starmap_cfg(930) ->
	#base_star_map{star_map_id = 930,cons_id = 12,class_id = 7,point_id = 1,cons_name = "双鱼座",consume = 1054,attr = [{1,29766},{2,591600},{3,14790},{4,14790},{15,14790},{16,14790}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(931) ->
	#base_star_map{star_map_id = 931,cons_id = 12,class_id = 7,point_id = 2,cons_name = "双鱼座",consume = 1059,attr = [{1,29766},{2,595320},{3,14790},{4,14790},{15,14790},{16,14790}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(932) ->
	#base_star_map{star_map_id = 932,cons_id = 12,class_id = 7,point_id = 3,cons_name = "双鱼座",consume = 1064,attr = [{1,29766},{2,595320},{3,14976},{4,14790},{15,14790},{16,14790}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(933) ->
	#base_star_map{star_map_id = 933,cons_id = 12,class_id = 7,point_id = 4,cons_name = "双鱼座",consume = 1069,attr = [{1,29766},{2,595320},{3,14976},{4,14976},{15,14790},{16,14790}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(934) ->
	#base_star_map{star_map_id = 934,cons_id = 12,class_id = 7,point_id = 5,cons_name = "双鱼座",consume = 1074,attr = [{1,29766},{2,595320},{3,14976},{4,14976},{15,14976},{16,14790}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(935) ->
	#base_star_map{star_map_id = 935,cons_id = 12,class_id = 7,point_id = 6,cons_name = "双鱼座",consume = 1079,attr = [{1,29766},{2,595320},{3,14976},{4,14976},{15,14976},{16,14976}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(936) ->
	#base_star_map{star_map_id = 936,cons_id = 12,class_id = 7,point_id = 7,cons_name = "双鱼座",consume = 1084,attr = [{1,29766},{2,599040},{3,14976},{4,14976},{15,14976},{16,14976}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(937) ->
	#base_star_map{star_map_id = 937,cons_id = 12,class_id = 7,point_id = 8,cons_name = "双鱼座",consume = 1089,attr = [{1,29952},{2,599040},{3,14976},{4,14976},{15,14976},{16,14976}],extra_attr = [{15,14976},{16,14976},{68,23400}]};

get_starmap_cfg(938) ->
	#base_star_map{star_map_id = 938,cons_id = 12,class_id = 8,point_id = 1,cons_name = "双鱼座",consume = 1063,attr = [{1,30139},{2,599040},{3,14976},{4,14976},{15,14976},{16,14976}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(939) ->
	#base_star_map{star_map_id = 939,cons_id = 12,class_id = 8,point_id = 2,cons_name = "双鱼座",consume = 1068,attr = [{1,30139},{2,602780},{3,14976},{4,14976},{15,14976},{16,14976}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(940) ->
	#base_star_map{star_map_id = 940,cons_id = 12,class_id = 8,point_id = 3,cons_name = "双鱼座",consume = 1073,attr = [{1,30139},{2,602780},{3,15163},{4,14976},{15,14976},{16,14976}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(941) ->
	#base_star_map{star_map_id = 941,cons_id = 12,class_id = 8,point_id = 4,cons_name = "双鱼座",consume = 1078,attr = [{1,30139},{2,602780},{3,15163},{4,15163},{15,14976},{16,14976}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(942) ->
	#base_star_map{star_map_id = 942,cons_id = 12,class_id = 8,point_id = 5,cons_name = "双鱼座",consume = 1083,attr = [{1,30139},{2,602780},{3,15163},{4,15163},{15,15163},{16,14976}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(943) ->
	#base_star_map{star_map_id = 943,cons_id = 12,class_id = 8,point_id = 6,cons_name = "双鱼座",consume = 1088,attr = [{1,30139},{2,602780},{3,15163},{4,15163},{15,15163},{16,15163}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(944) ->
	#base_star_map{star_map_id = 944,cons_id = 12,class_id = 8,point_id = 7,cons_name = "双鱼座",consume = 1093,attr = [{1,30139},{2,606520},{3,15163},{4,15163},{15,15163},{16,15163}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(945) ->
	#base_star_map{star_map_id = 945,cons_id = 12,class_id = 8,point_id = 8,cons_name = "双鱼座",consume = 1098,attr = [{1,30326},{2,606520},{3,15163},{4,15163},{15,15163},{16,15163}],extra_attr = [{15,15163},{16,15163},{68,23600}]};

get_starmap_cfg(946) ->
	#base_star_map{star_map_id = 946,cons_id = 12,class_id = 9,point_id = 1,cons_name = "双鱼座",consume = 1072,attr = [{1,30514},{2,606520},{3,15163},{4,15163},{15,15163},{16,15163}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(947) ->
	#base_star_map{star_map_id = 947,cons_id = 12,class_id = 9,point_id = 2,cons_name = "双鱼座",consume = 1077,attr = [{1,30514},{2,610280},{3,15163},{4,15163},{15,15163},{16,15163}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(948) ->
	#base_star_map{star_map_id = 948,cons_id = 12,class_id = 9,point_id = 3,cons_name = "双鱼座",consume = 1082,attr = [{1,30514},{2,610280},{3,15351},{4,15163},{15,15163},{16,15163}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(949) ->
	#base_star_map{star_map_id = 949,cons_id = 12,class_id = 9,point_id = 4,cons_name = "双鱼座",consume = 1087,attr = [{1,30514},{2,610280},{3,15351},{4,15351},{15,15163},{16,15163}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(950) ->
	#base_star_map{star_map_id = 950,cons_id = 12,class_id = 9,point_id = 5,cons_name = "双鱼座",consume = 1092,attr = [{1,30514},{2,610280},{3,15351},{4,15351},{15,15351},{16,15163}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(951) ->
	#base_star_map{star_map_id = 951,cons_id = 12,class_id = 9,point_id = 6,cons_name = "双鱼座",consume = 1097,attr = [{1,30514},{2,610280},{3,15351},{4,15351},{15,15351},{16,15351}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(952) ->
	#base_star_map{star_map_id = 952,cons_id = 12,class_id = 9,point_id = 7,cons_name = "双鱼座",consume = 1102,attr = [{1,30514},{2,614040},{3,15351},{4,15351},{15,15351},{16,15351}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(953) ->
	#base_star_map{star_map_id = 953,cons_id = 12,class_id = 9,point_id = 8,cons_name = "双鱼座",consume = 1107,attr = [{1,30702},{2,614040},{3,15351},{4,15351},{15,15351},{16,15351}],extra_attr = [{15,15351},{16,15351},{68,23800}]};

get_starmap_cfg(954) ->
	#base_star_map{star_map_id = 954,cons_id = 12,class_id = 10,point_id = 1,cons_name = "双鱼座",consume = 1081,attr = [{1,30891},{2,614040},{3,15351},{4,15351},{15,15351},{16,15351}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(955) ->
	#base_star_map{star_map_id = 955,cons_id = 12,class_id = 10,point_id = 2,cons_name = "双鱼座",consume = 1086,attr = [{1,30891},{2,617820},{3,15351},{4,15351},{15,15351},{16,15351}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(956) ->
	#base_star_map{star_map_id = 956,cons_id = 12,class_id = 10,point_id = 3,cons_name = "双鱼座",consume = 1091,attr = [{1,30891},{2,617820},{3,15540},{4,15351},{15,15351},{16,15351}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(957) ->
	#base_star_map{star_map_id = 957,cons_id = 12,class_id = 10,point_id = 4,cons_name = "双鱼座",consume = 1096,attr = [{1,30891},{2,617820},{3,15540},{4,15540},{15,15351},{16,15351}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(958) ->
	#base_star_map{star_map_id = 958,cons_id = 12,class_id = 10,point_id = 5,cons_name = "双鱼座",consume = 1101,attr = [{1,30891},{2,617820},{3,15540},{4,15540},{15,15540},{16,15351}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(959) ->
	#base_star_map{star_map_id = 959,cons_id = 12,class_id = 10,point_id = 6,cons_name = "双鱼座",consume = 1106,attr = [{1,30891},{2,617820},{3,15540},{4,15540},{15,15540},{16,15540}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(960) ->
	#base_star_map{star_map_id = 960,cons_id = 12,class_id = 10,point_id = 7,cons_name = "双鱼座",consume = 1111,attr = [{1,30891},{2,621600},{3,15540},{4,15540},{15,15540},{16,15540}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(961) ->
	#base_star_map{star_map_id = 961,cons_id = 12,class_id = 10,point_id = 8,cons_name = "双鱼座",consume = 1116,attr = [{1,31080},{2,621600},{3,15540},{4,15540},{15,15540},{16,15540}],extra_attr = [{15,15540},{16,15540},{68,24000}]};

get_starmap_cfg(_Starmapid) ->
	[].

get_all_cons() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961].

