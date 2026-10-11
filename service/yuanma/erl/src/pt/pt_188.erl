-module(pt_188).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18801, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(18802, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<BossId:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, BossId]};
read(18803, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(18804, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<DunId:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, DunId]};
read(18805, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(18806, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<BossId:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, BossId]};
read(18807, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Subtype:8, Bin2/binary>> = Bin1, 
    <<BossId:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, BossId]};
read(_Cmd, _R) -> {error, no_match}.

write (18800,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18800, Data)};

write (18801,[
    Type,
    Subtype,
    FirstBloodList
]) ->
    BinList_FirstBloodList = [
        item_to_bin_0(FirstBloodList_Item) || FirstBloodList_Item <- FirstBloodList
    ], 

    FirstBloodList_Len = length(FirstBloodList), 
    Bin_FirstBloodList = list_to_binary(BinList_FirstBloodList),

    Data = <<
        Type:8,
        Subtype:8,
        FirstBloodList_Len:16, Bin_FirstBloodList/binary
    >>,
    {ok, pt:pack(18801, Data)};

write (18802,[
    Type,
    Subtype,
    Code,
    BossId,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Type:8,
        Subtype:8,
        Code:32,
        BossId:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(18802, Data)};

write (18803,[
    Type,
    Subtype,
    FirstBloodRoleName,
    BossName
]) ->
    Bin_FirstBloodRoleName = pt:write_string(FirstBloodRoleName), 

    Bin_BossName = pt:write_string(BossName), 

    Data = <<
        Type:8,
        Subtype:8,
        Bin_FirstBloodRoleName/binary,
        Bin_BossName/binary
    >>,
    {ok, pt:pack(18803, Data)};

write (18804,[
    Type,
    Subtype,
    DunId,
    RewardState,
    PassRoleList
]) ->
    BinList_PassRoleList = [
        item_to_bin_2(PassRoleList_Item) || PassRoleList_Item <- PassRoleList
    ], 

    PassRoleList_Len = length(PassRoleList), 
    Bin_PassRoleList = list_to_binary(BinList_PassRoleList),

    Data = <<
        Type:8,
        Subtype:8,
        DunId:32,
        RewardState:8,
        PassRoleList_Len:16, Bin_PassRoleList/binary
    >>,
    {ok, pt:pack(18804, Data)};

write (18805,[
    Type,
    Subtype,
    RedPointList
]) ->
    BinList_RedPointList = [
        item_to_bin_4(RedPointList_Item) || RedPointList_Item <- RedPointList
    ], 

    RedPointList_Len = length(RedPointList), 
    Bin_RedPointList = list_to_binary(BinList_RedPointList),

    Data = <<
        Type:8,
        Subtype:8,
        RedPointList_Len:16, Bin_RedPointList/binary
    >>,
    {ok, pt:pack(18805, Data)};

write (18806,[
    Type,
    Subtype,
    BossId,
    SharedStatus
]) ->
    Data = <<
        Type:8,
        Subtype:8,
        BossId:32,
        SharedStatus:8
    >>,
    {ok, pt:pack(18806, Data)};

write (18807,[
    Type,
    Subtype,
    Code,
    BossId,
    RewardList
]) ->
    
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Type:8,
        Subtype:8,
        Code:32,
        BossId:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(18807, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ShowFirstBlood,
    BossId,
    FirstBloodRoleId,
    FirstBloodRoleName,
    RoleLv,
    RoleSex,
    RoleCarrer,
    Picture,
    PictureVer,
    DressList,
    RewardState
}) ->
    Bin_FirstBloodRoleName = pt:write_string(FirstBloodRoleName), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_DressList = [
        item_to_bin_1(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Data = <<
        ShowFirstBlood:8,
        BossId:32,
        FirstBloodRoleId:64,
        Bin_FirstBloodRoleName/binary,
        RoleLv:16,
        RoleSex:8,
        RoleCarrer:8,
        Bin_Picture/binary,
        PictureVer:32,
        DressList_Len:16, Bin_DressList/binary,
        RewardState:8
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
    Rank,
    RoleLv,
    RoleSex,
    RoleCarrer,
    Picture,
    PictureVer,
    DressList,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_DressList = [
        item_to_bin_3(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Rank:8,
        RoleLv:16,
        RoleSex:8,
        RoleCarrer:8,
        Bin_Picture/binary,
        PictureVer:32,
        DressList_Len:16, Bin_DressList/binary,
        Time:64
    >>,
    Data.
item_to_bin_3 ({
    DressType,
    DressId
}) ->
    Data = <<
        DressType:8,
        DressId:32
    >>,
    Data.
item_to_bin_4 ({
    DunId,
    ShowPoint
}) ->
    Data = <<
        DunId:32,
        ShowPoint:8
    >>,
    Data.
