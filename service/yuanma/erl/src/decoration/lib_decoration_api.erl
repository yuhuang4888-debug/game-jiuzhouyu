%%%-------------------------------------------------------------------
%%% @author menglu
%%% @copyright (C) 2018, <SuYou Game>
%%% @doc
%%% 幻饰对外API
%%% @end
%%% Created : 2021 10.18
%%%-------------------------------------------------------------------
-module(lib_decoration_api).
-include("server.hrl").
-include("decoration.hrl").
-export([
        get_total_decoration_level/1           % 获取幻饰强化总等级
]).

get_total_decoration_level(PS) ->
    #player_status{decoration = Decoration} = PS,
    #decoration{level_list = LevelList} = Decoration,
    F = fun({_, Level}, Sum) ->
        Sum+Level
    end,
    lists:foldl(F, 0, LevelList).