-module(pt_471).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(47101, _) ->
    {ok, []};
read(47102, Bin0) ->
    <<BossId:32, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [BossId, Type]};
read(47103, _) ->
    {ok, []};
read(47104, _) ->
    {ok, []};
read(47105, _) ->
    {ok, []};
read(47106, Bin0) ->
    <<BossId:32, Bin1/binary>> = Bin0, 
    <<IsFollow:8, _Bin2/binary>> = Bin1, 
    {ok, [BossId, IsFollow]};
read(47108, _) ->
    {ok, []};
read(47109, _) ->
    {ok, []};
read(47110, _) ->
    {ok, []};
read(47111, _) ->
    {ok, []};
read(47114, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (47101,[
    ActStatus,
    Count,
    AssistCount,
    BuyCount,
    AddCount,
    InBuff,
    KillCount,
    IsAlive,
    SbossRoleNum,
    BossList
]) ->
    BinList_BossList = [
        item_to_bin_0(BossList_Item) || BossList_Item <- BossList
    ], 

    BossList_Len = length(BossList), 
    Bin_BossList = list_to_binary(BinList_BossList),

    Data = <<
        ActStatus:8,
        Count:8,
        AssistCount:8,
        BuyCount:8,
        AddCount:8,
        InBuff:8,
        KillCount:16,
        IsAlive:8,
        SbossRoleNum:8,
        BossList_Len:16, Bin_BossList/binary
    >>,
    {ok, pt:pack(47101, Data)};

write (47102,[
    ErrorCode,
    BossId,
    Type
]) ->
    Data = <<
        ErrorCode:32,
        BossId:32,
        Type:8
    >>,
    {ok, pt:pack(47102, Data)};

write (47103,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(47103, Data)};

write (47104,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(47104, Data)};

write (47105,[
    UnfollowList
]) ->
    BinList_UnfollowList = [
        item_to_bin_1(UnfollowList_Item) || UnfollowList_Item <- UnfollowList
    ], 

    UnfollowList_Len = length(UnfollowList), 
    Bin_UnfollowList = list_to_binary(BinList_UnfollowList),

    Data = <<
        UnfollowList_Len:16, Bin_UnfollowList/binary
    >>,
    {ok, pt:pack(47105, Data)};

write (47106,[
    ErrorCode,
    BossId,
    IsFollow
]) ->
    Data = <<
        ErrorCode:32,
        BossId:32,
        IsFollow:8
    >>,
    {ok, pt:pack(47106, Data)};

write (47107,[
    BossId
]) ->
    Data = <<
        BossId:32
    >>,
    {ok, pt:pack(47107, Data)};

write (47108,[
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
    {ok, pt:pack(47108, Data)};

write (47109,[
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_4(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(47109, Data)};

write (47110,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(47110, Data)};

write (47111,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(47111, Data)};

write (47112,[
    RoleId,
    Name,
    ServerId,
    ServerNum,
    ServerName,
    Hurt
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        ServerId:16,
        ServerNum:16,
        Bin_ServerName/binary,
        Hurt:64
    >>,
    {ok, pt:pack(47112, Data)};

write (47113,[
    IsBelong,
    IsDouble,
    RewardTypeList,
    RewardTypeList2
]) ->
    BinList_RewardTypeList = [
        item_to_bin_5(RewardTypeList_Item) || RewardTypeList_Item <- RewardTypeList
    ], 

    RewardTypeList_Len = length(RewardTypeList), 
    Bin_RewardTypeList = list_to_binary(BinList_RewardTypeList),

    BinList_RewardTypeList2 = [
        item_to_bin_7(RewardTypeList2_Item) || RewardTypeList2_Item <- RewardTypeList2
    ], 

    RewardTypeList2_Len = length(RewardTypeList2), 
    Bin_RewardTypeList2 = list_to_binary(BinList_RewardTypeList2),

    Data = <<
        IsBelong:8,
        IsDouble:8,
        RewardTypeList_Len:16, Bin_RewardTypeList/binary,
        RewardTypeList2_Len:16, Bin_RewardTypeList2/binary
    >>,
    {ok, pt:pack(47113, Data)};

write (47114,[
    EnterType,
    QuitTime,
    ReviveTime
]) ->
    Data = <<
        EnterType:8,
        QuitTime:32,
        ReviveTime:32
    >>,
    {ok, pt:pack(47114, Data)};

write (47115,[
    QuitTime
]) ->
    Data = <<
        QuitTime:32
    >>,
    {ok, pt:pack(47115, Data)};

write (47116,[
    ReviveTime
]) ->
    Data = <<
        ReviveTime:32
    >>,
    {ok, pt:pack(47116, Data)};

write (47117,[
    BossId,
    RebornTime
]) ->
    Data = <<
        BossId:32,
        RebornTime:32
    >>,
    {ok, pt:pack(47117, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BossId,
    RebornTime,
    RoleNum,
    IsHadAssist
}) ->
    Data = <<
        BossId:32,
        RebornTime:32,
        RoleNum:8,
        IsHadAssist:8
    >>,
    Data.
item_to_bin_1 (
    BossId
) ->
    Data = <<
        BossId:32
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    ServerId,
    ServerNum,
    Name,
    BossId,
    GoodsId,
    Num,
    Rating,
    EquipExtraAttr,
    Time
}) ->
    Bin_Name = pt:write_string(Name), 

    BinList_EquipExtraAttr = [
        item_to_bin_3(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        RoleId:64,
        ServerId:16,
        ServerNum:16,
        Bin_Name/binary,
        BossId:32,
        GoodsId:32,
        Num:32,
        Rating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        Time:32
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
item_to_bin_4 ({
    RoleId,
    Name,
    ServerId,
    ServerNum,
    ServerName,
    Hurt
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        ServerId:16,
        ServerNum:16,
        Bin_ServerName/binary,
        Hurt:64
    >>,
    Data.
item_to_bin_5 ({
    RewardType,
    RewardList
}) ->
    BinList_RewardList = [
        item_to_bin_6(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardType:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    Data.
item_to_bin_6 ({
    Style1,
    TypeId1,
    Count1,
    GoodsId1
}) ->
    Data = <<
        Style1:8,
        TypeId1:32,
        Count1:32,
        GoodsId1:64
    >>,
    Data.
item_to_bin_7 ({
    RewardType2,
    RewardList2
}) ->
    BinList_RewardList2 = [
        item_to_bin_8(RewardList2_Item) || RewardList2_Item <- RewardList2
    ], 

    RewardList2_Len = length(RewardList2), 
    Bin_RewardList2 = list_to_binary(BinList_RewardList2),

    Data = <<
        RewardType2:8,
        RewardList2_Len:16, Bin_RewardList2/binary
    >>,
    Data.
item_to_bin_8 ({
    Style2,
    TypeId2,
    Count2,
    GoodsId2
}) ->
    Data = <<
        Style2:8,
        TypeId2:32,
        Count2:32,
        GoodsId2:64
    >>,
    Data.
