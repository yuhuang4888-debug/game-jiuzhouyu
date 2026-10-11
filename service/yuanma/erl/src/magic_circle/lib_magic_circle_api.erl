%%%-------------------------------------------------------------------
%%% @author lwc
%%% @copyright (C) 2021, <COMPANY>
%%% @doc 外部调用
%%%
%%% @end
%%% Created : 25. 8月 2021 16:18
%%%-------------------------------------------------------------------
-module(lib_magic_circle_api).

%% API
-export([free_experience/2]).

-include("server.hrl").
-include("magic_circle.hrl").

%% 激活守护免费体验(秘籍)
free_experience(PS, Type) ->
    if
        Type == 1 orelse Type == 2 orelse Type == 3 orelse Type == 4->
            #player_status{magic_circle = MagicCircleList} = PS,
            NewMagicCircle = #magic_circle{lv = Type, free_flag = 1, show = 0},
            NewMagicCircleList = lists:keystore(Type, #magic_circle.lv, MagicCircleList, NewMagicCircle),
            PS#player_status{magic_circle = NewMagicCircleList};
        true -> PS
    end.