-module(pt_514).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(51400, _) ->
    {ok, []};
read(51401, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(51402, Bin0) ->
    <<Id:16, Bin1/binary>> = Bin0, 
    <<Type:16, Bin2/binary>> = Bin1, 
    <<State:8, _Bin3/binary>> = Bin2, 
    {ok, [Id, Type, State]};
read(_Cmd, _R) -> {error, no_match}.

write (51400,[
    EndTime,
    Rewards
]) ->
    BinList_Rewards = [
        item_to_bin_0(Rewards_Item) || Rewards_Item <- Rewards
    ], 

    Rewards_Len = length(Rewards), 
    Bin_Rewards = list_to_binary(BinList_Rewards),

    Data = <<
        EndTime:32,
        Rewards_Len:16, Bin_Rewards/binary
    >>,
    {ok, pt:pack(51400, Data)};

write (51401,[
    Id,
    State,
    Errcode
]) ->
    Data = <<
        Id:32,
        State:8,
        Errcode:32
    >>,
    {ok, pt:pack(51401, Data)};

write (51402,[
    Id,
    Type,
    State,
    Errcode
]) ->
    Data = <<
        Id:16,
        Type:16,
        State:8,
        Errcode:32
    >>,
    {ok, pt:pack(51402, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    State
}) ->
    Data = <<
        Id:32,
        State:8
    >>,
    Data.
