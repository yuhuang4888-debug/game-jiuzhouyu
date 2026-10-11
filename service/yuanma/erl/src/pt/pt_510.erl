-module(pt_510).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(51001, _) ->
    {ok, []};
read(51003, Bin0) ->
    <<RotaryId:32, _Bin1/binary>> = Bin0, 
    {ok, [RotaryId]};
read(51004, Bin0) ->
    <<RotaryId:32, _Bin1/binary>> = Bin0, 
    {ok, [RotaryId]};
read(51005, Bin0) ->
    <<RotaryId:32, _Bin1/binary>> = Bin0, 
    {ok, [RotaryId]};
read(_Cmd, _R) -> {error, no_match}.

write (51001,[
    RotaryList
]) ->
    BinList_RotaryList = [
        item_to_bin_0(RotaryList_Item) || RotaryList_Item <- RotaryList
    ], 

    RotaryList_Len = length(RotaryList), 
    Bin_RotaryList = list_to_binary(BinList_RotaryList),

    Data = <<
        RotaryList_Len:16, Bin_RotaryList/binary
    >>,
    {ok, pt:pack(51001, Data)};

write (51002,[
    RotaryId,
    BossType,
    BossRewardLv,
    BossId,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_2(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RotaryId:32,
        BossType:8,
        BossRewardLv:16,
        BossId:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(51002, Data)};

write (51003,[
    Code,
    RotaryId
]) ->
    Data = <<
        Code:32,
        RotaryId:32
    >>,
    {ok, pt:pack(51003, Data)};

write (51004,[
    Code,
    RotaryId,
    PoolId,
    RewardId,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        RotaryId:32,
        PoolId:8,
        RewardId:16,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(51004, Data)};

write (51005,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(51005, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RotaryId,
    BossType,
    BossRewardLv,
    BossId,
    RewardList
}) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RotaryId:32,
        BossType:8,
        BossRewardLv:16,
        BossId:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    Data.
item_to_bin_1 ({
    PoolId,
    RewardId,
    Rare,
    IsGet,
    Rewards
}) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        PoolId:8,
        RewardId:16,
        Rare:8,
        IsGet:8,
        Bin_Rewards/binary
    >>,
    Data.
item_to_bin_2 ({
    PoolId,
    RewardId,
    Rare,
    IsGet,
    Rewards
}) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        PoolId:8,
        RewardId:16,
        Rare:8,
        IsGet:8,
        Bin_Rewards/binary
    >>,
    Data.
