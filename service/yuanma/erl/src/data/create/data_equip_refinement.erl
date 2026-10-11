%%%---------------------------------------
%%% module      : data_equip_refinement
%%% description : 装备神炼配置
%%%
%%%---------------------------------------
-module(data_equip_refinement).
-compile(export_all).
-include("equip_refinement.hrl").



get(1,1) ->
	#base_equip_refinement{refine_lv = 1,refine_pos = 1,promote = 1000,cost_list = [{0,38040092,1}]};

get(1,2) ->
	#base_equip_refinement{refine_lv = 1,refine_pos = 2,promote = 1000,cost_list = [{0,38040095,1}]};

get(2,1) ->
	#base_equip_refinement{refine_lv = 2,refine_pos = 1,promote = 2000,cost_list = [{0,38040092,1}]};

get(2,2) ->
	#base_equip_refinement{refine_lv = 2,refine_pos = 2,promote = 2000,cost_list = [{0,38040095,1}]};

get(3,1) ->
	#base_equip_refinement{refine_lv = 3,refine_pos = 1,promote = 3000,cost_list = [{0,38040092,1}]};

get(3,2) ->
	#base_equip_refinement{refine_lv = 3,refine_pos = 2,promote = 3000,cost_list = [{0,38040095,1}]};

get(4,1) ->
	#base_equip_refinement{refine_lv = 4,refine_pos = 1,promote = 4000,cost_list = [{0,38040092,2}]};

get(4,2) ->
	#base_equip_refinement{refine_lv = 4,refine_pos = 2,promote = 4000,cost_list = [{0,38040095,2}]};

get(5,1) ->
	#base_equip_refinement{refine_lv = 5,refine_pos = 1,promote = 5000,cost_list = [{0,38040092,2}]};

get(5,2) ->
	#base_equip_refinement{refine_lv = 5,refine_pos = 2,promote = 5000,cost_list = [{0,38040095,2}]};

get(6,1) ->
	#base_equip_refinement{refine_lv = 6,refine_pos = 1,promote = 6000,cost_list = [{0,38040092,2}]};

get(6,2) ->
	#base_equip_refinement{refine_lv = 6,refine_pos = 2,promote = 6000,cost_list = [{0,38040095,2}]};

get(7,1) ->
	#base_equip_refinement{refine_lv = 7,refine_pos = 1,promote = 7000,cost_list = [{0,38040092,3}]};

get(7,2) ->
	#base_equip_refinement{refine_lv = 7,refine_pos = 2,promote = 7000,cost_list = [{0,38040095,3}]};

get(8,1) ->
	#base_equip_refinement{refine_lv = 8,refine_pos = 1,promote = 8000,cost_list = [{0,38040092,3}]};

get(8,2) ->
	#base_equip_refinement{refine_lv = 8,refine_pos = 2,promote = 8000,cost_list = [{0,38040095,3}]};

get(9,1) ->
	#base_equip_refinement{refine_lv = 9,refine_pos = 1,promote = 9000,cost_list = [{0,38040092,3}]};

get(9,2) ->
	#base_equip_refinement{refine_lv = 9,refine_pos = 2,promote = 9000,cost_list = [{0,38040095,3}]};

get(10,1) ->
	#base_equip_refinement{refine_lv = 10,refine_pos = 1,promote = 10000,cost_list = [{0,38040092,4}]};

get(10,2) ->
	#base_equip_refinement{refine_lv = 10,refine_pos = 2,promote = 10000,cost_list = [{0,38040095,4}]};

get(_Refinelv,_Refinepos) ->
	[].

