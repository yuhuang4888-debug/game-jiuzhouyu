%%%---------------------------------------
%%% @Module  : data_ai
%%% @Description:  AI库
%%%---------------------------------------
-module(data_ai).
-compile(export_all).


get(1) ->
    [{create_bonfire,[1000, 1],0}];
get(2) ->
    [{create_mon,[50,20000,0,0,0,0,0,[]],0}];
get(3) ->
    [{create_bonfire,[0, 3],0}];
get(4) ->
    [{create_bonfire,[1000, 4],0}];
get(5) ->
    [{msg,[3600001],0}];
get(6) ->
    [{msg,[3600002],0}];
get(7) ->
    [{msg,[3600003],0}];
get(_) -> [].


