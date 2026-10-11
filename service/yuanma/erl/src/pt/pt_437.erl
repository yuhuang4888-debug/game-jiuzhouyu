-module(pt_437).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(43701, _) ->
    {ok, []};
read(43702, _) ->
    {ok, []};
read(43703, _) ->
    {ok, []};
read(43704, _) ->
    {ok, []};
read(43705, _) ->
    {ok, []};
read(43706, _) ->
    {ok, []};
read(43707, _) ->
    {ok, []};
read(43708, _) ->
    {ok, []};
read(43709, Bin0) ->
    <<GuildId:64, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [GuildId, Type]};
read(43710, _) ->
    {ok, []};
read(43711, Bin0) ->
    <<Id:8, Bin1/binary>> = Bin0, 
    <<Num:16, Bin2/binary>> = Bin1, 
    <<Type:8, _Bin3/binary>> = Bin2, 
    {ok, [Id, Num, Type]};
read(43712, _) ->
    {ok, []};
read(43713, _) ->
    {ok, []};
read(43714, _) ->
    {ok, []};
read(43715, _) ->
    {ok, []};
read(43716, Bin0) ->
    <<Id:8, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(43717, _) ->
    {ok, []};
read(43718, Bin0) ->
    <<Id:8, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(43719, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(43720, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(43726, Bin0) ->
    <<IslandId:8, _Bin1/binary>> = Bin0, 
    {ok, [IslandId]};
read(43727, Bin0) ->
    <<IslandId:8, _Bin1/binary>> = Bin0, 
    {ok, [IslandId]};
read(43728, Bin0) ->
    <<IslandId:8, Bin1/binary>> = Bin0, 
    <<Bid:32, _Bin2/binary>> = Bin1, 
    {ok, [IslandId, Bid]};
read(43729, Bin0) ->
    <<IslandId:8, _Bin1/binary>> = Bin0, 
    {ok, [IslandId]};
read(43731, _) ->
    {ok, []};
read(43733, Bin0) ->
    <<X:16, Bin1/binary>> = Bin0, 
    <<Y:16, _Bin2/binary>> = Bin1, 
    {ok, [X, Y]};
read(43734, Bin0) ->
    <<X:16, Bin1/binary>> = Bin0, 
    <<Y:16, _Bin2/binary>> = Bin1, 
    {ok, [X, Y]};
read(_Cmd, _R) -> {error, no_match}.

write (43700,[
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(43700, Data)};

write (43701,[
    Stage,
    Round,
    GameType,
    Etime
]) ->
    Data = <<
        Stage:8,
        Round:8,
        GameType:8,
        Etime:32
    >>,
    {ok, pt:pack(43701, Data)};

write (43702,[
    IslandIds
]) ->
    BinList_IslandIds = [
        item_to_bin_0(IslandIds_Item) || IslandIds_Item <- IslandIds
    ], 

    IslandIds_Len = length(IslandIds), 
    Bin_IslandIds = list_to_binary(BinList_IslandIds),

    Data = <<
        IslandIds_Len:16, Bin_IslandIds/binary
    >>,
    {ok, pt:pack(43702, Data)};

write (43703,[
    RewardStatus,
    EntitledIslandId,
    IslandList
]) ->
    BinList_IslandList = [
        item_to_bin_1(IslandList_Item) || IslandList_Item <- IslandList
    ], 

    IslandList_Len = length(IslandList), 
    Bin_IslandList = list_to_binary(BinList_IslandList),

    Data = <<
        RewardStatus:8,
        EntitledIslandId:8,
        IslandList_Len:16, Bin_IslandList/binary
    >>,
    {ok, pt:pack(43703, Data)};

write (43704,[
    RewardStatus,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_2(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardStatus:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(43704, Data)};

write (43705,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(43705, Data)};

write (43706,[
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(43706, Data)};

write (43707,[
    ServerName,
    GuildId,
    GuildName,
    OccupationDays
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Bin_ServerName/binary,
        GuildId:64,
        Bin_GuildName/binary,
        OccupationDays:16
    >>,
    {ok, pt:pack(43707, Data)};

write (43708,[
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_4(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(43708, Data)};

write (43709,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(43709, Data)};

write (43710,[
    Resources,
    List
]) ->
    BinList_List = [
        item_to_bin_6(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Resources:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(43710, Data)};

write (43711,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(43711, Data)};

write (43712,[
    GroupId,
    Score,
    StageReward
]) ->
    BinList_StageReward = [
        item_to_bin_7(StageReward_Item) || StageReward_Item <- StageReward
    ], 

    StageReward_Len = length(StageReward), 
    Bin_StageReward = list_to_binary(BinList_StageReward),

    Data = <<
        GroupId:8,
        Score:32,
        StageReward_Len:16, Bin_StageReward/binary
    >>,
    {ok, pt:pack(43712, Data)};

write (43713,[
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_8(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(43713, Data)};

write (43714,[
    BuildingList
]) ->
    BinList_BuildingList = [
        item_to_bin_9(BuildingList_Item) || BuildingList_Item <- BuildingList
    ], 

    BuildingList_Len = length(BuildingList), 
    Bin_BuildingList = list_to_binary(BinList_BuildingList),

    Data = <<
        BuildingList_Len:16, Bin_BuildingList/binary
    >>,
    {ok, pt:pack(43714, Data)};

write (43715,[
    Score,
    ShipIds
]) ->
    BinList_ShipIds = [
        item_to_bin_10(ShipIds_Item) || ShipIds_Item <- ShipIds
    ], 

    ShipIds_Len = length(ShipIds), 
    Bin_ShipIds = list_to_binary(BinList_ShipIds),

    Data = <<
        Score:32,
        ShipIds_Len:16, Bin_ShipIds/binary
    >>,
    {ok, pt:pack(43715, Data)};

write (43716,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:8,
        Id:8
    >>,
    {ok, pt:pack(43716, Data)};

write (43717,[
    List
]) ->
    BinList_List = [
        item_to_bin_11(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(43717, Data)};

write (43718,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(43718, Data)};

write (43719,[
    Errcode,
    Type
]) ->
    Data = <<
        Errcode:8,
        Type:8
    >>,
    {ok, pt:pack(43719, Data)};

write (43720,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(43720, Data)};

write (43721,[
    OwnershipId,
    WinnerSid,
    WinnerId,
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_12(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        OwnershipId:64,
        WinnerSid:16,
        WinnerId:64,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(43721, Data)};

write (43722,[
    List
]) ->
    BinList_List = [
        item_to_bin_13(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(43722, Data)};

write (43723,[
    Id,
    Hp
]) ->
    Data = <<
        Id:8,
        Hp:32
    >>,
    {ok, pt:pack(43723, Data)};

write (43724,[
    Id,
    Group,
    GuildId,
    GuildName,
    Hp
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Id:8,
        Group:8,
        GuildId:64,
        Bin_GuildName/binary,
        Hp:32
    >>,
    {ok, pt:pack(43724, Data)};

write (43725,[
    Score
]) ->
    Data = <<
        Score:32
    >>,
    {ok, pt:pack(43725, Data)};

write (43726,[
    IslandId,
    GuildId,
    GuildName,
    Stage,
    IsBid,
    AppointList
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_AppointList = [
        item_to_bin_14(AppointList_Item) || AppointList_Item <- AppointList
    ], 

    AppointList_Len = length(AppointList), 
    Bin_AppointList = list_to_binary(BinList_AppointList),

    Data = <<
        IslandId:8,
        GuildId:64,
        Bin_GuildName/binary,
        Stage:8,
        IsBid:8,
        AppointList_Len:16, Bin_AppointList/binary
    >>,
    {ok, pt:pack(43726, Data)};

write (43727,[
    MinBid,
    Gfunds
]) ->
    Data = <<
        MinBid:32,
        Gfunds:32
    >>,
    {ok, pt:pack(43727, Data)};

write (43728,[
    Errcode,
    IslandId
]) ->
    Data = <<
        Errcode:8,
        IslandId:8
    >>,
    {ok, pt:pack(43728, Data)};

write (43729,[
    Errcode,
    IslandId
]) ->
    Data = <<
        Errcode:8,
        IslandId:8
    >>,
    {ok, pt:pack(43729, Data)};

write (43730,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_15(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(43730, Data)};

write (43731,[
    Etime,
    ForbidPlEtime
]) ->
    Data = <<
        Etime:32,
        ForbidPlEtime:32
    >>,
    {ok, pt:pack(43731, Data)};

write (43732,[
    X,
    Y
]) ->
    Data = <<
        X:16,
        Y:16
    >>,
    {ok, pt:pack(43732, Data)};

write (43733,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(43733, Data)};



write (43735,[
    Type
]) ->
    Data = <<
        Type:8
    >>,
    {ok, pt:pack(43735, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    IslandId
) ->
    Data = <<
        IslandId:8
    >>,
    Data.
item_to_bin_1 ({
    IslandId,
    ServerName,
    GuildId,
    GuildName
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        IslandId:8,
        Bin_ServerName/binary,
        GuildId:64,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_2 ({
    SeasType,
    SeasSubtype,
    IslandId,
    ServerName,
    GuildName
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        SeasType:8,
        SeasSubtype:8,
        IslandId:8,
        Bin_ServerName/binary,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_3 ({
    Ranking,
    ServerName,
    GuildId,
    GuildName,
    Score,
    Reward
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Ranking:16,
        Bin_ServerName/binary,
        GuildId:64,
        Bin_GuildName/binary,
        Score:32,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_4 ({
    GuildId,
    GuildName,
    Ranking,
    IslandId,
    Resources,
    Funds,
    DonateStatus
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_DonateStatus = [
        item_to_bin_5(DonateStatus_Item) || DonateStatus_Item <- DonateStatus
    ], 

    DonateStatus_Len = length(DonateStatus), 
    Bin_DonateStatus = list_to_binary(BinList_DonateStatus),

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        Ranking:8,
        IslandId:8,
        Resources:32,
        Funds:32,
        DonateStatus_Len:16, Bin_DonateStatus/binary
    >>,
    Data.
item_to_bin_5 ({
    Type,
    RemainTimes
}) ->
    Data = <<
        Type:8,
        RemainTimes:8
    >>,
    Data.
item_to_bin_6 ({
    Id,
    Num
}) ->
    Data = <<
        Id:8,
        Num:16
    >>,
    Data.
item_to_bin_7 ({
    KeyId,
    State
}) ->
    Data = <<
        KeyId:8,
        State:8
    >>,
    Data.
item_to_bin_8 ({
    GroupId,
    GuildName,
    Score,
    Utime
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        GroupId:8,
        Bin_GuildName/binary,
        Score:32,
        Utime:32
    >>,
    Data.
item_to_bin_9 ({
    MonId,
    Group,
    GuildId,
    GuildName,
    Hp
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        MonId:8,
        Group:8,
        GuildId:64,
        Bin_GuildName/binary,
        Hp:32
    >>,
    Data.
item_to_bin_10 (
    ShipId
) ->
    Data = <<
        ShipId:8
    >>,
    Data.
item_to_bin_11 ({
    Id,
    Num,
    UseNum
}) ->
    Data = <<
        Id:8,
        Num:16,
        UseNum:16
    >>,
    Data.
item_to_bin_12 ({
    Ranking,
    GuildId,
    GuildName,
    Score,
    ScorePlus,
    Reward
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Ranking:8,
        GuildId:64,
        Bin_GuildName/binary,
        Score:32,
        ScorePlus:32,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_13 ({
    Ranking,
    ServerId,
    RoleId,
    RoleName,
    KillNum,
    Combo,
    Reward
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Ranking:8,
        ServerId:16,
        RoleId:64,
        Bin_RoleName/binary,
        KillNum:16,
        Combo:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_14 ({
    ServerName,
    GuildName,
    Bid,
    Time
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Bin_ServerName/binary,
        Bin_GuildName/binary,
        Bid:32,
        Time:32
    >>,
    Data.
item_to_bin_15 ({
    Pos,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Pos:8,
        Bin_Figure/binary
    >>,
    Data.
