-module(pt_505).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(50500, _) ->
    {ok, []};
read(50501, _) ->
    {ok, []};
read(50502, _) ->
    {ok, []};
read(50503, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(50504, _) ->
    {ok, []};
read(50505, _) ->
    {ok, []};
read(50506, _) ->
    {ok, []};
read(50507, _) ->
    {ok, []};
read(50508, Bin0) ->
    <<MonId:32, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [MonId, Type]};
read(50509, Bin0) ->
    <<Keyid:8, _Bin1/binary>> = Bin0, 
    {ok, [Keyid]};
read(50512, _) ->
    {ok, []};
read(50513, _) ->
    {ok, []};
read(50514, _) ->
    {ok, []};
read(50516, _) ->
    {ok, []};
read(50517, Bin0) ->
    <<MonId:32, _Bin1/binary>> = Bin0, 
    {ok, [MonId]};
read(50518, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(50520, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (50500,[
    RedHot
]) ->
    BinList_RedHot = [
        item_to_bin_0(RedHot_Item) || RedHot_Item <- RedHot
    ], 

    RedHot_Len = length(RedHot), 
    Bin_RedHot = list_to_binary(BinList_RedHot),

    Data = <<
        RedHot_Len:16, Bin_RedHot/binary
    >>,
    {ok, pt:pack(50500, Data)};

write (50501,[
    Type,
    Winner,
    ChiefId,
    ChiefFigure,
    WinNum,
    RewardType,
    RewardKey,
    RewardOwner
]) ->
    Bin_ChiefFigure = pt:write_figure(ChiefFigure), 

    Data = <<
        Type:8,
        Winner:64,
        ChiefId:64,
        Bin_ChiefFigure/binary,
        WinNum:16,
        RewardType:8,
        RewardKey:16,
        RewardOwner:64
    >>,
    {ok, pt:pack(50501, Data)};

write (50502,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(50502, Data)};

write (50503,[
    ErrorCode,
    Type
]) ->
    Data = <<
        ErrorCode:32,
        Type:8
    >>,
    {ok, pt:pack(50503, Data)};

write (50504,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(50504, Data)};

write (50505,[
    StageList
]) ->
    BinList_StageList = [
        item_to_bin_1(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        StageList_Len:16, Bin_StageList/binary
    >>,
    {ok, pt:pack(50505, Data)};

write (50506,[
    MyGuild,
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_2(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        MyGuild:64,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(50506, Data)};

write (50507,[
    OwnList
]) ->
    BinList_OwnList = [
        item_to_bin_4(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        OwnList_Len:16, Bin_OwnList/binary
    >>,
    {ok, pt:pack(50507, Data)};

write (50508,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(50508, Data)};

write (50509,[
    ErrorCode,
    Keyid
]) ->
    Data = <<
        ErrorCode:32,
        Keyid:8
    >>,
    {ok, pt:pack(50509, Data)};

write (50511,[
    MyGuild,
    MyScore,
    MyRank,
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_5(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        MyGuild:64,
        MyScore:32,
        MyRank:32,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(50511, Data)};

write (50512,[
    Score,
    Resource
]) ->
    Data = <<
        Score:16,
        Resource:16
    >>,
    {ok, pt:pack(50512, Data)};

write (50513,[
    MonId,
    GuildId
]) ->
    Data = <<
        MonId:32,
        GuildId:64
    >>,
    {ok, pt:pack(50513, Data)};

write (50514,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_7(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(50514, Data)};

write (50516,[
    MyGuild,
    Rank,
    Score
]) ->
    Data = <<
        MyGuild:64,
        Rank:32,
        Score:32
    >>,
    {ok, pt:pack(50516, Data)};

write (50517,[
    MonId
]) ->
    Data = <<
        MonId:32
    >>,
    {ok, pt:pack(50517, Data)};

write (50518,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(50518, Data)};

write (50519,[
    RoleId,
    RoleName,
    Sex,
    Realm,
    Career,
    Lv,
    Picture,
    PictureVer,
    CkillNum
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Sex:8,
        Realm:8,
        Career:8,
        Lv:16,
        Bin_Picture/binary,
        PictureVer:32,
        CkillNum:32
    >>,
    {ok, pt:pack(50519, Data)};

write (50520,[
    WarState
]) ->
    Data = <<
        WarState:8
    >>,
    {ok, pt:pack(50520, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Key,
    IsShow
}) ->
    Data = <<
        Key:8,
        IsShow:8
    >>,
    Data.
item_to_bin_1 ({
    Keyid,
    Needscore,
    State
}) ->
    Data = <<
        Keyid:8,
        Needscore:16,
        State:8
    >>,
    Data.
item_to_bin_2 ({
    GuildId,
    Rank,
    GuildName,
    Score,
    SecSortKey,
    OwnList
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_OwnList = [
        item_to_bin_3(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        GuildId:64,
        Rank:32,
        Bin_GuildName/binary,
        Score:32,
        SecSortKey:8,
        OwnList_Len:16, Bin_OwnList/binary
    >>,
    Data.
item_to_bin_3 (
    ModId
) ->
    Data = <<
        ModId:32
    >>,
    Data.
item_to_bin_4 ({
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
item_to_bin_5 ({
    GuildId,
    Rank,
    GuildName,
    Score,
    SecSortKey,
    OwnList
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_OwnList = [
        item_to_bin_6(OwnList_Item) || OwnList_Item <- OwnList
    ], 

    OwnList_Len = length(OwnList), 
    Bin_OwnList = list_to_binary(BinList_OwnList),

    Data = <<
        GuildId:64,
        Rank:32,
        Bin_GuildName/binary,
        Score:32,
        SecSortKey:8,
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
    RoleId,
    RoleName,
    GuildId,
    GuildName,
    Score,
    KillNum,
    Rank
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        GuildId:64,
        Bin_GuildName/binary,
        Score:32,
        KillNum:32,
        Rank:16
    >>,
    Data.
