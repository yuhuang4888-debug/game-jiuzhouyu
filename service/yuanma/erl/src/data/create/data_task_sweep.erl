%%%---------------------------------------
%%% module      : data_task_sweep
%%% description : 扫荡任务配置
%%%
%%%---------------------------------------
-module(data_task_sweep).
-compile(export_all).




get_sweep_level(6) ->
[{320,0}];


get_sweep_level(7) ->
[{320,0}];

get_sweep_level(_Tasktype) ->
	[].

