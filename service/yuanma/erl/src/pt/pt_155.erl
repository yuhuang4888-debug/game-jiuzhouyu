-module(pt_155).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15501, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(15502, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(15503, Bin0) ->
    <<EquipPos:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipPos]};
read(15504, Bin0) ->
    <<EquipPos:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipPos]};
read(15505, _) ->
    {ok, []};
read(15506, Bin0) ->
    <<GoodsId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15507, _) ->
    {ok, []};
read(15550, _) ->
    {ok, []};
read(15551, _) ->
    {ok, []};
read(15552, _) ->
    {ok, []};
read(15554, Bin0) ->
    <<MonId:32, _Bin1/binary>> = Bin0, 
    {ok, [MonId]};
read(15555, _) ->
    {ok, []};
read(15556, _) ->
    {ok, []};
read(15557, _) ->
    {ok, []};
read(15558, _) ->
    {ok, []};
read(15560, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (15500,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(15500, Data)};

write (15501,[
    Id,
    OldId
]) ->
    Data = <<
        Id:64,
        OldId:64
    >>,
    {ok, pt:pack(15501, Data)};

write (15502,[
    Id
]) ->
    Data = <<
        Id:64
    >>,
    {ok, pt:pack(15502, Data)};

write (15503,[
    EquipPos,
    Stren,
    Exp
]) ->
    Data = <<
        EquipPos:8,
        Stren:16,
        Exp:32
    >>,
    {ok, pt:pack(15503, Data)};

write (15504,[
    EquipPos,
    Stren,
    Mul,
    Exp
]) ->
    Data = <<
        EquipPos:8,
        Stren:16,
        Mul:8,
        Exp:32
    >>,
    {ok, pt:pack(15504, Data)};

write (15505,[
    SoulList
]) ->
    BinList_SoulList = [
        item_to_bin_0(SoulList_Item) || SoulList_Item <- SoulList
    ], 

    SoulList_Len = length(SoulList), 
    Bin_SoulList = list_to_binary(BinList_SoulList),

    Data = <<
        SoulList_Len:16, Bin_SoulList/binary
    >>,
    {ok, pt:pack(15505, Data)};

write (15506,[
    GoodsId,
    UseCount
]) ->
    Data = <<
        GoodsId:32,
        UseCount:32
    >>,
    {ok, pt:pack(15506, Data)};

write (15507,[
    Attr
]) ->
    Bin_Attr = pt:write_attr_list(Attr), 

    Data = <<
        Bin_Attr/binary
    >>,
    {ok, pt:pack(15507, Data)};

write (15550,[
    TotemAlive,
    EndTime
]) ->
    Data = <<
        TotemAlive:8,
        EndTime:32
    >>,
    {ok, pt:pack(15550, Data)};

write (15551,[
    LeftCount,
    TotalCount,
    NeedTicket
]) ->
    Data = <<
        LeftCount:8,
        TotalCount:8,
        NeedTicket:8
    >>,
    {ok, pt:pack(15551, Data)};

write (15552,[
    EnergyValue
]) ->
    Data = <<
        EnergyValue:16
    >>,
    {ok, pt:pack(15552, Data)};

write (15553,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15553, Data)};

write (15554,[
    MonId
]) ->
    Data = <<
        MonId:32
    >>,
    {ok, pt:pack(15554, Data)};

write (15555,[
    TotemId
]) ->
    Data = <<
        TotemId:32
    >>,
    {ok, pt:pack(15555, Data)};

write (15556,[
    EnergyValue
]) ->
    Data = <<
        EnergyValue:16
    >>,
    {ok, pt:pack(15556, Data)};

write (15557,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15557, Data)};

write (15558,[
    TotemList
]) ->
    BinList_TotemList = [
        item_to_bin_1(TotemList_Item) || TotemList_Item <- TotemList
    ], 

    TotemList_Len = length(TotemList), 
    Bin_TotemList = list_to_binary(BinList_TotemList),

    Data = <<
        TotemList_Len:16, Bin_TotemList/binary
    >>,
    {ok, pt:pack(15558, Data)};

write (15559,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15559, Data)};

write (15560,[
    DropLog
]) ->
    BinList_DropLog = [
        item_to_bin_2(DropLog_Item) || DropLog_Item <- DropLog
    ], 

    DropLog_Len = length(DropLog), 
    Bin_DropLog = list_to_binary(BinList_DropLog),

    Data = <<
        DropLog_Len:16, Bin_DropLog/binary
    >>,
    {ok, pt:pack(15560, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GoodsId,
    UseCount
}) ->
    Data = <<
        GoodsId:32,
        UseCount:32
    >>,
    Data.
item_to_bin_1 ({
    Id,
    Num
}) ->
    Data = <<
        Id:32,
        Num:8
    >>,
    Data.
item_to_bin_2 ({
    Time,
    SName,
    RoleId,
    ServerId,
    Name,
    SceneId,
    BossId,
    GoodsId,
    Rating,
    EquipExtraAttr
}) ->
    Bin_SName = pt:write_string(SName), 

    Bin_Name = pt:write_string(Name), 

    BinList_EquipExtraAttr = [
        item_to_bin_3(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Time:32,
        Bin_SName/binary,
        RoleId:64,
        ServerId:16,
        Bin_Name/binary,
        SceneId:32,
        BossId:32,
        GoodsId:32,
        Rating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    Data.
item_to_bin_3 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
