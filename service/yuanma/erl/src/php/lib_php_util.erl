%% ---------------------------------------------------------------------------
%% @doc lib_php_util.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2018-11-14
%% @deprecated 邀请
%% ---------------------------------------------------------------------------
-module(lib_php_util).

-compile([export_all]).


extract_mochijson([], Rest) -> [Rest];
extract_mochijson([ElmKey | TElmKey],{struct, RestJSON} = A) when is_tuple(A) ->
    [ Value || {Key, Rest} <- RestJSON, Key =:= ElmKey, Value <- extract_mochijson(TElmKey, Rest)];
extract_mochijson(List, A) ->
    [ Value || B <- A, Value <- extract_mochijson(List, B)].
