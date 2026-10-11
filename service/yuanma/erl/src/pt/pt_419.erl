-module(pt_419).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41900, _) ->
    {ok, []};
read(41903, Bin0) ->
    <<ActId:32, Bin1/binary>> = Bin0, 
    <<ActSub:16, Bin2/binary>> = Bin1, 
    <<Type:8, Bin3/binary>> = Bin2, 
    <<Times:16, Bin4/binary>> = Bin3, 
    <<TimesOthers:16, _Bin5/binary>> = Bin4, 
    {ok, [ActId, ActSub, Type, Times, TimesOthers]};
read(41904, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(_Cmd, _R) -> {error, no_match}.

write (41900,[
    Errcode,
    ResAct
]) ->
    BinList_ResAct = [
        item_to_bin_0(ResAct_Item) || ResAct_Item <- ResAct
    ], 

    ResAct_Len = length(ResAct), 
    Bin_ResAct = list_to_binary(BinList_ResAct),

    Data = <<
        Errcode:32,
        ResAct_Len:16, Bin_ResAct/binary
    >>,
    {ok, pt:pack(41900, Data)};

write (41903,[
    Errcode,
    Type,
    ActId,
    ActSub,
    Lefttimes,
    LefttimesVip,
    RewardLv
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        ActId:32,
        ActSub:16,
        Lefttimes:16,
        LefttimesVip:16,
        RewardLv:32
    >>,
    {ok, pt:pack(41903, Data)};

write (41904,[
    Errcode,
    Type,
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_1(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        Errcode:32,
        Type:8,
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(41904, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ActId,
    ActSub,
    Lefttimes,
    LefttimesVip,
    RewardLv
}) ->
    Data = <<
        ActId:32,
        ActSub:16,
        Lefttimes:16,
        LefttimesVip:16,
        RewardLv:32
    >>,
    Data.
item_to_bin_1 ({
    ActId,
    ActSub,
    Lefttimes,
    LefttimesVip,
    RewardLv
}) ->
    Data = <<
        ActId:32,
        ActSub:16,
        Lefttimes:16,
        LefttimesVip:16,
        RewardLv:32
    >>,
    Data.
