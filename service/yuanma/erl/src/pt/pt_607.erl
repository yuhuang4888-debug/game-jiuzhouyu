-module(pt_607).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60701, _) ->
    {ok, []};
read(60702, Bin0) ->
    <<StoneId:32, _Bin1/binary>> = Bin0, 
    {ok, [StoneId]};
read(60703, _) ->
    {ok, []};
read(60704, Bin0) ->
    <<StoneId:32, _Bin1/binary>> = Bin0, 
    {ok, [StoneId]};
read(60705, Bin0) ->
    <<IsWant:8, _Bin1/binary>> = Bin0, 
    {ok, [IsWant]};
read(60706, _) ->
    {ok, []};
read(60707, Bin0) ->
    <<InspireId:32, _Bin1/binary>> = Bin0, 
    {ok, [InspireId]};
read(60708, _) ->
    {ok, []};
read(60709, _) ->
    {ok, []};
read(60711, Bin0) ->
    <<StoneId:32, _Bin1/binary>> = Bin0, 
    {ok, [StoneId]};
read(_Cmd, _R) -> {error, no_match}.

write (60700,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(60700, Data)};

write (60701,[
    LinkState,
    StoneList
]) ->
    BinList_StoneList = [
        item_to_bin_0(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    Data = <<
        LinkState:8,
        StoneList_Len:16, Bin_StoneList/binary
    >>,
    {ok, pt:pack(60701, Data)};

write (60702,[
    StoneId
]) ->
    Data = <<
        StoneId:32
    >>,
    {ok, pt:pack(60702, Data)};

write (60703,[
    Count,
    MaxCount
]) ->
    Data = <<
        Count:16,
        MaxCount:16
    >>,
    {ok, pt:pack(60703, Data)};

write (60704,[
    StoneId,
    AttrId
]) ->
    Data = <<
        StoneId:32,
        AttrId:32
    >>,
    {ok, pt:pack(60704, Data)};

write (60705,[
    IsWant
]) ->
    Data = <<
        IsWant:8
    >>,
    {ok, pt:pack(60705, Data)};

write (60706,[
    TurnId,
    InspireList,
    EndTime
]) ->
    BinList_InspireList = [
        item_to_bin_1(InspireList_Item) || InspireList_Item <- InspireList
    ], 

    InspireList_Len = length(InspireList), 
    Bin_InspireList = list_to_binary(BinList_InspireList),

    Data = <<
        TurnId:32,
        InspireList_Len:16, Bin_InspireList/binary,
        EndTime:32
    >>,
    {ok, pt:pack(60706, Data)};

write (60707,[
    InspireId,
    InspireNum,
    InspireTime
]) ->
    Data = <<
        InspireId:32,
        InspireNum:16,
        InspireTime:32
    >>,
    {ok, pt:pack(60707, Data)};

write (60708,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(60708, Data)};

write (60709,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(60709, Data)};

write (60710,[
    IsSuccess,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_2(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        IsSuccess:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(60710, Data)};

write (60711,[
    StoneId,
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_3(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        StoneId:32,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(60711, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    StoneId,
    Cd,
    Status,
    RoleId,
    ServerName,
    Figure,
    Combat
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        StoneId:32,
        Cd:32,
        Status:8,
        RoleId:64,
        Bin_ServerName/binary,
        Bin_Figure/binary,
        Combat:32
    >>,
    Data.
item_to_bin_1 ({
    InspireId,
    InspireNum,
    InspireTime
}) ->
    Data = <<
        InspireId:32,
        InspireNum:16,
        InspireTime:32
    >>,
    Data.
item_to_bin_2 ({
    Type,
    TypeId,
    Num
}) ->
    Data = <<
        Type:8,
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_3 ({
    Time,
    RoleId,
    ServerName,
    RoleName,
    Res
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Time:32,
        RoleId:64,
        Bin_ServerName/binary,
        Bin_RoleName/binary,
        Res:8
    >>,
    Data.
