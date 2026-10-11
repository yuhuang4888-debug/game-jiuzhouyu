%%%---------------------------------------
%%% module      : data_real_info
%%% description : 身份验证配置
%%%
%%%---------------------------------------
-module(data_real_info).
-compile(export_all).




get_reward_by_type(1) ->
[{0,35,100},{0,16020001,1},{0,17020001,1},{0,32010095,1},{0,56010002,1}];


get_reward_by_type(2) ->
[{0,37020001,1},{0,16020001,1},{0,38040002,20},{0,32010095,1},{0,36100001,1000}];


get_reward_by_type(3) ->
0;


get_reward_by_type(4) ->
0;

get_reward_by_type(_Type) ->
	[].

