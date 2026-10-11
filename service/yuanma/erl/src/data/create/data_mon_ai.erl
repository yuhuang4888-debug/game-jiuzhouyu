%%%---------------------------------------
%%% @Module  : data_mon_ai
%%% @Description:  怪物AI
%%%---------------------------------------
-module(data_mon_ai).
-compile(export_all).


get(10000, 1, _) -> 
    data_ai:get(1);
get(10012, 1, _) -> 
    data_ai:get(2);
get(_,_,_) -> [].


