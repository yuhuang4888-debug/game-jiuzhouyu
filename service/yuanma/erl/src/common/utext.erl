%% ---------------------------------------------------------------------------
%% @doc utext
%% @author ming_up@foxmail.com
%% @since  2016-09-27
%% @deprecated  文字
%% ---------------------------------------------------------------------------
-module(utext).

-export([get/1, get/2, get/3]).

-export ([
    get_mm_dd_time_text/1
]).

-include("language.hrl").

get(Id) ->
    get(Id, []).

get(Id, Args) -> 
    uio:format(data_language:get(Id), Args).

get(ModId, Id, Args) ->
    case data_language:get(ModId, Id) of 
        #language{content = Content} ->
            uio:format(Content, Args);
        _ ->
            ""
    end.

get_mm_dd_time_text(Time) ->
    {{_, MM, DD}, _} = utime:unixtime_to_localtime(Time),
    uio:format(data_language:get(?LAN_TIME_MM_DD), [MM, DD]).
        
