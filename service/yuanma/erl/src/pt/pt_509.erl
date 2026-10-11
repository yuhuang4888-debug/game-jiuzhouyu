-module(pt_509).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(50901, _) ->
    {ok, []};
read(50902, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Count:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Count]};
read(_Cmd, _R) -> {error, no_match}.

write (50901,[
    BlessValue
]) ->
    Data = <<
        BlessValue:32
    >>,
    {ok, pt:pack(50901, Data)};

write (50902,[
    Code,
    Type,
    Count,
    BlessValue,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        Type:8,
        Count:8,
        BlessValue:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(50902, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


