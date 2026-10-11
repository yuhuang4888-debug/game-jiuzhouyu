-module(pt_512).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(51201, _) ->
    {ok, []};
read(51202, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(51203, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<StartPos:8, Bin3/binary>> = Bin2, 
    <<EndPos:8, _Bin4/binary>> = Bin3, 
    {ok, [Type, Subtype, StartPos, EndPos]};
read(51204, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(51205, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<Times:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, Times]};
read(51206, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<StageCount:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, StageCount]};
read(_Cmd, _R) -> {error, no_match}.

write (51201,[
    OpenActList
]) ->
    BinList_OpenActList = [
        item_to_bin_0(OpenActList_Item) || OpenActList_Item <- OpenActList
    ], 

    OpenActList_Len = length(OpenActList), 
    Bin_OpenActList = list_to_binary(BinList_OpenActList),

    Data = <<
        OpenActList_Len:16, Bin_OpenActList/binary
    >>,
    {ok, pt:pack(51201, Data)};

write (51202,[
    Code,
    Type,
    Subtype,
    GradeId,
    GradeCount,
    SelfCount,
    SelfTotalCount,
    StageRewards
]) ->
    BinList_StageRewards = [
        item_to_bin_1(StageRewards_Item) || StageRewards_Item <- StageRewards
    ], 

    StageRewards_Len = length(StageRewards), 
    Bin_StageRewards = list_to_binary(BinList_StageRewards),

    Data = <<
        Code:32,
        Type:16,
        Subtype:16,
        GradeId:16,
        GradeCount:16,
        SelfCount:16,
        SelfTotalCount:16,
        StageRewards_Len:16, Bin_StageRewards/binary
    >>,
    {ok, pt:pack(51202, Data)};

write (51203,[
    Type,
    Subtype,
    StartPos,
    EndPos,
    IsEnd,
    TvRecords
]) ->
    BinList_TvRecords = [
        item_to_bin_2(TvRecords_Item) || TvRecords_Item <- TvRecords
    ], 

    TvRecords_Len = length(TvRecords), 
    Bin_TvRecords = list_to_binary(BinList_TvRecords),

    Data = <<
        Type:16,
        Subtype:16,
        StartPos:8,
        EndPos:8,
        IsEnd:8,
        TvRecords_Len:16, Bin_TvRecords/binary
    >>,
    {ok, pt:pack(51203, Data)};

write (51204,[
    Type,
    Subtype,
    BigRewardRecords
]) ->
    BinList_BigRewardRecords = [
        item_to_bin_3(BigRewardRecords_Item) || BigRewardRecords_Item <- BigRewardRecords
    ], 

    BigRewardRecords_Len = length(BigRewardRecords), 
    Bin_BigRewardRecords = list_to_binary(BinList_BigRewardRecords),

    Data = <<
        Type:16,
        Subtype:16,
        BigRewardRecords_Len:16, Bin_BigRewardRecords/binary
    >>,
    {ok, pt:pack(51204, Data)};

write (51205,[
    Code,
    Type,
    Subtype,
    GradeCount,
    SelfCount,
    SelfTotalCount,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        Type:16,
        Subtype:16,
        GradeCount:16,
        SelfCount:16,
        SelfTotalCount:16,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(51205, Data)};

write (51206,[
    Code,
    Type,
    Subtype,
    StageCount,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        Type:16,
        Subtype:16,
        StageCount:16,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(51206, Data)};

write (51207,[
    Type,
    Subtype,
    GradeId,
    GradeCount,
    SelfCount
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        GradeId:16,
        GradeCount:16,
        SelfCount:16
    >>,
    {ok, pt:pack(51207, Data)};

write (51208,[
    Type,
    Subtype,
    StartTime,
    EndTime,
    BuyEndtime,
    ResetTime,
    GradeId,
    GradeCount,
    SelfCount,
    SelfTotalCount,
    StageRewards
]) ->
    BinList_StageRewards = [
        item_to_bin_4(StageRewards_Item) || StageRewards_Item <- StageRewards
    ], 

    StageRewards_Len = length(StageRewards), 
    Bin_StageRewards = list_to_binary(BinList_StageRewards),

    Data = <<
        Type:16,
        Subtype:16,
        StartTime:32,
        EndTime:32,
        BuyEndtime:32,
        ResetTime:32,
        GradeId:16,
        GradeCount:16,
        SelfCount:16,
        SelfTotalCount:16,
        StageRewards_Len:16, Bin_StageRewards/binary
    >>,
    {ok, pt:pack(51208, Data)};

write (51209,[
    Type,
    Subtype,
    GradeId,
    GradeCount
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        GradeId:16,
        GradeCount:16
    >>,
    {ok, pt:pack(51209, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    Subtype,
    StartTime,
    EndTime,
    BuyEndtime,
    ResetTime
}) ->
    Data = <<
        Type:16,
        Subtype:16,
        StartTime:32,
        EndTime:32,
        BuyEndtime:32,
        ResetTime:32
    >>,
    Data.
item_to_bin_1 ({
    StageCount,
    StageWlv,
    RewardSt
}) ->
    Data = <<
        StageCount:16,
        StageWlv:16,
        RewardSt:8
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    Name,
    ServerId,
    ServerNum,
    Rewards,
    Time
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        ServerId:16,
        ServerNum:16,
        Bin_Rewards/binary,
        Time:32
    >>,
    Data.
item_to_bin_3 ({
    RoleId,
    Name,
    ServerId,
    ServerNum,
    GradeId,
    SelfCount,
    Time
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        ServerId:16,
        ServerNum:16,
        GradeId:16,
        SelfCount:16,
        Time:32
    >>,
    Data.
item_to_bin_4 ({
    StageCount,
    StageWlv,
    RewardSt
}) ->
    Data = <<
        StageCount:16,
        StageWlv:16,
        RewardSt:8
    >>,
    Data.
