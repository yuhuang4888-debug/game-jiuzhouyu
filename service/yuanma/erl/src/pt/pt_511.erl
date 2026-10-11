-module(pt_511).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(51101, _) ->
    {ok, []};
read(51102, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (51101,[
    MaskId,
    EndTime
]) ->
    Data = <<
        MaskId:8,
        EndTime:32
    >>,
    {ok, pt:pack(51101, Data)};

write (51102,[
    MaskId,
    EndTime
]) ->
    Data = <<
        MaskId:8,
        EndTime:32
    >>,
    {ok, pt:pack(51102, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


