-module(pt_600).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60001, _) ->
    {ok, []};
read(60002, _) ->
    {ok, []};
read(60003, _) ->
    {ok, []};
read(60004, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (60000,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60000, Data)};

write (60001,[
    Status,
    Etime,
    IsPass
]) ->
    Data = <<
        Status:8,
        Etime:32,
        IsPass:8
    >>,
    {ok, pt:pack(60001, Data)};

write (60002,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60002, Data)};

write (60003,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60003, Data)};

write (60004,[
    Etime,
    Floor,
    Score,
    NeedScore,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_0(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Etime:32,
        Floor:8,
        Score:32,
        NeedScore:32,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(60004, Data)};

write (60005,[
    Score
]) ->
    Data = <<
        Score:32
    >>,
    {ok, pt:pack(60005, Data)};

write (60006,[
    Etime
]) ->
    Data = <<
        Etime:32
    >>,
    {ok, pt:pack(60006, Data)};

write (60007,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(60007, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ObjectType,
    TypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        TypeId:32,
        Num:32
    >>,
    Data.
