%%%-------------------------------------------------------------------
%%% @author lwc
%%% @copyright (C) 2021, <COMPANY>
%%% @doc 魔法阵工具类
%%%
%%% @end
%%% Created : 26. 8月 2021 11:00
%%%-------------------------------------------------------------------
-module(lib_magic_circle_util).

-include("magic_circle.hrl").

%% API
-export([filter_no_expired/1]).

%% 获得未过期守护
filter_no_expired(MagicCircleList) ->
    F1 = fun(#magic_circle{status = Status, lv = Lv, end_time = EndTime, free_flag = F, show = Show}, AccList) ->
        Flag = lib_magic_circle:get_free_flag(F),
        if
            Lv == 0 -> AccList;
            EndTime == 0 -> AccList;
            true -> [{Status, Lv, EndTime, Show, Flag} | AccList]
        end
         end,
    lists:foldl(F1, [], MagicCircleList).


