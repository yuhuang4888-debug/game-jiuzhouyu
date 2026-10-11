-module(pt_470).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(47000, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(47001, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(47002, _) ->
    {ok, []};
read(47003, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(47004, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(47005, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, Bin2/binary>> = Bin1, 
    <<Remind:8, _Bin3/binary>> = Bin2, 
    {ok, [BossType, BossId, Remind]};
read(47011, _) ->
    {ok, []};
read(47015, _) ->
    {ok, []};
read(47017, _) ->
    {ok, []};
read(47019, _) ->
    {ok, []};
read(47021, _) ->
    {ok, []};
read(47022, _) ->
    {ok, []};
read(47023, _) ->
    {ok, []};
read(47034, _) ->
    {ok, []};
read(47035, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(_Cmd, _R) -> {error, no_match}.

write (47000,[
    BossType,
    ActStatus,
    ResetEtime,
    Tired,
    MaxTired,
    CollectList,
    BossInfo
]) ->
    BinList_CollectList = [
        item_to_bin_0(CollectList_Item) || CollectList_Item <- CollectList
    ], 

    CollectList_Len = length(CollectList), 
    Bin_CollectList = list_to_binary(BinList_CollectList),

    BinList_BossInfo = [
        item_to_bin_1(BossInfo_Item) || BossInfo_Item <- BossInfo
    ], 

    BossInfo_Len = length(BossInfo), 
    Bin_BossInfo = list_to_binary(BinList_BossInfo),

    Data = <<
        BossType:8,
        ActStatus:8,
        ResetEtime:32,
        Tired:8,
        MaxTired:8,
        CollectList_Len:16, Bin_CollectList/binary,
        BossInfo_Len:16, Bin_BossInfo/binary
    >>,
    {ok, pt:pack(47000, Data)};

write (47001,[
    KillLog
]) ->
    BinList_KillLog = [
        item_to_bin_2(KillLog_Item) || KillLog_Item <- KillLog
    ], 

    KillLog_Len = length(KillLog), 
    Bin_KillLog = list_to_binary(BinList_KillLog),

    Data = <<
        KillLog_Len:16, Bin_KillLog/binary
    >>,
    {ok, pt:pack(47001, Data)};

write (47002,[
    DropLog
]) ->
    BinList_DropLog = [
        item_to_bin_3(DropLog_Item) || DropLog_Item <- DropLog
    ], 

    DropLog_Len = length(DropLog), 
    Bin_DropLog = list_to_binary(BinList_DropLog),

    Data = <<
        DropLog_Len:16, Bin_DropLog/binary
    >>,
    {ok, pt:pack(47002, Data)};

write (47003,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(47003, Data)};

write (47004,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(47004, Data)};

write (47005,[
    Code,
    BossType,
    BossId,
    Remind
]) ->
    Data = <<
        Code:32,
        BossType:8,
        BossId:32,
        Remind:8
    >>,
    {ok, pt:pack(47005, Data)};

write (47006,[
    BossType,
    BossId
]) ->
    Data = <<
        BossType:8,
        BossId:32
    >>,
    {ok, pt:pack(47006, Data)};

write (47007,[
    BossType,
    BossId,
    RebornTime,
    Num
]) ->
    Data = <<
        BossType:8,
        BossId:32,
        RebornTime:32,
        Num:8
    >>,
    {ok, pt:pack(47007, Data)};

write (47008,[
    BossType,
    BossId,
    RebornTime,
    Num
]) ->
    Data = <<
        BossType:8,
        BossId:32,
        RebornTime:32,
        Num:8
    >>,
    {ok, pt:pack(47008, Data)};

write (47009,[
    BossTired
]) ->
    Data = <<
        BossTired:8
    >>,
    {ok, pt:pack(47009, Data)};

write (47010,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(47010, Data)};

write (47011,[
    NextResetTime,
    ServerList
]) ->
    BinList_ServerList = [
        item_to_bin_5(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        NextResetTime:32,
        ServerList_Len:16, Bin_ServerList/binary
    >>,
    {ok, pt:pack(47011, Data)};

write (47015,[
    RewardType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_6(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardType:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(47015, Data)};

write (47016,[
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_7(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(47016, Data)};

write (47017,[
    Info
]) ->
    BinList_Info = [
        item_to_bin_8(Info_Item) || Info_Item <- Info
    ], 

    Info_Len = length(Info), 
    Bin_Info = list_to_binary(BinList_Info),

    Data = <<
        Info_Len:16, Bin_Info/binary
    >>,
    {ok, pt:pack(47017, Data)};

write (47018,[
    BossId,
    Xylist
]) ->
    BinList_Xylist = [
        item_to_bin_10(Xylist_Item) || Xylist_Item <- Xylist
    ], 

    Xylist_Len = length(Xylist), 
    Bin_Xylist = list_to_binary(BinList_Xylist),

    Data = <<
        BossId:32,
        Xylist_Len:16, Bin_Xylist/binary
    >>,
    {ok, pt:pack(47018, Data)};

write (47019,[
    Level,
    Exp,
    AddExp
]) ->
    Data = <<
        Level:16,
        Exp:32,
        AddExp:32
    >>,
    {ok, pt:pack(47019, Data)};

write (47021,[
    PlayerList
]) ->
    BinList_PlayerList = [
        item_to_bin_11(PlayerList_Item) || PlayerList_Item <- PlayerList
    ], 

    PlayerList_Len = length(PlayerList), 
    Bin_PlayerList = list_to_binary(BinList_PlayerList),

    Data = <<
        PlayerList_Len:16, Bin_PlayerList/binary
    >>,
    {ok, pt:pack(47021, Data)};

write (47022,[
    ScoreType,
    ScoreAdd
]) ->
    Data = <<
        ScoreType:8,
        ScoreAdd:16
    >>,
    {ok, pt:pack(47022, Data)};

write (47023,[
    MaxTired
]) ->
    Data = <<
        MaxTired:8
    >>,
    {ok, pt:pack(47023, Data)};

write (47034,[
    DieTimes,
    Time,
    DieTime,
    SafeTime
]) ->
    Data = <<
        DieTimes:16,
        Time:32,
        DieTime:32,
        SafeTime:32
    >>,
    {ok, pt:pack(47034, Data)};

write (47035,[
    Errcode,
    BossType,
    BossId
]) ->
    Data = <<
        Errcode:32,
        BossType:8,
        BossId:32
    >>,
    {ok, pt:pack(47035, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    CollectTimes,
    TotalCollectTimes
}) ->
    Data = <<
        Type:8,
        CollectTimes:8,
        TotalCollectTimes:8
    >>,
    Data.
item_to_bin_1 ({
    BossId,
    Num,
    RebornTime,
    IsRemind
}) ->
    Data = <<
        BossId:32,
        Num:8,
        RebornTime:32,
        IsRemind:8
    >>,
    Data.
item_to_bin_2 ({
    Time,
    SName,
    RoleId,
    Name
}) ->
    Bin_SName = pt:write_string(SName), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        Time:32,
        Bin_SName/binary,
        RoleId:64,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_3 ({
    RoleId,
    ServerId,
    ServerNum,
    Name,
    BossId,
    Layers,
    GoodsId,
    Rating,
    EquipExtraAttr,
    Time
}) ->
    Bin_Name = pt:write_string(Name), 

    BinList_EquipExtraAttr = [
        item_to_bin_4(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        RoleId:64,
        ServerId:16,
        ServerNum:16,
        Bin_Name/binary,
        BossId:32,
        Layers:8,
        GoodsId:32,
        Rating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        Time:32
    >>,
    Data.
item_to_bin_4 ({
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
item_to_bin_5 ({
    ServerId,
    ZoneId,
    ServerNum,
    ServerName,
    Optime
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:16,
        ZoneId:8,
        ServerNum:16,
        Bin_ServerName/binary,
        Optime:32
    >>,
    Data.
item_to_bin_6 ({
    Type,
    GoodsTypeId,
    Num,
    Id
}) ->
    Data = <<
        Type:8,
        GoodsTypeId:32,
        Num:32,
        Id:64
    >>,
    Data.
item_to_bin_7 ({
    Key,
    Val
}) ->
    Data = <<
        Key:8,
        Val:32
    >>,
    Data.
item_to_bin_8 ({
    BossId,
    Xylist
}) ->
    BinList_Xylist = [
        item_to_bin_9(Xylist_Item) || Xylist_Item <- Xylist
    ], 

    Xylist_Len = length(Xylist), 
    Bin_Xylist = list_to_binary(BinList_Xylist),

    Data = <<
        BossId:32,
        Xylist_Len:16, Bin_Xylist/binary
    >>,
    Data.
item_to_bin_9 ({
    X,
    Y
}) ->
    Data = <<
        X:16,
        Y:16
    >>,
    Data.
item_to_bin_10 ({
    X,
    Y
}) ->
    Data = <<
        X:16,
        Y:16
    >>,
    Data.
item_to_bin_11 ({
    RoleId,
    RoleName,
    ServerId,
    ServerNum,
    Score,
    SortKey1,
    KillNum,
    SortKey2,
    TotalScore,
    SortKey3
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        ServerId:16,
        ServerNum:16,
        Score:32,
        SortKey1:32,
        KillNum:16,
        SortKey2:32,
        TotalScore:32,
        SortKey3:32
    >>,
    Data.
