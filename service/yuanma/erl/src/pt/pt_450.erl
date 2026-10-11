-module(pt_450).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(45000, _) ->
    {ok, []};
read(45001, Bin0) ->
    <<VipLv:16, _Bin1/binary>> = Bin0,
    {ok, [VipLv]};
read(45002, Bin0) ->
    <<VipLv:16, _Bin1/binary>> = Bin0,
    {ok, [VipLv]};
read(45003, Bin0) ->
    <<CardType:8, _Bin1/binary>> = Bin0,
    {ok, [CardType]};
read(45004, _) ->
    {ok, []};
read(45006, _) ->
    {ok, []};
read(45007, Bin0) ->
    <<CardType:8, _Bin1/binary>> = Bin0,
    {ok, [CardType]};
read(45008, Bin0) ->
    <<Hide:8, _Bin1/binary>> = Bin0, 
    {ok, [Hide]};
read(_Cmd, _R) -> {error, no_match}.

write (45000,[
    VipLv,
    VipExp,
    NeedExp,
    VipHide,
    GotRewardList,
    CanRewardList,
    UseCardList
]) ->
    BinList_GotRewardList = [
        item_to_bin_0(GotRewardList_Item) || GotRewardList_Item <- GotRewardList
    ],
    
    GotRewardList_Len = length(GotRewardList),
    Bin_GotRewardList = list_to_binary(BinList_GotRewardList),
    
    BinList_CanRewardList = [
        item_to_bin_1(CanRewardList_Item) || CanRewardList_Item <- CanRewardList
    ],
    
    CanRewardList_Len = length(CanRewardList),
    Bin_CanRewardList = list_to_binary(BinList_CanRewardList),
    
    BinList_UseCardList = [
        item_to_bin_2(UseCardList_Item) || UseCardList_Item <- UseCardList
    ],
    
    UseCardList_Len = length(UseCardList),
    Bin_UseCardList = list_to_binary(BinList_UseCardList),
    
    Data = <<
        VipLv:16,
        VipExp:32,
        NeedExp:32,
        VipHide:8,
        GotRewardList_Len:16, Bin_GotRewardList/binary,
        CanRewardList_Len:16, Bin_CanRewardList/binary,
        UseCardList_Len:16, Bin_UseCardList/binary
    >>,
    {ok, pt:pack(45000, Data)};

write (45001,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(45001, Data)};

write (45002,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(45002, Data)};

write (45003,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(45003, Data)};

write (45004,[
    Info
]) ->
    BinList_Info = [
        item_to_bin_3(Info_Item) || Info_Item <- Info
    ],
    
    Info_Len = length(Info),
    Bin_Info = list_to_binary(BinList_Info),
    
    Data = <<
        Info_Len:16, Bin_Info/binary
    >>,
    {ok, pt:pack(45004, Data)};

write (45005,[
    CardType,
    IsTempCard
]) ->
    Data = <<
        CardType:8,
        IsTempCard:8
    >>,
    {ok, pt:pack(45005, Data)};

write (45006,[
    CardType,
    IsTempCard
]) ->
    Data = <<
        CardType:8,
        IsTempCard:8
    >>,
    {ok, pt:pack(45006, Data)};

write (45007,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(45007, Data)};

write (45008,[
    Hide
]) ->
    Data = <<
        Hide:8
    >>,
    {ok, pt:pack(45008, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    GotReward
) ->
    Data = <<
        GotReward:16
    >>,
    Data.
item_to_bin_1 (
    CanReward
) ->
    Data = <<
        CanReward:16
    >>,
    Data.
item_to_bin_2 ({
    UseCard,
    Time
}) ->
    Data = <<
        UseCard:8,
        Time:32
    >>,
    Data.
item_to_bin_3 ({
    CardType,
    IsTempCard,
    IsActive,
    IsForever,
    Time
}) ->
    Data = <<
        CardType:8,
        IsTempCard:8,
        IsActive:8,
        IsForever:8,
        Time:32
    >>,
    Data.
