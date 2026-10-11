-module(pt_426).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42601, Bin0) ->
    {Name, Bin1} = pt:read_string(Bin0), 
    <<Type:32, _Bin2/binary>> = Bin1, 
    {ok, [Name, Type]};
read(42602, _) ->
    {ok, []};
read(42603, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<Id:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, Id]};
read(42604, Bin0) ->
    {Name, Bin1} = pt:read_string(Bin0), 
    <<Type:32, _Bin2/binary>> = Bin1, 
    {ok, [Name, Type]};
read(_Cmd, _R) -> {error, no_match}.

write (42601,[
    Result,
    Name
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Result:32,
        Bin_Name/binary
    >>,
    {ok, pt:pack(42601, Data)};

write (42602,[
    Result
]) ->
    Data = <<
        Result:32
    >>,
    {ok, pt:pack(42602, Data)};

write (42603,[
    NameList
]) ->
    BinList_NameList = [
        item_to_bin_0(NameList_Item) || NameList_Item <- NameList
    ], 

    NameList_Len = length(NameList), 
    Bin_NameList = list_to_binary(BinList_NameList),

    Data = <<
        NameList_Len:16, Bin_NameList/binary
    >>,
    {ok, pt:pack(42603, Data)};

write (42604,[
    Result,
    Name
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Result:32,
        Bin_Name/binary
    >>,
    {ok, pt:pack(42604, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Name,
    Time
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Bin_Name/binary,
        Time:32
    >>,
    Data.
