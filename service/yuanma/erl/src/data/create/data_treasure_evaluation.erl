%%%---------------------------------------
%%% module      : data_treasure_evaluation
%%% description : 幸运鉴宝配置
%%%
%%%---------------------------------------
-module(data_treasure_evaluation).
-compile(export_all).
-include("treasure_evaluation.hrl").



get_te_main_reward_con(1) ->
	#te_main_reward_con{main_reward_id = 1,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(2) ->
	#te_main_reward_con{main_reward_id = 2,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(3) ->
	#te_main_reward_con{main_reward_id = 3,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(4) ->
	#te_main_reward_con{main_reward_id = 4,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(5) ->
	#te_main_reward_con{main_reward_id = 5,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(6) ->
	#te_main_reward_con{main_reward_id = 6,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(7) ->
	#te_main_reward_con{main_reward_id = 7,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(8) ->
	#te_main_reward_con{main_reward_id = 8,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(9) ->
	#te_main_reward_con{main_reward_id = 9,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(10) ->
	#te_main_reward_con{main_reward_id = 10,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(11) ->
	#te_main_reward_con{main_reward_id = 11,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(12) ->
	#te_main_reward_con{main_reward_id = 12,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(13) ->
	#te_main_reward_con{main_reward_id = 13,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(14) ->
	#te_main_reward_con{main_reward_id = 14,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(15) ->
	#te_main_reward_con{main_reward_id = 15,big_reward_id = 1,reward_id_list = [2,3,4,5,6,7,8,9,10,11]};

get_te_main_reward_con(_Mainrewardid) ->
	[].

get_te_weight_con(1,1) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 1,goods_list = [{0,22030005,1}],weight = 5};

get_te_weight_con(1,2) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(1,3) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(1,4) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(1,5) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(1,6) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 6,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(1,7) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 7,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(1,8) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 8,goods_list = [{0,24010001,1}],weight = 200};

get_te_weight_con(1,9) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 9,goods_list = [{0,24010002,1}],weight = 65};

get_te_weight_con(1,10) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 10,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(1,11) ->
	#te_reward_weight_con{main_reward_id = 1,reward_id = 11,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(2,1) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 1,goods_list = [{0,18040002,1}],weight = 5};

get_te_weight_con(2,2) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 2,goods_list = [{0,18010001,1}],weight = 50};

get_te_weight_con(2,3) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 3,goods_list = [{0,18010002,1}],weight = 50};

get_te_weight_con(2,4) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 4,goods_list = [{0,16010001,1}],weight = 50};

get_te_weight_con(2,5) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 5,goods_list = [{0,16010002,1}],weight = 50};

get_te_weight_con(2,6) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 6,goods_list = [{0,14010001,1}],weight = 200};

get_te_weight_con(2,7) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 7,goods_list = [{0,14010002,1}],weight = 65};

get_te_weight_con(2,8) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 8,goods_list = [{0,38040002,10}],weight = 135};

get_te_weight_con(2,9) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 9,goods_list = [{0,38040003,20}],weight = 130};

get_te_weight_con(2,10) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 10,goods_list = [{0,40030001,1}],weight = 200};

get_te_weight_con(2,11) ->
	#te_reward_weight_con{main_reward_id = 2,reward_id = 11,goods_list = [{0,40030002,1}],weight = 65};

get_te_weight_con(3,1) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 1,goods_list = [{0,20030004,1}],weight = 5};

get_te_weight_con(3,2) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(3,3) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(3,4) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(3,5) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(3,6) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 6,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(3,7) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 7,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(3,8) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 8,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(3,9) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 9,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(3,10) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 10,goods_list = [{0,14020001,1}],weight = 200};

get_te_weight_con(3,11) ->
	#te_reward_weight_con{main_reward_id = 3,reward_id = 11,goods_list = [{0,14020002,1}],weight = 65};

get_te_weight_con(4,1) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 1,goods_list = [{0,16030002,1}],weight = 5};

get_te_weight_con(4,2) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 2,goods_list = [{0,18010001,1}],weight = 50};

get_te_weight_con(4,3) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 3,goods_list = [{0,18010002,1}],weight = 50};

get_te_weight_con(4,4) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 4,goods_list = [{0,16010001,1}],weight = 50};

get_te_weight_con(4,5) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 5,goods_list = [{0,16010002,1}],weight = 50};

get_te_weight_con(4,6) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 6,goods_list = [{0,24010001,1}],weight = 200};

get_te_weight_con(4,7) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 7,goods_list = [{0,24010002,1}],weight = 65};

get_te_weight_con(4,8) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 8,goods_list = [{0,40030001,1}],weight = 200};

get_te_weight_con(4,9) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 9,goods_list = [{0,40030002,1}],weight = 65};

get_te_weight_con(4,10) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 10,goods_list = [{0,38040002,10}],weight = 135};

get_te_weight_con(4,11) ->
	#te_reward_weight_con{main_reward_id = 4,reward_id = 11,goods_list = [{0,38040003,20}],weight = 130};

get_te_weight_con(5,1) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 1,goods_list = [{0,24030003,1}],weight = 5};

get_te_weight_con(5,2) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(5,3) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(5,4) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(5,5) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(5,6) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 6,goods_list = [{0,24010001,1}],weight = 200};

get_te_weight_con(5,7) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 7,goods_list = [{0,24010002,1}],weight = 65};

get_te_weight_con(5,8) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 8,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(5,9) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 9,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(5,10) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 10,goods_list = [{0,38040002,10}],weight = 135};

get_te_weight_con(5,11) ->
	#te_reward_weight_con{main_reward_id = 5,reward_id = 11,goods_list = [{0,38040003,20}],weight = 130};

get_te_weight_con(6,1) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 1,goods_list = [{0,40030008,1}],weight = 5};

get_te_weight_con(6,2) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 2,goods_list = [{0,18010001,1}],weight = 50};

get_te_weight_con(6,3) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 3,goods_list = [{0,18010002,1}],weight = 50};

get_te_weight_con(6,4) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 4,goods_list = [{0,16010001,1}],weight = 50};

get_te_weight_con(6,5) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 5,goods_list = [{0,16010002,1}],weight = 50};

get_te_weight_con(6,6) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 6,goods_list = [{0,14010001,1}],weight = 200};

get_te_weight_con(6,7) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 7,goods_list = [{0,14010002,1}],weight = 65};

get_te_weight_con(6,8) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 8,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(6,9) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 9,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(6,10) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 10,goods_list = [{0,40030001,1}],weight = 200};

get_te_weight_con(6,11) ->
	#te_reward_weight_con{main_reward_id = 6,reward_id = 11,goods_list = [{0,40030002,1}],weight = 65};

get_te_weight_con(7,1) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 1,goods_list = [{0,18070002,1}],weight = 5};

get_te_weight_con(7,2) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(7,3) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(7,4) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(7,5) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(7,6) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 6,goods_list = [{0,14020001,1}],weight = 200};

get_te_weight_con(7,7) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 7,goods_list = [{0,14020002,1}],weight = 65};

get_te_weight_con(7,8) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 8,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(7,9) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 9,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(7,10) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 10,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(7,11) ->
	#te_reward_weight_con{main_reward_id = 7,reward_id = 11,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(8,1) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 1,goods_list = [{0, 40030008, 1}],weight = 5};

get_te_weight_con(8,2) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 2,goods_list = [{0, 20020001, 1}],weight = 80};

get_te_weight_con(8,3) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 3,goods_list = [{0, 20020002, 1}],weight = 80};

get_te_weight_con(8,4) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 4,goods_list = [{0, 24020001, 1}],weight = 80};

get_te_weight_con(8,5) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 5,goods_list = [{0, 24020002, 1}],weight = 80};

get_te_weight_con(8,6) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 6,goods_list = [{0, 20010001, 1}],weight = 175};

get_te_weight_con(8,7) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 7,goods_list = [{0, 20010002, 1}],weight = 50};

get_te_weight_con(8,8) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 8,goods_list = [{0, 24010001, 1}],weight = 175};

get_te_weight_con(8,9) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 9,goods_list = [{0, 24010002, 1}],weight = 50};

get_te_weight_con(8,10) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 10,goods_list = [{0, 40030001, 1}],weight = 175};

get_te_weight_con(8,11) ->
	#te_reward_weight_con{main_reward_id = 8,reward_id = 11,goods_list = [{0, 40030002, 1}],weight = 50};

get_te_weight_con(9,1) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 1,goods_list = [{0,18040004,1}],weight = 5};

get_te_weight_con(9,2) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(9,3) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(9,4) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(9,5) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(9,6) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 6,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(9,7) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 7,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(9,8) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 8,goods_list = [{0,24010001,1}],weight = 200};

get_te_weight_con(9,9) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 9,goods_list = [{0,24010002,1}],weight = 65};

get_te_weight_con(9,10) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 10,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(9,11) ->
	#te_reward_weight_con{main_reward_id = 9,reward_id = 11,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(10,1) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 1,goods_list = [{0,40030007,1}],weight = 5};

get_te_weight_con(10,2) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 2,goods_list = [{0,18010001,1}],weight = 50};

get_te_weight_con(10,3) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 3,goods_list = [{0,18010002,1}],weight = 50};

get_te_weight_con(10,4) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 4,goods_list = [{0,16010001,1}],weight = 50};

get_te_weight_con(10,5) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 5,goods_list = [{0,16010002,1}],weight = 50};

get_te_weight_con(10,6) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 6,goods_list = [{0,14010001,1}],weight = 200};

get_te_weight_con(10,7) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 7,goods_list = [{0,14010002,1}],weight = 65};

get_te_weight_con(10,8) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 8,goods_list = [{0,38040002,10}],weight = 135};

get_te_weight_con(10,9) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 9,goods_list = [{0,38040003,20}],weight = 130};

get_te_weight_con(10,10) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 10,goods_list = [{0,40030001,1}],weight = 200};

get_te_weight_con(10,11) ->
	#te_reward_weight_con{main_reward_id = 10,reward_id = 11,goods_list = [{0,40030002,1}],weight = 65};

get_te_weight_con(11,1) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 1,goods_list = [{0,18070003,1}],weight = 5};

get_te_weight_con(11,2) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(11,3) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(11,4) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(11,5) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(11,6) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 6,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(11,7) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 7,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(11,8) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 8,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(11,9) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 9,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(11,10) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 10,goods_list = [{0,14020001,1}],weight = 200};

get_te_weight_con(11,11) ->
	#te_reward_weight_con{main_reward_id = 11,reward_id = 11,goods_list = [{0,14020002,1}],weight = 65};

get_te_weight_con(12,1) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 1,goods_list = [{0,16030003,1}],weight = 5};

get_te_weight_con(12,2) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 2,goods_list = [{0,18010001,1}],weight = 50};

get_te_weight_con(12,3) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 3,goods_list = [{0,18010002,1}],weight = 50};

get_te_weight_con(12,4) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 4,goods_list = [{0,16010001,1}],weight = 50};

get_te_weight_con(12,5) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 5,goods_list = [{0,16010002,1}],weight = 50};

get_te_weight_con(12,6) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 6,goods_list = [{0,24010001,1}],weight = 200};

get_te_weight_con(12,7) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 7,goods_list = [{0,24010002,1}],weight = 65};

get_te_weight_con(12,8) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 8,goods_list = [{0,40030001,1}],weight = 200};

get_te_weight_con(12,9) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 9,goods_list = [{0,40030002,1}],weight = 65};

get_te_weight_con(12,10) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 10,goods_list = [{0,38040002,10}],weight = 135};

get_te_weight_con(12,11) ->
	#te_reward_weight_con{main_reward_id = 12,reward_id = 11,goods_list = [{0,38040003,20}],weight = 130};

get_te_weight_con(13,1) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 1,goods_list = [{0,22030006,1}],weight = 5};

get_te_weight_con(13,2) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(13,3) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(13,4) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(13,5) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(13,6) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 6,goods_list = [{0,24010001,1}],weight = 200};

get_te_weight_con(13,7) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 7,goods_list = [{0,24010002,1}],weight = 65};

get_te_weight_con(13,8) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 8,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(13,9) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 9,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(13,10) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 10,goods_list = [{0,38040002,10}],weight = 135};

get_te_weight_con(13,11) ->
	#te_reward_weight_con{main_reward_id = 13,reward_id = 11,goods_list = [{0,38040003,20}],weight = 130};

get_te_weight_con(14,1) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 1,goods_list = [{0,20030005,1}],weight = 5};

get_te_weight_con(14,2) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 2,goods_list = [{0,18010001,1}],weight = 50};

get_te_weight_con(14,3) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 3,goods_list = [{0,18010002,1}],weight = 50};

get_te_weight_con(14,4) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 4,goods_list = [{0,16010001,1}],weight = 50};

get_te_weight_con(14,5) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 5,goods_list = [{0,16010002,1}],weight = 50};

get_te_weight_con(14,6) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 6,goods_list = [{0,14010001,1}],weight = 200};

get_te_weight_con(14,7) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 7,goods_list = [{0,14010002,1}],weight = 65};

get_te_weight_con(14,8) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 8,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(14,9) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 9,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(14,10) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 10,goods_list = [{0,40030001,1}],weight = 200};

get_te_weight_con(14,11) ->
	#te_reward_weight_con{main_reward_id = 14,reward_id = 11,goods_list = [{0,40030002,1}],weight = 65};

get_te_weight_con(15,1) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 1,goods_list = [{0,24030004,1}],weight = 5};

get_te_weight_con(15,2) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 2,goods_list = [{0,20020001,1}],weight = 50};

get_te_weight_con(15,3) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 3,goods_list = [{0,20020002,1}],weight = 50};

get_te_weight_con(15,4) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 4,goods_list = [{0,24020001,1}],weight = 50};

get_te_weight_con(15,5) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 5,goods_list = [{0,24020002,1}],weight = 50};

get_te_weight_con(15,6) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 6,goods_list = [{0,14020001,1}],weight = 200};

get_te_weight_con(15,7) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 7,goods_list = [{0,14020002,1}],weight = 65};

get_te_weight_con(15,8) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 8,goods_list = [{0,18060002,1}],weight = 200};

get_te_weight_con(15,9) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 9,goods_list = [{0,18060003,1}],weight = 65};

get_te_weight_con(15,10) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 10,goods_list = [{0,20010001,1}],weight = 200};

get_te_weight_con(15,11) ->
	#te_reward_weight_con{main_reward_id = 15,reward_id = 11,goods_list = [{0,20010002,1}],weight = 65};

get_te_weight_con(_Mainrewardid,_Rewardid) ->
	[].


get_te_weight_list(1) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(2) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{135,8},{130,9},{200,10},{65,11}];


get_te_weight_list(3) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(4) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{135,10},{130,11}];


get_te_weight_list(5) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{135,10},{130,11}];


get_te_weight_list(6) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(7) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(8) ->
[{5,1},{80,2},{80,3},{80,4},{80,5},{175,6},{50,7},{175,8},{50,9},{175,10},{50,11}];


get_te_weight_list(9) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(10) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{135,8},{130,9},{200,10},{65,11}];


get_te_weight_list(11) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(12) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{135,10},{130,11}];


get_te_weight_list(13) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{135,10},{130,11}];


get_te_weight_list(14) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];


get_te_weight_list(15) ->
[{5,1},{50,2},{50,3},{50,4},{50,5},{200,6},{65,7},{200,8},{65,9},{200,10},{65,11}];

get_te_weight_list(_Mainrewardid) ->
	[].

