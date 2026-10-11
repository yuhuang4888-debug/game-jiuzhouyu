-module(pt_202).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(20201, _) ->
    {ok, []};
read(20202, Bin0) ->
    <<SceneType:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneType]};
read(20203, _) ->
    {ok, []};
read(20205, Bin0) ->
    <<SceneType:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneType]};
read(_Cmd, _R) -> {error, no_match}.

write (20201,[
    ProtectList
]) ->
    BinList_ProtectList = [
        item_to_bin_0(ProtectList_Item) || ProtectList_Item <- ProtectList
    ], 

    ProtectList_Len = length(ProtectList), 
    Bin_ProtectList = list_to_binary(BinList_ProtectList),

    Data = <<
        ProtectList_Len:16, Bin_ProtectList/binary
    >>,
    {ok, pt:pack(20201, Data)};

write (20202,[
    ErrorCode,
    SceneType,
    ProtectTime,
    UseCount
]) ->
    Data = <<
        ErrorCode:32,
        SceneType:32,
        ProtectTime:32,
        UseCount:32
    >>,
    {ok, pt:pack(20202, Data)};

write (20203,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(20203, Data)};

write (20204,[
    SceneType,
    ProtectTime,
    UseCount
]) ->
    Data = <<
        SceneType:32,
        ProtectTime:32,
        UseCount:32
    >>,
    {ok, pt:pack(20204, Data)};

write (20205,[
    ErrorCode,
    SceneType
]) ->
    Data = <<
        ErrorCode:32,
        SceneType:32
    >>,
    {ok, pt:pack(20205, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SceneType,
    ProtectTime,
    UseCount
}) ->
    Data = <<
        SceneType:32,
        ProtectTime:32,
        UseCount:32
    >>,
    Data.
