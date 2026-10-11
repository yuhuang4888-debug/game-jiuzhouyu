-module(pt_133).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13300, _) ->
    {ok, []};
read(13301, _) ->
    {ok, []};
read(13302, _) ->
    {ok, []};
read(13303, _) ->
    {ok, []};
read(13304, _) ->
    {ok, []};
read(13305, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(13306, _) ->
    {ok, []};
read(13307, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(13308, _) ->
    {ok, []};
read(13309, _) ->
    {ok, []};
read(13310, Bin0) ->
    <<Gate:64, _Bin1/binary>> = Bin0, 
    {ok, [Gate]};
read(13311, _) ->
    {ok, []};
read(13320, _) ->
    {ok, []};
read(13321, Bin0) ->
    <<SoapId:16, Bin1/binary>> = Bin0, 
    <<DebrisId:16, _Bin2/binary>> = Bin1, 
    {ok, [SoapId, DebrisId]};
read(13322, Bin0) ->
    <<Node:8, _Bin1/binary>> = Bin0, 
    {ok, [Node]};
read(13323, _) ->
    {ok, []};
read(13324, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (13300,[
    Code,
    CurrentTimes,
    NeedTimes,
    AssistId,
    AssisterId
]) ->
    Data = <<
        Code:32,
        CurrentTimes:32,
        NeedTimes:32,
        AssistId:64,
        AssisterId:64
    >>,
    {ok, pt:pack(13300, Data)};

write (13301,[
    RankType,
    RoleRank,
    Level,
    Res
]) ->
    BinList_Res = [
        item_to_bin_0(Res_Item) || Res_Item <- Res
    ], 

    Res_Len = length(Res), 
    Bin_Res = list_to_binary(BinList_Res),

    Data = <<
        RankType:8,
        RoleRank:32,
        Level:32,
        Res_Len:16, Bin_Res/binary
    >>,
    {ok, pt:pack(13301, Data)};

write (13302,[
    Code,
    MaxTimes,
    CurrentTimes,
    Cost,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        MaxTimes:32,
        CurrentTimes:32,
        Cost:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(13302, Data)};

write (13303,[
    Code,
    CurrentTimes,
    EquipNum
]) ->
    Data = <<
        Code:32,
        CurrentTimes:16,
        EquipNum:32
    >>,
    {ok, pt:pack(13303, Data)};

write (13304,[
    Code,
    Coin,
    Exp,
    EquipNum,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        Coin:32,
        Exp:32,
        EquipNum:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(13304, Data)};

write (13305,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(13305, Data)};

write (13306,[
    Code,
    State,
    Coin,
    Exp,
    RewardArray
]) ->
    BinList_RewardArray = [
        item_to_bin_1(RewardArray_Item) || RewardArray_Item <- RewardArray
    ], 

    RewardArray_Len = length(RewardArray), 
    Bin_RewardArray = list_to_binary(BinList_RewardArray),

    Data = <<
        Code:32,
        State:8,
        Coin:32,
        Exp:32,
        RewardArray_Len:16, Bin_RewardArray/binary
    >>,
    {ok, pt:pack(13306, Data)};

write (13307,[
    Code,
    Type
]) ->
    Data = <<
        Code:32,
        Type:8
    >>,
    {ok, pt:pack(13307, Data)};

write (13308,[
    Code,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(13308, Data)};

write (13309,[
    Code,
    NextStageRewardGate
]) ->
    Data = <<
        Code:32,
        NextStageRewardGate:64
    >>,
    {ok, pt:pack(13309, Data)};

write (13310,[
    Code,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(13310, Data)};

write (13311,[
    Code,
    Gold,
    Exp
]) ->
    Data = <<
        Code:32,
        Gold:64,
        Exp:64
    >>,
    {ok, pt:pack(13311, Data)};

write (13320,[
    Combat,
    SoapList
]) ->
    BinList_SoapList = [
        item_to_bin_3(SoapList_Item) || SoapList_Item <- SoapList
    ], 

    SoapList_Len = length(SoapList), 
    Bin_SoapList = list_to_binary(BinList_SoapList),

    Data = <<
        Combat:64,
        SoapList_Len:16, Bin_SoapList/binary
    >>,
    {ok, pt:pack(13320, Data)};

write (13321,[
    Errcode,
    SoapId,
    DebrisList,
    Combat
]) ->
    BinList_DebrisList = [
        item_to_bin_5(DebrisList_Item) || DebrisList_Item <- DebrisList
    ], 

    DebrisList_Len = length(DebrisList), 
    Bin_DebrisList = list_to_binary(BinList_DebrisList),

    Data = <<
        Errcode:32,
        SoapId:16,
        DebrisList_Len:16, Bin_DebrisList/binary,
        Combat:64
    >>,
    {ok, pt:pack(13321, Data)};

write (13322,[
    Node
]) ->
    Data = <<
        Node:8
    >>,
    {ok, pt:pack(13322, Data)};

write (13323,[
    Node
]) ->
    Data = <<
        Node:8
    >>,
    {ok, pt:pack(13323, Data)};

write (13324,[
    DailyAskTime,
    NextAskTime
]) ->
    Data = <<
        DailyAskTime:16,
        NextAskTime:32
    >>,
    {ok, pt:pack(13324, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    RoleId,
    RoleName,
    Rank,
    Level,
    Combat
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerId:32,
        ServerNum:32,
        RoleId:64,
        Bin_RoleName/binary,
        Rank:32,
        Level:32,
        Combat:64
    >>,
    Data.
item_to_bin_1 ({
    Type,
    RewardList
}) ->
    BinList_RewardList = [
        item_to_bin_2(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Type:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    Data.
item_to_bin_2 ({
    Style,
    TypeId,
    Count,
    GoodsId
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:32,
        GoodsId:64
    >>,
    Data.
item_to_bin_3 ({
    SoapId,
    DebrisList
}) ->
    BinList_DebrisList = [
        item_to_bin_4(DebrisList_Item) || DebrisList_Item <- DebrisList
    ], 

    DebrisList_Len = length(DebrisList), 
    Bin_DebrisList = list_to_binary(BinList_DebrisList),

    Data = <<
        SoapId:16,
        DebrisList_Len:16, Bin_DebrisList/binary
    >>,
    Data.
item_to_bin_4 (
    DebrisId
) ->
    Data = <<
        DebrisId:16
    >>,
    Data.
item_to_bin_5 (
    DebrisId
) ->
    Data = <<
        DebrisId:16
    >>,
    Data.
