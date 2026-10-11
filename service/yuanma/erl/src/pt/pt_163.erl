-module(pt_163).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16301, _) ->
    {ok, []};
read(16302, _) ->
    {ok, []};
read(16303, Bin0) ->
    <<HeadWearId:32, Bin1/binary>> = Bin0, 
    <<Opr:8, _Bin2/binary>> = Bin1, 
    {ok, [HeadWearId, Opr]};
read(16304, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (16300,[
    RoleId,
    HeadWearId
]) ->
    Data = <<
        RoleId:64,
        HeadWearId:32
    >>,
    {ok, pt:pack(16300, Data)};

write (16301,[
    CurrentUse,
    Lv,
    Exp,
    HeadList
]) ->
    BinList_HeadList = [
        item_to_bin_0(HeadList_Item) || HeadList_Item <- HeadList
    ], 

    HeadList_Len = length(HeadList), 
    Bin_HeadList = list_to_binary(BinList_HeadList),

    Data = <<
        CurrentUse:32,
        Lv:32,
        Exp:32,
        HeadList_Len:16, Bin_HeadList/binary
    >>,
    {ok, pt:pack(16301, Data)};

write (16302,[
    CurrentUse,
    Lv,
    Exp
]) ->
    Data = <<
        CurrentUse:32,
        Lv:32,
        Exp:32
    >>,
    {ok, pt:pack(16302, Data)};

write (16303,[
    Code,
    CurrentUse,
    Opr
]) ->
    Data = <<
        Code:32,
        CurrentUse:32,
        Opr:8
    >>,
    {ok, pt:pack(16303, Data)};

write (16304,[
    Code,
    Lv,
    Exp
]) ->
    Data = <<
        Code:32,
        Lv:32,
        Exp:32
    >>,
    {ok, pt:pack(16304, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    HeadWearId,
    EndTime
}) ->
    Data = <<
        HeadWearId:32,
        EndTime:32
    >>,
    Data.
