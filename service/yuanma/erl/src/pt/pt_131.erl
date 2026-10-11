-module(pt_131).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13100, Bin0) ->
    <<SitDown:8, _Bin1/binary>> = Bin0, 
    {ok, [SitDown]};
read(13102, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(_Cmd, _R) -> {error, no_match}.

write (13100,[
    PlayerId,
    SitDown
]) ->
    Data = <<
        PlayerId:64,
        SitDown:8
    >>,
    {ok, pt:pack(13100, Data)};

write (13102,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(13102, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


