-module(pt_241).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(24101, _) ->
    {ok, []};
read(24102, _) ->
    {ok, []};
read(24103, Bin0) ->
    <<PortalId:64, _Bin1/binary>> = Bin0, 
    {ok, [PortalId]};
read(24104, _) ->
    {ok, []};
read(24105, _) ->
    {ok, []};
read(24106, _) ->
    {ok, []};
read(24107, _) ->
    {ok, []};
read(24108, _) ->
    {ok, []};
read(24109, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (24101,[
    State,
    EndTime,
    Mod,
    GroupId,
    NextStartTime,
    ServerList,
    AvgLv
]) ->
    BinList_ServerList = [
        item_to_bin_0(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        State:8,
        EndTime:32,
        Mod:32,
        GroupId:32,
        NextStartTime:32,
        ServerList_Len:16, Bin_ServerList/binary,
        AvgLv:64
    >>,
    {ok, pt:pack(24101, Data)};

write (24102,[
    PortalList
]) ->
    BinList_PortalList = [
        item_to_bin_1(PortalList_Item) || PortalList_Item <- PortalList
    ], 

    PortalList_Len = length(PortalList), 
    Bin_PortalList = list_to_binary(BinList_PortalList),

    Data = <<
        PortalList_Len:16, Bin_PortalList/binary
    >>,
    {ok, pt:pack(24102, Data)};

write (24103,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(24103, Data)};

write (24104,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(24104, Data)};

write (24105,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(24105, Data)};

write (24106,[
    PortalId
]) ->
    Data = <<
        PortalId:64
    >>,
    {ok, pt:pack(24106, Data)};

write (24107,[
    AssistNum,
    EnterNum
]) ->
    Data = <<
        AssistNum:32,
        EnterNum:32
    >>,
    {ok, pt:pack(24107, Data)};

write (24108,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(24108, Data)};

write (24109,[
    DunId
]) ->
    Data = <<
        DunId:32
    >>,
    {ok, pt:pack(24109, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    ServerName,
    WorldLv
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:64,
        ServerNum:64,
        Bin_ServerName/binary,
        WorldLv:64
    >>,
    Data.
item_to_bin_1 ({
    PortalId,
    X,
    Y
}) ->
    Data = <<
        PortalId:64,
        X:32,
        Y:32
    >>,
    Data.
