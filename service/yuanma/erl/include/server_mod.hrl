%%%-----------------------------------
%%% @Module      : server_mod
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 26. 五月 2020 10:55
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-author("carlos").






-record(mod_cfg, {
	mod = 0         %% '1：本服模式、2:2服模式、4：4服模式、8：8服模式',
	, name = ""      %% '服务器模式名称',
	, min_world_lv   %%'最小世界等级',
	, max_world_lv   %%'最大世界等级',
	, open_day       %% '开服天数',
}).



-record(server_mod_state, {
	zone_map = #{}       %%
}).


-record(zone_group, {
	zone_id = 0,
	server_list = [] %% [#server_msg{}]
	,group_list =  [] %%  248 分组
	, max_mod = 0     %% 最大的分服模式
	, num = 0         %% 分组内的服务器数量
}).



-record(server_msg, {
	server_id = 0       %% 每一个服的id(主服)
	, group_id = 0      %% 分组id
	, mod_id = 1        %% 模式id
	, zone_id = 0       %% 区id  同场景进程
	, time = 0          %% 开服时间
	, merge_ids = []    %% 每一个服的所有合服id
	, server_num = 0    %% ServerNum
	, server_name = ""  %% 服名字
	, world_lv = 0      %% 世界等级
	, rank = 0          %% 排行第几  在小跨服里, 以开服天数来排名，
}).


-record(ser_group, {
	id = 0  %% id  = 服的模式 * 100 +  ceil(排名 / 模式)向上取证  , 排名最大8 ，现在的小跨服，最多服是8个
	, zone_id = 0
	, server_list = []
}).


-record(transport_msg, {
	zone_id,
	server_group_map = #{}        %% server => 分组id
	,server_group_list = []       %% [transport_group_msg]
}).


-record(transport_group_msg, {
	id = 0                %% 分组id
	,mod = 0              %% 模式
	,server_ids = []      %% 服id
	,server_num = []      %% 服nums
}).

