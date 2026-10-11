-module(pt_405).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40501, _) ->
    {ok, []};
read(40502, Bin0) ->
    <<GodId:16, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(40503, Bin0) ->
    <<GodId:16, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(40504, Bin0) ->
    <<GodId:16, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(40505, Bin0) ->
    <<GodId:16, Bin1/binary>> = Bin0, 
    <<PosId:8, Bin2/binary>> = Bin1, 
    <<GoodsId:64, _Bin3/binary>> = Bin2, 
    {ok, [GodId, PosId, GoodsId]};
read(40506, Bin0) ->
    <<GodId:16, Bin1/binary>> = Bin0, 
    <<ComboId:8, _Bin2/binary>> = Bin1, 
    {ok, [GodId, ComboId]};
read(40507, Bin0) ->
    <<GodId:16, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [GodId, Pos]};
read(40508, Bin0) ->
    <<GodId:16, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [GodId, Pos]};
read(40509, Bin0) ->
    <<GodId:8, Bin1/binary>> = Bin0, 
    <<Lv:16, _Bin2/binary>> = Bin1, 
    {ok, [GodId, Lv]};
read(_Cmd, _R) -> {error, no_match}.

write (40500,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40500, Data)};

write (40501,[
    GuildTitleLv,
    GodList
]) ->
    BinList_GodList = [
        item_to_bin_0(GodList_Item) || GodList_Item <- GodList
    ], 

    GodList_Len = length(GodList), 
    Bin_GodList = list_to_binary(BinList_GodList),

    Data = <<
        GuildTitleLv:16,
        GodList_Len:16, Bin_GodList/binary
    >>,
    {ok, pt:pack(40501, Data)};

write (40502,[
    GodId,
    RuneList,
    ComboId,
    AchievemetnLvs,
    GodPower
]) ->
    BinList_RuneList = [
        item_to_bin_1(RuneList_Item) || RuneList_Item <- RuneList
    ], 

    RuneList_Len = length(RuneList), 
    Bin_RuneList = list_to_binary(BinList_RuneList),

    BinList_AchievemetnLvs = [
        item_to_bin_2(AchievemetnLvs_Item) || AchievemetnLvs_Item <- AchievemetnLvs
    ], 

    AchievemetnLvs_Len = length(AchievemetnLvs), 
    Bin_AchievemetnLvs = list_to_binary(BinList_AchievemetnLvs),

    Data = <<
        GodId:16,
        RuneList_Len:16, Bin_RuneList/binary,
        ComboId:8,
        AchievemetnLvs_Len:16, Bin_AchievemetnLvs/binary,
        GodPower:64
    >>,
    {ok, pt:pack(40502, Data)};

write (40503,[
    GodId,
    Color,
    Lv,
    GodPower
]) ->
    Data = <<
        GodId:16,
        Color:8,
        Lv:16,
        GodPower:64
    >>,
    {ok, pt:pack(40503, Data)};

write (40504,[
    GodId,
    Color,
    Lv,
    GodPower
]) ->
    Data = <<
        GodId:16,
        Color:8,
        Lv:16,
        GodPower:64
    >>,
    {ok, pt:pack(40504, Data)};

write (40505,[
    Code,
    GodId,
    PosId,
    NewGoodsId,
    OldGoodsId,
    NewGoodsTypeId
]) ->
    Data = <<
        Code:32,
        GodId:16,
        PosId:8,
        NewGoodsId:64,
        OldGoodsId:64,
        NewGoodsTypeId:32
    >>,
    {ok, pt:pack(40505, Data)};



write (40507,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(40507, Data)};

write (40508,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(40508, Data)};

write (40509,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(40509, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GodId,
    Color,
    Lv,
    GodPower
}) ->
    Data = <<
        GodId:16,
        Color:8,
        Lv:16,
        GodPower:64
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    GoodsId,
    GoodsTypeId
}) ->
    Data = <<
        Pos:8,
        GoodsId:64,
        GoodsTypeId:32
    >>,
    Data.
item_to_bin_2 (
    AchievemetnLv
) ->
    Data = <<
        AchievemetnLv:16
    >>,
    Data.
