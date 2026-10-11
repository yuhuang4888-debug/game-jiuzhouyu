-module(pt_222).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22201, Bin0) ->
    <<PrevTitleId:8, _Bin1/binary>> = Bin0, 
    {ok, [PrevTitleId]};
read(_Cmd, _R) -> {error, no_match}.

write (22200,[
    PlayerId,
    TitleId
]) ->
    Data = <<
        PlayerId:64,
        TitleId:8
    >>,
    {ok, pt:pack(22200, Data)};

write (22201,[
    PromoteResult,
    TitleId
]) ->
    Data = <<
        PromoteResult:32,
        TitleId:8
    >>,
    {ok, pt:pack(22201, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


