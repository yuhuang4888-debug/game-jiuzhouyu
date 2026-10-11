-module(pt_506).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(50600, _) ->
    {ok, []};
read(50601, _) ->
    {ok, []};
read(50602, _) ->
    {ok, []};
read(50603, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(50604, _) ->
    {ok, []};
read(50605, _) ->
    {ok, []};
read(50606, _) ->
    {ok, []};
read(50607, _) ->
    {ok, []};
read(50612, _) ->
    {ok, []};
read(50613, _) ->
    {ok, []};
read(50617, Bin0) ->
    <<MonId:32, _Bin1/binary>> = Bin0, 
    {ok, [MonId]};
read(50618, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(50620, _) ->
    {ok, []};
read(50621, _) ->
    {ok, []};
read(50622, _) ->
    {ok, []};
read(50623, Bin0) ->
    <<TerritoryId:32, _Bin1/binary>> = Bin0, 
    {ok, [TerritoryId]};
read(50624, _) ->
    {ok, []};
read(50625, _) ->
    {ok, []};
read(50626, _) ->
    {ok, []};
read(50627, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (50600,[
    WarState,
    ReadyTime,
    StartTime,
    EndTime
]) ->
    Data = <<
        WarState:8,
        ReadyTime:32,
        StartTime:32,
        EndTime:32
    >>,
    {ok, pt:pack(50600, Data)};

write (50601,[
    Type,
    Winner,
    ServerId,
    WinNum,
    RewardType,
    RewardKey,
    RewardOwner
]) ->
    Data = <<
        Type:8,
        Winner:64,
        ServerId:16,
        WinNum:16,
        RewardType:8,
        RewardKey:16,
        RewardOwner:64
    >>,
    {ok, pt:pack(50601, Data)};

write (50602,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(50602, Data)};

write (50603,[
    ErrorCode,
    Type
]) ->
    Data = <<
        ErrorCode:32,
        Type:8
    >>,
    {ok, pt:pack(50603, Data)};

write (50604,[
    TerritoryId,
    EndTime,
    RoleScore,
    GuildList,
    StageList,
    OwnList
]) ->
    BinList_GuildList = [
        item_to_bin_0(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    BinList_StageList = [
        item_to_bin_2(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    BinList_OwnList = [
        item_to_bin_3(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        TerritoryId:32,
        EndTime:32,
        RoleScore:32,
        GuildList_Len:16, Bin_GuildList/binary,
        StageList_Len:16, Bin_StageList/binary,
        OwnList_Len:16, Bin_OwnList/binary
    >>,
    {ok, pt:pack(50604, Data)};

write (50605,[
    RoleScore,
    AddStageList
]) ->
    BinList_AddStageList = [
        item_to_bin_4(AddStageList_Item) || AddStageList_Item <- AddStageList
    ], 

    AddStageList_Len = length(AddStageList), 
    Bin_AddStageList = list_to_binary(BinList_AddStageList),

    Data = <<
        RoleScore:32,
        AddStageList_Len:16, Bin_AddStageList/binary
    >>,
    {ok, pt:pack(50605, Data)};

write (50606,[
    GuildUpdateList
]) ->
    BinList_GuildUpdateList = [
        item_to_bin_5(GuildUpdateList_Item) || GuildUpdateList_Item <- GuildUpdateList
    ], 

    GuildUpdateList_Len = length(GuildUpdateList), 
    Bin_GuildUpdateList = list_to_binary(BinList_GuildUpdateList),

    Data = <<
        GuildUpdateList_Len:16, Bin_GuildUpdateList/binary
    >>,
    {ok, pt:pack(50606, Data)};

write (50607,[
    OwnUpdateList
]) ->
    BinList_OwnUpdateList = [
        item_to_bin_7(OwnUpdateList_Item) || OwnUpdateList_Item <- OwnUpdateList
    ], 

    OwnUpdateList_Len = length(OwnUpdateList), 
    Bin_OwnUpdateList = list_to_binary(BinList_OwnUpdateList),

    Data = <<
        OwnUpdateList_Len:16, Bin_OwnUpdateList/binary
    >>,
    {ok, pt:pack(50607, Data)};

write (50611,[
    TerritoryId,
    ModeNum,
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_8(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        TerritoryId:32,
        ModeNum:8,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(50611, Data)};

write (50612,[
    RoleScore
]) ->
    Data = <<
        RoleScore:32
    >>,
    {ok, pt:pack(50612, Data)};

write (50613,[
    MonId,
    GuildId
]) ->
    Data = <<
        MonId:32,
        GuildId:64
    >>,
    {ok, pt:pack(50613, Data)};

write (50617,[
    MonId
]) ->
    Data = <<
        MonId:32
    >>,
    {ok, pt:pack(50617, Data)};

write (50618,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(50618, Data)};

write (50619,[
    AtterServerId,
    RoleId,
    RoleName,
    Sex,
    Realm,
    Career,
    Turn,
    Lv,
    Picture,
    PictureVer,
    CkillNum
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        AtterServerId:16,
        RoleId:64,
        Bin_RoleName/binary,
        Sex:8,
        Realm:8,
        Career:8,
        Turn:8,
        Lv:16,
        Bin_Picture/binary,
        PictureVer:32,
        CkillNum:32
    >>,
    {ok, pt:pack(50619, Data)};

write (50620,[
    Round,
    RoundStartTime,
    RoundEndTime
]) ->
    Data = <<
        Round:8,
        RoundStartTime:32,
        RoundEndTime:32
    >>,
    {ok, pt:pack(50620, Data)};

write (50621,[
    WarList
]) ->
    BinList_WarList = [
        item_to_bin_10(WarList_Item) || WarList_Item <- WarList
    ], 

    WarList_Len = length(WarList), 
    Bin_WarList = list_to_binary(BinList_WarList),

    Data = <<
        WarList_Len:16, Bin_WarList/binary
    >>,
    {ok, pt:pack(50621, Data)};

write (50622,[
    ModeNum,
    AvgWlv,
    ServerList
]) ->
    BinList_ServerList = [
        item_to_bin_11(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        ModeNum:8,
        AvgWlv:16,
        ServerList_Len:16, Bin_ServerList/binary
    >>,
    {ok, pt:pack(50622, Data)};

write (50623,[
    Code,
    TerritoryId
]) ->
    Data = <<
        Code:32,
        TerritoryId:32
    >>,
    {ok, pt:pack(50623, Data)};

write (50624,[
    Qualification,
    IsChooseTerriId
]) ->
    Data = <<
        Qualification:8,
        IsChooseTerriId:8
    >>,
    {ok, pt:pack(50624, Data)};

write (50625,[
    Qualification
]) ->
    Data = <<
        Qualification:8
    >>,
    {ok, pt:pack(50625, Data)};

write (50626,[
    UpWarList
]) ->
    Data = <<
        UpWarList:8
    >>,
    {ok, pt:pack(50626, Data)};

write (50627,[
    TerritoryId
]) ->
    Data = <<
        TerritoryId:32
    >>,
    {ok, pt:pack(50627, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GuildId,
    GuildName,
    ServerId,
    ServerNum,
    Score,
    OwnList
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_OwnList = [
        item_to_bin_1(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        ServerId:16,
        ServerNum:16,
        Score:32,
        OwnList_Len:16, Bin_OwnList/binary
    >>,
    Data.
item_to_bin_1 (
    ModId
) ->
    Data = <<
        ModId:32
    >>,
    Data.
item_to_bin_2 (
    Keyid
) ->
    Data = <<
        Keyid:8
    >>,
    Data.
item_to_bin_3 ({
    Type,
    GuildId,
    GuildName,
    MonId,
    Hp,
    HpLim
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Type:8,
        GuildId:64,
        Bin_GuildName/binary,
        MonId:32,
        Hp:32,
        HpLim:32
    >>,
    Data.
item_to_bin_4 (
    Keyid
) ->
    Data = <<
        Keyid:8
    >>,
    Data.
item_to_bin_5 ({
    GuildId,
    Score,
    OwnList
}) ->
    BinList_OwnList = [
        item_to_bin_6(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        GuildId:64,
        Score:32,
        OwnList_Len:16, Bin_OwnList/binary
    >>,
    Data.
item_to_bin_6 (
    ModId
) ->
    Data = <<
        ModId:32
    >>,
    Data.
item_to_bin_7 ({
    Type,
    GuildId,
    GuildName,
    MonId,
    Hp,
    HpLim
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Type:8,
        GuildId:64,
        Bin_GuildName/binary,
        MonId:32,
        Hp:32,
        HpLim:32
    >>,
    Data.
item_to_bin_8 ({
    GuildId,
    IsWin,
    GuildName,
    ServerId,
    ServerNum,
    Score,
    OwnList
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_OwnList = [
        item_to_bin_9(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        GuildId:64,
        IsWin:8,
        Bin_GuildName/binary,
        ServerId:16,
        ServerNum:16,
        Score:32,
        OwnList_Len:16, Bin_OwnList/binary
    >>,
    Data.
item_to_bin_9 (
    ModId
) ->
    Data = <<
        ModId:32
    >>,
    Data.
item_to_bin_10 ({
    TerritoryId,
    AGuild,
    AGuildName,
    AServerId,
    AServerNum,
    BGuild,
    BGuildName,
    BServerId,
    BServerNum,
    Winner
}) ->
    Bin_AGuildName = pt:write_string(AGuildName), 

    Bin_BGuildName = pt:write_string(BGuildName), 

    Data = <<
        TerritoryId:32,
        AGuild:64,
        Bin_AGuildName/binary,
        AServerId:16,
        AServerNum:16,
        BGuild:64,
        Bin_BGuildName/binary,
        BServerId:16,
        BServerNum:16,
        Winner:64
    >>,
    Data.
item_to_bin_11 ({
    ServerId,
    ServerNum,
    ServerName,
    Wlv
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:16,
        ServerNum:16,
        Bin_ServerName/binary,
        Wlv:16
    >>,
    Data.
