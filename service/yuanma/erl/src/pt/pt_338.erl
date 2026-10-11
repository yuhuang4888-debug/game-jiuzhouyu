-module(pt_338).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(33800, _) ->
    {ok, []};
read(33801, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33802, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33803, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<Times:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, Times]};
read(33804, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<RewardId:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, RewardId]};
read(33805, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<CostType:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, CostType]};
read(33806, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<CostType:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, CostType]};
read(33807, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(_Cmd, _R) -> {error, no_match}.

write (33800,[
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_0(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(33800, Data)};

write (33801,[
    Type,
    Subtype,
    IsOpen,
    Score,
    TodayScore,
    Cost,
    TenCost,
    RewardList,
    StageList,
    WorldLv
]) ->
    Bin_Cost = pt:write_object_list(Cost), 

    Bin_TenCost = pt:write_object_list(TenCost), 

    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_StageList = [
        item_to_bin_2(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        Type:16,
        Subtype:16,
        IsOpen:8,
        Score:32,
        TodayScore:32,
        Bin_Cost/binary,
        Bin_TenCost/binary,
        RewardList_Len:16, Bin_RewardList/binary,
        StageList_Len:16, Bin_StageList/binary,
        WorldLv:32
    >>,
    {ok, pt:pack(33801, Data)};

write (33802,[
    Type,
    Subtype,
    Score,
    Rank,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_3(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Type:16,
        Subtype:16,
        Score:32,
        Rank:16,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(33802, Data)};

write (33803,[
    Type,
    Subtype,
    Times,
    TodayScore,
    ErrorCode,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_4(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Type:16,
        Subtype:16,
        Times:8,
        TodayScore:32,
        ErrorCode:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33803, Data)};

write (33804,[
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
    {ok, pt:pack(33804, Data)};

write (33805,[
    Type,
    Subtype,
    IsOpen,
    Score,
    Times,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_5(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Type:16,
        Subtype:16,
        IsOpen:8,
        Score:32,
        Times:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33805, Data)};

write (33806,[
    Type,
    Subtype,
    CostType,
    ErrorCode,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_6(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Type:16,
        Subtype:16,
        CostType:8,
        ErrorCode:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33806, Data)};

write (33807,[
    Type,
    Subtype,
    Num,
    Recharge
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Num:16,
        Recharge:32
    >>,
    {ok, pt:pack(33807, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    Subtype,
    ShowId,
    StartTime,
    EndTime,
    BuyEndTime
}) ->
    Data = <<
        Type:16,
        Subtype:16,
        ShowId:16,
        StartTime:32,
        EndTime:32,
        BuyEndTime:32
    >>,
    Data.
item_to_bin_1 (
    RewardId
) ->
    Data = <<
        RewardId:16
    >>,
    Data.
item_to_bin_2 ({
    Id,
    GotType
}) ->
    Data = <<
        Id:16,
        GotType:8
    >>,
    Data.
item_to_bin_3 ({
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
item_to_bin_4 ({
    RewardId,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        RewardId:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_5 (
    RewardId
) ->
    Data = <<
        RewardId:16
    >>,
    Data.
item_to_bin_6 ({
    RewardId,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        RewardId:16,
        Bin_Reward/binary
    >>,
    Data.
