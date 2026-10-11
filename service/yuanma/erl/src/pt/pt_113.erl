-module(pt_113).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(11301, _) ->
    {ok, []};
read(11302, _) ->
    {ok, []};
read(11303, Bin0) ->
    <<Opr:8, _Bin1/binary>> = Bin0, 
    {ok, [Opr]};
read(11304, _) ->
    {ok, []};
read(11305, Bin0) ->
    <<TempId:32, Bin1/binary>> = Bin0, 
    {PackageCode, _Bin2} = pt:read_string(Bin1), 
    {ok, [TempId, PackageCode]};
read(11306, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<TempId:32, _Args1/binary>> = RestBin0, 
        {TempId,_Args1}
        end,
    {TempList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [TempList]};
read(11307, _) ->
    {ok, []};
read(11308, Bin0) ->
    <<IsMicro:8, _Bin1/binary>> = Bin0, 
    {ok, [IsMicro]};
read(_Cmd, _R) -> {error, no_match}.

write (11301,[
    Count
]) ->
    Data = <<
        Count:8
    >>,
    {ok, pt:pack(11301, Data)};

write (11302,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(11302, Data)};

write (11303,[
    ErrorCode,
    Opr,
    WxCollect
]) ->
    Data = <<
        ErrorCode:32,
        Opr:8,
        WxCollect:8
    >>,
    {ok, pt:pack(11303, Data)};





write (11306,[
    TempList
]) ->
    BinList_TempList = [
        item_to_bin_0(TempList_Item) || TempList_Item <- TempList
    ], 

    TempList_Len = length(TempList), 
    Bin_TempList = list_to_binary(BinList_TempList),

    Data = <<
        TempList_Len:16, Bin_TempList/binary
    >>,
    {ok, pt:pack(11306, Data)};

write (11307,[
    Res
]) ->
    Data = <<
        Res:8
    >>,
    {ok, pt:pack(11307, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    TempId,
    State
}) ->
    Data = <<
        TempId:32,
        State:8
    >>,
    Data.
