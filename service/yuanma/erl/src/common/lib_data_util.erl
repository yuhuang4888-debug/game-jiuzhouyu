%% ---------------------------------------------------------------------------
%% @doc lib_data_util
%% @author cxd
%% @since  2020-08-11
%% @deprecated  常用数据结构操作函数
%% ---------------------------------------------------------------------------
-module(lib_data_util).

-compile([export_all]).

%% ============= map装list ============
get_list_in_map(MapKey, Map, MapDefault, ListKey, KeyPos, ListDefault) ->
    List = maps:get(MapKey, Map, MapDefault),
    ulists:keyfind(ListKey, KeyPos, List, ListDefault).

save_list_in_map(MapKey, Map, MapDefault, ListKey, KeyPos, ListElement) ->
    List = maps:get(MapKey, Map, MapDefault),
    NewList = lists:keystore(ListKey, KeyPos, List, ListElement),
    maps:put(MapKey, NewList, Map).

delete_list_in_map(MapKey, Map, MapDefault, ListKey, KeyPos) ->
    List = maps:get(MapKey, Map, MapDefault),
    NewList = lists:keydelete(ListKey, KeyPos, List),
    maps:put(MapKey, NewList, Map).

