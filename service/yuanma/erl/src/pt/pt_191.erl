-module(pt_191).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(19101, _) ->
    {ok, []};
read(19102, Bin0) ->
    <<GiftId:16, Bin1/binary>> = Bin0, 
    <<SubId:16, _Bin2/binary>> = Bin1, 
    {ok, [GiftId, SubId]};
read(19103, Bin0) ->
    <<GiftId:16, Bin1/binary>> = Bin0, 
    <<SubId:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [GiftId, SubId, GradeId]};
read(19104, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (19101,[
    Type,
    GiftList
]) ->
    BinList_GiftList = [
        item_to_bin_0(GiftList_Item) || GiftList_Item <- GiftList
    ], 

    GiftList_Len = length(GiftList), 
    Bin_GiftList = list_to_binary(BinList_GiftList),

    Data = <<
        Type:8,
        GiftList_Len:16, Bin_GiftList/binary
    >>,
    {ok, pt:pack(19101, Data)};

write (19102,[
    GiftId,
    SubId,
    GiftName,
    EndTime,
    Conditions,
    RewardList
]) ->
    Bin_GiftName = pt:write_string(GiftName), 

    Bin_Conditions = pt:write_string(Conditions), 

    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        GiftId:16,
        SubId:16,
        Bin_GiftName/binary,
        EndTime:32,
        Bin_Conditions/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(19102, Data)};

write (19103,[
    Code,
    GiftId,
    SubId,
    GradeId,
    BuyCnt
]) ->
    Data = <<
        Code:32,
        GiftId:16,
        SubId:16,
        GradeId:16,
        BuyCnt:8
    >>,
    {ok, pt:pack(19103, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GiftId,
    SubId,
    TitleName,
    GiftName,
    EndTime,
    Infos
}) ->
    Bin_TitleName = pt:write_string(TitleName), 

    Bin_GiftName = pt:write_string(GiftName), 

    Bin_Infos = pt:write_string(Infos), 

    Data = <<
        GiftId:16,
        SubId:16,
        Bin_TitleName/binary,
        Bin_GiftName/binary,
        EndTime:32,
        Bin_Infos/binary
    >>,
    Data.
item_to_bin_1 ({
    GradeId,
    GradeName,
    BuyCnt,
    BuyTime,
    RewardsConditions,
    Rewards
}) ->
    Bin_GradeName = pt:write_string(GradeName), 

    Bin_RewardsConditions = pt:write_string(RewardsConditions), 

    Bin_Rewards = pt:write_string(Rewards), 

    Data = <<
        GradeId:16,
        Bin_GradeName/binary,
        BuyCnt:8,
        BuyTime:32,
        Bin_RewardsConditions/binary,
        Bin_Rewards/binary
    >>,
    Data.
