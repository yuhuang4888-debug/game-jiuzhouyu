%%%---------------------------------------
%%% @Module  : data_dungeon_grow
%%% @Description : 成长试炼配置
%%%
%%%---------------------------------------
-module(data_dungeon_grow).
-compile(export_all).
-include("dungeon.hrl").



get_dungeon_grow(2002) ->
    #dungeon_grow{dun_id = 2002,sort_id = 1,mon_id = 2002003,reward = [{5,0,40000},{100,410165,1},{100,200200,1},{100,240601,1}]};

get_dungeon_grow(2003) ->
    #dungeon_grow{dun_id = 2003,sort_id = 2,mon_id = 2003003,reward = [{5,0,40000},{100,410166,1},{100,200203,1},{100,240601,1}]};

get_dungeon_grow(_Dunid) ->
    [].

get_dungeon_grow_dun_id_list() ->
[2002,2003].

