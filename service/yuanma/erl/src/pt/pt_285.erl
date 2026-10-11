-module(pt_285).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28501, _) ->
    {ok, []};
read(28502, _) ->
    {ok, []};
read(28503, _) ->
    {ok, []};
read(28504, _) ->
    {ok, []};
read(28505, _) ->
    {ok, []};
read(28506, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (28500,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(28500, Data)};

write (28501,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(28501, Data)};



write (28503,[
    Exp
]) ->
    Data = <<
        Exp:32
    >>,
    {ok, pt:pack(28503, Data)};

write (28504,[
    LowBox,
    HighBox
]) ->
    Data = <<
        LowBox:32,
        HighBox:32
    >>,
    {ok, pt:pack(28504, Data)};

write (28505,[
    Time
]) ->
    Data = <<
        Time:32
    >>,
    {ok, pt:pack(28505, Data)};

write (28506,[
    Time
]) ->
    Data = <<
        Time:32
    >>,
    {ok, pt:pack(28506, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


