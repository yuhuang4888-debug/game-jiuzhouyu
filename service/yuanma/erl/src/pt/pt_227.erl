-module(pt_227).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22700, _) ->
    {ok, []};
read(22701, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(22702, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(22703, _) ->
    {ok, []};
read(22704, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<RewardId:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, RewardId]};
read(22705, _) ->
    {ok, []};
read(22706, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (22700,[
    Type,
    Subtype,
    StartTime,
    EndTime,
    UponEndTime
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        StartTime:32,
        EndTime:32,
        UponEndTime:32
    >>,
    {ok, pt:pack(22700, Data)};

write (22701,[
    Type,
    Subtype,
    IsOpen,
    Score,
    Rank,
    Id,
    GotType
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        IsOpen:8,
        Score:32,
        Rank:16,
        Id:16,
        GotType:8
    >>,
    {ok, pt:pack(22701, Data)};

write (22702,[
    Type,
    Subtype,
    Score,
    Rank,
    RewardId,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Type:16,
        Subtype:16,
        Score:32,
        Rank:16,
        RewardId:16,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22702, Data)};

write (22703,[
    Type,
    Subtype,
    Score,
    Rank,
    PushType,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_1(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Type:16,
        Subtype:16,
        Score:32,
        Rank:16,
        PushType:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22703, Data)};

write (22704,[
    Type,
    Subtype,
    RewardId,
    ErrorCode
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        RewardId:16,
        ErrorCode:32
    >>,
    {ok, pt:pack(22704, Data)};

write (22705,[
    RankType,
    RankSubtype,
    Type,
    Rank,
    Value
]) ->
    Data = <<
        RankType:16,
        RankSubtype:16,
        Type:32,
        Rank:32,
        Value:32
    >>,
    {ok, pt:pack(22705, Data)};

write (22706,[
    RankType,
    RankSubtype,
    ServerId,
    RoleId,
    RoleName,
    RoleScore
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RankType:16,
        RankSubtype:16,
        ServerId:32,
        RoleId:64,
        Bin_RoleName/binary,
        RoleScore:32
    >>,
    {ok, pt:pack(22706, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Rank,
    ServerId,
    RoleId,
    RoleName,
    RoleScore
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        ServerId:32,
        RoleId:64,
        Bin_RoleName/binary,
        RoleScore:32
    >>,
    Data.
item_to_bin_1 ({
    Rank,
    ServerId,
    RoleId,
    RoleName,
    RoleScore
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        ServerId:32,
        RoleId:64,
        Bin_RoleName/binary,
        RoleScore:32
    >>,
    Data.
