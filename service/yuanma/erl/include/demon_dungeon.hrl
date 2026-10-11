%%%-----------------------------------
%%% @Module      : demon_dungeon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 08. 七月 2019 9:56
%%% @Description : 
%%%-----------------------------------


-author("carlos").


-define(demon_scene, 2031).

-define(demon_dun_id, 33001).


-record(demon_dun, {
	current_dun = 0,    %%当前副本id
	demon_list = []
}).