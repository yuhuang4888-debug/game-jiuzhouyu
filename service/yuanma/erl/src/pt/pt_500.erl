-module(pt_500).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(50000, _) ->
    {ok, []};
read(50001, Bin0) ->
    <<RandType:8, Bin1/binary>> = Bin0, 
    <<AngelId:32, _Bin2/binary>> = Bin1, 
    {ok, [RandType, AngelId]};
read(50002, Bin0) ->
    <<AngelId:32, _Bin1/binary>> = Bin0, 
    {ok, [AngelId]};
read(50003, _) ->
    {ok, []};
read(50004, _) ->
    {ok, []};
read(50005, _) ->
    {ok, []};
read(50007, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(50009, _) ->
    {ok, []};
read(50010, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (50000,[
    Code,
    IfDoudle,
    LessTodayHusongNum,
    TodayHusongNumMax,
    RewardSendList
]) ->
    BinList_RewardSendList = [
        item_to_bin_0(RewardSendList_Item) || RewardSendList_Item <- RewardSendList
    ], 

    RewardSendList_Len = length(RewardSendList), 
    Bin_RewardSendList = list_to_binary(BinList_RewardSendList),

    Data = <<
        Code:32,
        IfDoudle:8,
        LessTodayHusongNum:16,
        TodayHusongNumMax:16,
        RewardSendList_Len:16, Bin_RewardSendList/binary
    >>,
    {ok, pt:pack(50000, Data)};

write (50001,[
    Code1,
    Code2,
    RandType,
    AngelId,
    AngelName,
    GoodsNum,
    BgoldNum,
    GoldNum
]) ->
    Bin_AngelName = pt:write_string(AngelName), 

    Data = <<
        Code1:32,
        Code2:32,
        RandType:8,
        AngelId:32,
        Bin_AngelName/binary,
        GoodsNum:32,
        BgoldNum:32,
        GoldNum:32
    >>,
    {ok, pt:pack(50001, Data)};

write (50002,[
    Code,
    AngelId
]) ->
    Data = <<
        Code:32,
        AngelId:32
    >>,
    {ok, pt:pack(50002, Data)};

write (50003,[
    Code,
    AngelId,
    IsDouble,
    LessHusongNum
]) ->
    Data = <<
        Code:32,
        AngelId:32,
        IsDouble:8,
        LessHusongNum:16
    >>,
    {ok, pt:pack(50003, Data)};

write (50004,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(50004, Data)};

write (50005,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(50005, Data)};

write (50006,[
    RoleId,
    AngelId
]) ->
    Data = <<
        RoleId:64,
        AngelId:32
    >>,
    {ok, pt:pack(50006, Data)};

write (50007,[
    Code,
    RoleId,
    X,
    Y
]) ->
    Data = <<
        Code:32,
        RoleId:64,
        X:32,
        Y:32
    >>,
    {ok, pt:pack(50007, Data)};

write (50008,[
    Type,
    ExpList
]) ->
    BinList_ExpList = [
        item_to_bin_1(ExpList_Item) || ExpList_Item <- ExpList
    ], 

    ExpList_Len = length(ExpList), 
    Bin_ExpList = list_to_binary(BinList_ExpList),

    Data = <<
        Type:8,
        ExpList_Len:16, Bin_ExpList/binary
    >>,
    {ok, pt:pack(50008, Data)};

write (50009,[
    IfDoudle,
    Stage,
    RewardStage,
    RewardListFirst
]) ->
    BinList_RewardListFirst = [
        item_to_bin_2(RewardListFirst_Item) || RewardListFirst_Item <- RewardListFirst
    ], 

    RewardListFirst_Len = length(RewardListFirst), 
    Bin_RewardListFirst = list_to_binary(BinList_RewardListFirst),

    Data = <<
        IfDoudle:32,
        Stage:8,
        RewardStage:8,
        RewardListFirst_Len:16, Bin_RewardListFirst/binary
    >>,
    {ok, pt:pack(50009, Data)};

write (50010,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(50010, Data)};

write (50011,[
    IfDoudle
]) ->
    Data = <<
        IfDoudle:32
    >>,
    {ok, pt:pack(50011, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AngelId1,
    CoinNum,
    ExpNum
}) ->
    Data = <<
        AngelId1:32,
        CoinNum:64,
        ExpNum:64
    >>,
    Data.
item_to_bin_1 ({
    GoodsType,
    GoodsTypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:32,
        GoodsTypeId:32,
        GoodsNum:64
    >>,
    Data.
item_to_bin_2 ({
    GoodsType,
    GoodsTypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:32,
        GoodsTypeId:32,
        GoodsNum:32
    >>,
    Data.
