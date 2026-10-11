-module(pt_140).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14000, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(14001, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(14002, Bin0) ->
    {RoleName, _Bin1} = pt:read_string(Bin0), 
    {ok, [RoleName]};
read(14003, Bin0) ->
    <<BeAskId:64, _Bin1/binary>> = Bin0, 
    {ok, [BeAskId]};
read(14004, Bin0) ->
    <<ResponseType:8, _Bin1/binary>> = Bin0, 
    {ok, [ResponseType]};
read(14005, Bin0) ->
    <<AskId:64, Bin1/binary>> = Bin0, 
    <<ResponseType:8, _Bin2/binary>> = Bin1, 
    {ok, [AskId, ResponseType]};
read(14006, _) ->
    {ok, []};
read(14007, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<RoleId:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, RoleId]};
read(14010, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(14011, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(14016, _) ->
    {ok, []};
read(14017, _) ->
    {ok, []};
read(14099, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (14000,[
    Type,
    RelaList
]) ->
    BinList_RelaList = [
        item_to_bin_0(RelaList_Item) || RelaList_Item <- RelaList
    ], 

    RelaList_Len = length(RelaList), 
    Bin_RelaList = list_to_binary(BinList_RelaList),

    Data = <<
        Type:8,
        RelaList_Len:16, Bin_RelaList/binary
    >>,
    {ok, pt:pack(14000, Data)};

write (14001,[
    Code,
    RecommendedList
]) ->
    BinList_RecommendedList = [
        item_to_bin_2(RecommendedList_Item) || RecommendedList_Item <- RecommendedList
    ], 

    RecommendedList_Len = length(RecommendedList), 
    Bin_RecommendedList = list_to_binary(BinList_RecommendedList),

    Data = <<
        Code:32,
        RecommendedList_Len:16, Bin_RecommendedList/binary
    >>,
    {ok, pt:pack(14001, Data)};

write (14002,[
    Code,
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Lv,
    Vip,
    VipHide,
    Picture,
    PictureVer,
    CombatPower,
    OnlineFlag
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        Code:32,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Lv:16,
        Vip:8,
        VipHide:8,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        OnlineFlag:8
    >>,
    {ok, pt:pack(14002, Data)};

write (14003,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(14003, Data)};

write (14004,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(14004, Data)};

write (14005,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(14005, Data)};

write (14006,[
    AskList
]) ->
    BinList_AskList = [
        item_to_bin_3(AskList_Item) || AskList_Item <- AskList
    ], 

    AskList_Len = length(AskList), 
    Bin_AskList = list_to_binary(BinList_AskList),

    Data = <<
        AskList_Len:16, Bin_AskList/binary
    >>,
    {ok, pt:pack(14006, Data)};

write (14007,[
    Type,
    Code
]) ->
    Data = <<
        Type:8,
        Code:32
    >>,
    {ok, pt:pack(14007, Data)};

write (14008,[
    RoleId,
    RoleName,
    Career,
    Turn,
    Lv,
    Picture,
    PictureVer,
    CombatPower,
    AddTime
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Turn:8,
        Lv:16,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        AddTime:32
    >>,
    {ok, pt:pack(14008, Data)};

write (14009,[
    RoleId,
    RoleName,
    RelaType,
    OnlineFlag,
    Timestamp
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        RelaType:8,
        OnlineFlag:8,
        Timestamp:32
    >>,
    {ok, pt:pack(14009, Data)};

write (14010,[
    Code,
    RoleId,
    Figure,
    Rela,
    TeamId
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Code:32,
        RoleId:64,
        Bin_Figure/binary,
        Rela:8,
        TeamId:32
    >>,
    {ok, pt:pack(14010, Data)};

write (14011,[
    RoleId,
    Rela
]) ->
    Data = <<
        RoleId:64,
        Rela:8
    >>,
    {ok, pt:pack(14011, Data)};

write (14013,[
    UpdateList
]) ->
    BinList_UpdateList = [
        item_to_bin_4(UpdateList_Item) || UpdateList_Item <- UpdateList
    ], 

    UpdateList_Len = length(UpdateList), 
    Bin_UpdateList = list_to_binary(BinList_UpdateList),

    Data = <<
        UpdateList_Len:16, Bin_UpdateList/binary
    >>,
    {ok, pt:pack(14013, Data)};

write (14014,[
    UpdateList
]) ->
    BinList_UpdateList = [
        item_to_bin_7(UpdateList_Item) || UpdateList_Item <- UpdateList
    ], 

    UpdateList_Len = length(UpdateList), 
    Bin_UpdateList = list_to_binary(BinList_UpdateList),

    Data = <<
        UpdateList_Len:16, Bin_UpdateList/binary
    >>,
    {ok, pt:pack(14014, Data)};

write (14015,[
    RoleId,
    Intimacy
]) ->
    Data = <<
        RoleId:64,
        Intimacy:32
    >>,
    {ok, pt:pack(14015, Data)};

write (14016,[
    EnermyList
]) ->
    BinList_EnermyList = [
        item_to_bin_9(EnermyList_Item) || EnermyList_Item <- EnermyList
    ], 

    EnermyList_Len = length(EnermyList), 
    Bin_EnermyList = list_to_binary(BinList_EnermyList),

    Data = <<
        EnermyList_Len:16, Bin_EnermyList/binary
    >>,
    {ok, pt:pack(14016, Data)};

write (14017,[
    BeKilledList
]) ->
    BinList_BeKilledList = [
        item_to_bin_10(BeKilledList_Item) || BeKilledList_Item <- BeKilledList
    ], 

    BeKilledList_Len = length(BeKilledList), 
    Bin_BeKilledList = list_to_binary(BinList_BeKilledList),

    Data = <<
        BeKilledList_Len:16, Bin_BeKilledList/binary
    >>,
    {ok, pt:pack(14017, Data)};

write (14099,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(14099, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Lv,
    Vip,
    VipHide,
    Picture,
    PictureVer,
    CombatPower,
    OnlineFlag,
    Intimacy,
    MarriageType,
    BlockId,
    HouseId,
    HouseLv,
    IsSupvip,
    LastChatTime,
    OfflineTime,
    AddTime,
    DressList
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_DressList = [
        item_to_bin_1(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Lv:16,
        Vip:8,
        VipHide:8,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        OnlineFlag:8,
        Intimacy:32,
        MarriageType:8,
        BlockId:32,
        HouseId:32,
        HouseLv:16,
        IsSupvip:8,
        LastChatTime:32,
        OfflineTime:32,
        AddTime:32,
        DressList_Len:16, Bin_DressList/binary
    >>,
    Data.
item_to_bin_1 ({
    DressType,
    DressId
}) ->
    Data = <<
        DressType:8,
        DressId:32
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Lv,
    Vip,
    VipHide,
    Picture,
    PictureVer,
    CombatPower,
    OnlineFlag,
    IsSupvip
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Lv:16,
        Vip:8,
        VipHide:8,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        OnlineFlag:8,
        IsSupvip:8
    >>,
    Data.
item_to_bin_3 ({
    RoleId,
    RoleName,
    Career,
    Turn,
    Lv,
    Picture,
    PictureVer,
    CombatPower,
    AddTime
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Turn:8,
        Lv:16,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        AddTime:32
    >>,
    Data.
item_to_bin_4 ({
    Type,
    RoleList
}) ->
    BinList_RoleList = [
        item_to_bin_5(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        Type:8,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    Data.
item_to_bin_5 ({
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Lv,
    VipHide,
    Vip,
    Picture,
    PictureVer,
    CombatPower,
    OnlineFlag,
    Intimacy,
    MarriageType,
    BlockId,
    HouseId,
    HouseLv,
    IsSupvip,
    LastChatTime,
    OfflineTime,
    AddTime,
    DressList
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_DressList = [
        item_to_bin_6(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Lv:16,
        VipHide:8,
        Vip:8,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        OnlineFlag:8,
        Intimacy:32,
        MarriageType:8,
        BlockId:32,
        HouseId:32,
        HouseLv:16,
        IsSupvip:8,
        LastChatTime:32,
        OfflineTime:32,
        AddTime:32,
        DressList_Len:16, Bin_DressList/binary
    >>,
    Data.
item_to_bin_6 ({
    DressType,
    DressId
}) ->
    Data = <<
        DressType:8,
        DressId:32
    >>,
    Data.
item_to_bin_7 ({
    Type,
    RoleIds
}) ->
    BinList_RoleIds = [
        item_to_bin_8(RoleIds_Item) || RoleIds_Item <- RoleIds
    ], 

    RoleIds_Len = length(RoleIds), 
    Bin_RoleIds = list_to_binary(BinList_RoleIds),

    Data = <<
        Type:8,
        RoleIds_Len:16, Bin_RoleIds/binary
    >>,
    Data.
item_to_bin_8 (
    RoleId
) ->
    Data = <<
        RoleId:64
    >>,
    Data.
item_to_bin_9 ({
    EnermyRoleId,
    EnermyRoleName,
    BeKilledCount
}) ->
    Bin_EnermyRoleName = pt:write_string(EnermyRoleName), 

    Data = <<
        EnermyRoleId:64,
        Bin_EnermyRoleName/binary,
        BeKilledCount:16
    >>,
    Data.
item_to_bin_10 ({
    Time,
    SceneName,
    ServerId,
    ServerNum,
    AttrName,
    AttrId
}) ->
    Bin_SceneName = pt:write_string(SceneName), 

    Bin_AttrName = pt:write_string(AttrName), 

    Data = <<
        Time:32,
        Bin_SceneName/binary,
        ServerId:32,
        ServerNum:32,
        Bin_AttrName/binary,
        AttrId:64
    >>,
    Data.
