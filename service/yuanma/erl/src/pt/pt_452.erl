-module(pt_452).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(45201, _) ->
    {ok, []};
read(45202, _) ->
    {ok, []};
read(45203, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (45201,[
    Lv,
    Exp,
    IsActivity,
    GiftBagNum,
    CanReceiveGift,
    ExpiredTime
]) ->
    Data = <<
        Lv:16,
        Exp:32,
        IsActivity:8,
        GiftBagNum:16,
        CanReceiveGift:16,
        ExpiredTime:32
    >>,
    {ok, pt:pack(45201, Data)};

write (45202,[
    Code,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_0(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Code:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(45202, Data)};

write (45203,[
    Type,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_1(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Type:8,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(45203, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Style,
    TypeId,
    Count
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:32
    >>,
    Data.
item_to_bin_1 ({
    Style,
    TypeId,
    Count
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:32
    >>,
    Data.
