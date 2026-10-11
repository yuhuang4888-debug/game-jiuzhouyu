%%%---------------------------------------
%%% module      : data_back_decoration
%%% description : 背饰配置
%%%
%%%---------------------------------------
-module(data_back_decoration).
-compile(export_all).
-include("back_decoration.hrl").



get_decoration_cfg(1,0) ->
	#base_back_decoration{back_decoration_id = 1,stage = 0,skill = [{450001,1}],attr = [{1,600},{3,600},{7,1200},{10,200}],cost = [{0,74010001,30}],figure_id = 105001,name = "双生锦鲤"};

get_decoration_cfg(1,1) ->
	#base_back_decoration{back_decoration_id = 1,stage = 1,skill = [{450001,2}],attr = [{1,960},{3,960},{7,1920},{10,280}],cost = [{0,74010001,30}],figure_id = 105001,name = "双生锦鲤"};

get_decoration_cfg(1,2) ->
	#base_back_decoration{back_decoration_id = 1,stage = 2,skill = [{450001,3}],attr = [{1,1320},{3,1320},{7,2640},{10,360}],cost = [{0,74010001,60}],figure_id = 105001,name = "双生锦鲤"};

get_decoration_cfg(1,3) ->
	#base_back_decoration{back_decoration_id = 1,stage = 3,skill = [{450001,4}],attr = [{1,1680},{3,1680},{7,3360},{10,440}],cost = [{0,74010001,90}],figure_id = 105002,name = "双生锦鲤"};

get_decoration_cfg(1,4) ->
	#base_back_decoration{back_decoration_id = 1,stage = 4,skill = [{450001,5}],attr = [{1,2040},{3,2040},{7,4080},{10,520}],cost = [{0,74010001,120}],figure_id = 105002,name = "双生锦鲤"};

get_decoration_cfg(1,5) ->
	#base_back_decoration{back_decoration_id = 1,stage = 5,skill = [{450001,6}],attr = [{1,2400},{3,2400},{7,4800},{10,600}],cost = [{0,74010001,150}],figure_id = 105003,name = "双生锦鲤"};

get_decoration_cfg(1,6) ->
	#base_back_decoration{back_decoration_id = 1,stage = 6,skill = [{450001,7}],attr = [{1,2760},{3,2760},{7,5520},{10,680}],cost = [{0,74010001,180}],figure_id = 105003,name = "双生锦鲤"};

get_decoration_cfg(1,7) ->
	#base_back_decoration{back_decoration_id = 1,stage = 7,skill = [{450001,8}],attr = [{1,3120},{3,3120},{7,6240},{10,760}],cost = [{0,74010001,210}],figure_id = 105004,name = "双生锦鲤"};

get_decoration_cfg(1,8) ->
	#base_back_decoration{back_decoration_id = 1,stage = 8,skill = [{450001,9}],attr = [{1,3480},{3,3480},{7,6960},{10,840}],cost = [{0,74010001,240}],figure_id = 105004,name = "双生锦鲤"};

get_decoration_cfg(1,9) ->
	#base_back_decoration{back_decoration_id = 1,stage = 9,skill = [{450001,10}],attr = [{1,3840},{3,3840},{7,7680},{10,920}],cost = [{0,74010001,270}],figure_id = 105004,name = "双生锦鲤"};

get_decoration_cfg(1,10) ->
	#base_back_decoration{back_decoration_id = 1,stage = 10,skill = [{450001,11}],attr = [{1,4200},{3,4200},{7,8400},{10,1000}],cost = [{0,74010001,300}],figure_id = 105004,name = "双生锦鲤"};

get_decoration_cfg(2,0) ->
	#base_back_decoration{back_decoration_id = 2,stage = 0,skill = [{450002,1}],attr = [{1,600},{3,600},{7,1200},{17,300}],cost = [{0,74010002,30}],figure_id = 105005,name = "月萌猫"};

get_decoration_cfg(2,1) ->
	#base_back_decoration{back_decoration_id = 2,stage = 1,skill = [{450002,2}],attr = [{1,960},{3,960},{7,1920},{17,420}],cost = [{0,74010002,30}],figure_id = 105005,name = "月萌猫"};

get_decoration_cfg(2,2) ->
	#base_back_decoration{back_decoration_id = 2,stage = 2,skill = [{450002,3}],attr = [{1,1320},{3,1320},{7,2640},{17,540}],cost = [{0,74010002,60}],figure_id = 105005,name = "月萌猫"};

get_decoration_cfg(2,3) ->
	#base_back_decoration{back_decoration_id = 2,stage = 3,skill = [{450002,4}],attr = [{1,1680},{3,1680},{7,3360},{17,660}],cost = [{0,74010002,90}],figure_id = 105006,name = "月萌猫"};

get_decoration_cfg(2,4) ->
	#base_back_decoration{back_decoration_id = 2,stage = 4,skill = [{450002,5}],attr = [{1,2040},{3,2040},{7,4080},{17,780}],cost = [{0,74010002,120}],figure_id = 105006,name = "月萌猫"};

get_decoration_cfg(2,5) ->
	#base_back_decoration{back_decoration_id = 2,stage = 5,skill = [{450002,6}],attr = [{1,2400},{3,2400},{7,4800},{17,900}],cost = [{0,74010002,150}],figure_id = 105007,name = "月萌猫"};

get_decoration_cfg(2,6) ->
	#base_back_decoration{back_decoration_id = 2,stage = 6,skill = [{450002,7}],attr = [{1,2760},{3,2760},{7,5520},{17,1020}],cost = [{0,74010002,180}],figure_id = 105007,name = "月萌猫"};

get_decoration_cfg(2,7) ->
	#base_back_decoration{back_decoration_id = 2,stage = 7,skill = [{450002,8}],attr = [{1,3120},{3,3120},{7,6240},{17,1140}],cost = [{0,74010002,210}],figure_id = 105008,name = "月萌猫"};

get_decoration_cfg(2,8) ->
	#base_back_decoration{back_decoration_id = 2,stage = 8,skill = [{450002,9}],attr = [{1,3480},{3,3480},{7,6960},{17,1260}],cost = [{0,74010002,240}],figure_id = 105008,name = "月萌猫"};

get_decoration_cfg(2,9) ->
	#base_back_decoration{back_decoration_id = 2,stage = 9,skill = [{450002,10}],attr = [{1,3840},{3,3840},{7,7680},{17,1380}],cost = [{0,74010002,270}],figure_id = 105008,name = "月萌猫"};

get_decoration_cfg(2,10) ->
	#base_back_decoration{back_decoration_id = 2,stage = 10,skill = [{450002,11}],attr = [{1,4200},{3,4200},{7,8400},{17,1500}],cost = [{0,74010002,300}],figure_id = 105008,name = "月萌猫"};

get_decoration_cfg(3,0) ->
	#base_back_decoration{back_decoration_id = 3,stage = 0,skill = [{450003,1}],attr = [{1,600},{3,600},{7,1200},{37,800}],cost = [{0,74010003,30}],figure_id = 105009,name = "高能械甲"};

get_decoration_cfg(3,1) ->
	#base_back_decoration{back_decoration_id = 3,stage = 1,skill = [{450003,2}],attr = [{1,960},{3,960},{7,1920},{37,1120}],cost = [{0,74010003,30}],figure_id = 105009,name = "高能械甲"};

get_decoration_cfg(3,2) ->
	#base_back_decoration{back_decoration_id = 3,stage = 2,skill = [{450003,3}],attr = [{1,1320},{3,1320},{7,2640},{37,1440}],cost = [{0,74010003,60}],figure_id = 105009,name = "高能械甲"};

get_decoration_cfg(3,3) ->
	#base_back_decoration{back_decoration_id = 3,stage = 3,skill = [{450003,4}],attr = [{1,1680},{3,1680},{7,3360},{37,1760}],cost = [{0,74010003,90}],figure_id = 105010,name = "高能械甲"};

get_decoration_cfg(3,4) ->
	#base_back_decoration{back_decoration_id = 3,stage = 4,skill = [{450003,5}],attr = [{1,2040},{3,2040},{7,4080},{37,2080}],cost = [{0,74010003,120}],figure_id = 105010,name = "高能械甲"};

get_decoration_cfg(3,5) ->
	#base_back_decoration{back_decoration_id = 3,stage = 5,skill = [{450003,6}],attr = [{1,2400},{3,2400},{7,4800},{37,2400}],cost = [{0,74010003,150}],figure_id = 105011,name = "高能械甲"};

get_decoration_cfg(3,6) ->
	#base_back_decoration{back_decoration_id = 3,stage = 6,skill = [{450003,7}],attr = [{1,2760},{3,2760},{7,5520},{37,2720}],cost = [{0,74010003,180}],figure_id = 105011,name = "高能械甲"};

get_decoration_cfg(3,7) ->
	#base_back_decoration{back_decoration_id = 3,stage = 7,skill = [{450003,8}],attr = [{1,3120},{3,3120},{7,6240},{37,3040}],cost = [{0,74010003,210}],figure_id = 105012,name = "高能械甲"};

get_decoration_cfg(3,8) ->
	#base_back_decoration{back_decoration_id = 3,stage = 8,skill = [{450003,9}],attr = [{1,3480},{3,3480},{7,6960},{37,3360}],cost = [{0,74010003,240}],figure_id = 105012,name = "高能械甲"};

get_decoration_cfg(3,9) ->
	#base_back_decoration{back_decoration_id = 3,stage = 9,skill = [{450003,10}],attr = [{1,3840},{3,3840},{7,7680},{37,3680}],cost = [{0,74010003,270}],figure_id = 105012,name = "高能械甲"};

get_decoration_cfg(3,10) ->
	#base_back_decoration{back_decoration_id = 3,stage = 10,skill = [{450003,11}],attr = [{1,4200},{3,4200},{7,8400},{37,4000}],cost = [{0,74010003,300}],figure_id = 105012,name = "高能械甲"};

get_decoration_cfg(_Backdecorationid,_Stage) ->
	[].


get_value(show_limit) ->
3;

get_value(_Key) ->
	[].

