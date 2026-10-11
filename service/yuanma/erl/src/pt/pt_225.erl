-module(pt_225).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22501, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, SubType]};
read(22502, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(22503, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Goal:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, SubType, Goal]};
read(22504, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<RewardId:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, SubType, RewardId]};
read(22505, Bin0) ->
    <<RushId:32, _Bin1/binary>> = Bin0, 
    {ok, [RushId]};
read(_Cmd, _R) -> {error, no_match}.

write (22500,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(22500, Data)};

write (22501,[
    RankType,
    SelRank,
    SelVal,
    Sum,
    MaxLen,
    RankLimit,
    Status,
    EndTime,
    IsCombat,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankType:32,
        SelRank:32,
        SelVal:64,
        Sum:32,
        MaxLen:16,
        RankLimit:32,
        Status:8,
        EndTime:64,
        IsCombat:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22501, Data)};

write (22502,[
    GoalList
]) ->
    BinList_GoalList = [
        item_to_bin_1(GoalList_Item) || GoalList_Item <- GoalList
    ], 

    GoalList_Len = length(GoalList), 
    Bin_GoalList = list_to_binary(BinList_GoalList),

    Data = <<
        GoalList_Len:16, Bin_GoalList/binary
    >>,
    {ok, pt:pack(22502, Data)};

write (22503,[
    ErrorCode,
    Type,
    Goal,
    SubType
]) ->
    Data = <<
        ErrorCode:32,
        Type:32,
        Goal:8,
        SubType:16
    >>,
    {ok, pt:pack(22503, Data)};

write (22504,[
    ErrorCode,
    RewardId,
    SubType,
    Type
]) ->
    Data = <<
        ErrorCode:32,
        RewardId:8,
        SubType:16,
        Type:32
    >>,
    {ok, pt:pack(22504, Data)};

write (22505,[
    RushId,
    Res
]) ->
    BinList_Res = [
        item_to_bin_3(Res_Item) || Res_Item <- Res
    ], 

    Res_Len = length(Res), 
    Bin_Res = list_to_binary(BinList_Res),

    Data = <<
        RushId:32,
        Res_Len:16, Bin_Res/binary
    >>,
    {ok, pt:pack(22505, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PlayerId,
    Name,
    FirstValue,
    Rank
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        PlayerId:64,
        Bin_Name/binary,
        FirstValue:64,
        Rank:32
    >>,
    Data.
item_to_bin_1 ({
    RankType,
    Goal
}) ->
    BinList_Goal = [
        item_to_bin_2(Goal_Item) || Goal_Item <- Goal
    ], 

    Goal_Len = length(Goal), 
    Bin_Goal = list_to_binary(BinList_Goal),

    Data = <<
        RankType:32,
        Goal_Len:16, Bin_Goal/binary
    >>,
    Data.
item_to_bin_2 ({
    GoalId,
    Status
}) ->
    Data = <<
        GoalId:64,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    JumpId,
    Label,
    EndTime
}) ->
    Data = <<
        JumpId:32,
        Label:32,
        EndTime:64
    >>,
    Data.
