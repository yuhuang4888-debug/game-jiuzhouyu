-module(pt_189).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18900, _) ->
    {ok, []};
read(18901, _) ->
    {ok, []};
read(18902, _) ->
    {ok, []};
read(18903, _) ->
    {ok, []};
read(18904, Bin0) ->
    <<AutoId:64, _Bin1/binary>> = Bin0, 
    {ok, [AutoId]};
read(18905, Bin0) ->
    <<AutoId:64, Bin1/binary>> = Bin0, 
    <<ServerId:32, Bin2/binary>> = Bin1, 
    <<RoleId:64, Bin3/binary>> = Bin2, 
    <<Type:8, _Bin4/binary>> = Bin3, 
    {ok, [AutoId, ServerId, RoleId, Type]};
read(18909, Bin0) ->
    <<AutoId:64, Bin1/binary>> = Bin0, 
    <<RewardType:8, _Bin2/binary>> = Bin1, 
    {ok, [AutoId, RewardType]};
read(18914, Bin0) ->
    <<ShippingId:8, Bin1/binary>> = Bin0, 
    <<AutoUp:8, _Bin2/binary>> = Bin1, 
    {ok, [ShippingId, AutoUp]};
read(18915, _) ->
    {ok, []};
read(18916, _) ->
    {ok, []};
read(18917, _) ->
    {ok, []};
read(18918, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (18900,[
    Pic,
    PicVer,
    RewardTimes,
    TotalRewardTimes,
    RobTimes,
    TotalRobTimes,
    AutoId,
    Status,
    SendList
]) ->
    Bin_Pic = pt:write_string(Pic), 

    BinList_SendList = [
        item_to_bin_0(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        Bin_Pic/binary,
        PicVer:32,
        RewardTimes:8,
        TotalRewardTimes:8,
        RobTimes:8,
        TotalRobTimes:8,
        AutoId:64,
        Status:8,
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(18900, Data)};

write (18901,[
    LogList
]) ->
    BinList_LogList = [
        item_to_bin_1(LogList_Item) || LogList_Item <- LogList
    ], 

    LogList_Len = length(LogList), 
    Bin_LogList = list_to_binary(BinList_LogList),

    Data = <<
        LogList_Len:16, Bin_LogList/binary
    >>,
    {ok, pt:pack(18901, Data)};

write (18902,[
    ShippingId,
    LuckeyValue,
    RewardTimes,
    TotalRewardTimes,
    UpTimes,
    TotalUpTimes
]) ->
    Data = <<
        ShippingId:8,
        LuckeyValue:16,
        RewardTimes:8,
        TotalRewardTimes:8,
        UpTimes:8,
        TotalUpTimes:8
    >>,
    {ok, pt:pack(18902, Data)};

write (18903,[
    ShippingId,
    Code
]) ->
    Data = <<
        ShippingId:8,
        Code:32
    >>,
    {ok, pt:pack(18903, Data)};

write (18904,[
    AutoId,
    RoberSerid,
    RoberSernum,
    RoberId,
    RoberName,
    RoberPower,
    ShippingId,
    Reward,
    RobReward,
    Time
]) ->
    Bin_RoberName = pt:write_string(RoberName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Bin_RobReward = pt:write_object_list(RobReward), 

    Data = <<
        AutoId:64,
        RoberSerid:32,
        RoberSernum:32,
        RoberId:64,
        Bin_RoberName/binary,
        RoberPower:64,
        ShippingId:8,
        Bin_Reward/binary,
        Bin_RobReward/binary,
        Time:32
    >>,
    {ok, pt:pack(18904, Data)};

write (18905,[
    Code,
    AutoId,
    ServerId,
    RoleId,
    Type
]) ->
    Data = <<
        Code:32,
        AutoId:64,
        ServerId:32,
        RoleId:64,
        Type:8
    >>,
    {ok, pt:pack(18905, Data)};

write (18906,[
    Stage,
    Time,
    CombatPower
]) ->
    Data = <<
        Stage:8,
        Time:32,
        CombatPower:64
    >>,
    {ok, pt:pack(18906, Data)};

write (18907,[
    Res,
    BattleType,
    ShippingId,
    AutoId,
    Aer,
    Der,
    BeHelperId,
    Reward
]) ->
    BinList_Aer = [
        item_to_bin_2(Aer_Item) || Aer_Item <- Aer
    ], 

    Aer_Len = length(Aer), 
    Bin_Aer = list_to_binary(BinList_Aer),

    BinList_Der = [
        item_to_bin_3(Der_Item) || Der_Item <- Der
    ], 

    Der_Len = length(Der), 
    Bin_Der = list_to_binary(BinList_Der),

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Res:8,
        BattleType:8,
        ShippingId:8,
        AutoId:64,
        Aer_Len:16, Bin_Aer/binary,
        Der_Len:16, Bin_Der/binary,
        BeHelperId:64,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(18907, Data)};

write (18908,[
    RoleId,
    Name,
    Pic,
    PicVer,
    ShippingId,
    AutoId,
    Reward,
    AddFriendCode
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Pic = pt:write_string(Pic), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Bin_Pic/binary,
        PicVer:32,
        ShippingId:8,
        AutoId:64,
        Bin_Reward/binary,
        AddFriendCode:32
    >>,
    {ok, pt:pack(18908, Data)};

write (18909,[
    AutoId,
    RewardType,
    ShippingId,
    Code,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        AutoId:64,
        RewardType:8,
        ShippingId:8,
        Code:32,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(18909, Data)};

write (18910,[
    LogList
]) ->
    BinList_LogList = [
        item_to_bin_4(LogList_Item) || LogList_Item <- LogList
    ], 

    LogList_Len = length(LogList), 
    Bin_LogList = list_to_binary(BinList_LogList),

    Data = <<
        LogList_Len:16, Bin_LogList/binary
    >>,
    {ok, pt:pack(18910, Data)};

write (18911,[
    SendList
]) ->
    BinList_SendList = [
        item_to_bin_5(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(18911, Data)};

write (18912,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18912, Data)};

write (18914,[
    Code,
    ShippingId,
    LuckeyValue,
    UpTimes,
    TotalUpTimes
]) ->
    Data = <<
        Code:32,
        ShippingId:8,
        LuckeyValue:16,
        UpTimes:8,
        TotalUpTimes:8
    >>,
    {ok, pt:pack(18914, Data)};

write (18915,[
    TreasureMod,
    Wlv,
    Enemy,
    UnSatisfyMod,
    UnSatisfyWlv,
    MinWlv,
    UnSatisfy
]) ->
    BinList_Enemy = [
        item_to_bin_6(Enemy_Item) || Enemy_Item <- Enemy
    ], 

    Enemy_Len = length(Enemy), 
    Bin_Enemy = list_to_binary(BinList_Enemy),

    BinList_UnSatisfy = [
        item_to_bin_7(UnSatisfy_Item) || UnSatisfy_Item <- UnSatisfy
    ], 

    UnSatisfy_Len = length(UnSatisfy), 
    Bin_UnSatisfy = list_to_binary(BinList_UnSatisfy),

    Data = <<
        TreasureMod:8,
        Wlv:16,
        Enemy_Len:16, Bin_Enemy/binary,
        UnSatisfyMod:8,
        UnSatisfyWlv:16,
        MinWlv:16,
        UnSatisfy_Len:16, Bin_UnSatisfy/binary
    >>,
    {ok, pt:pack(18915, Data)};

write (18916,[
    Num,
    Max
]) ->
    Data = <<
        Num:16,
        Max:16
    >>,
    {ok, pt:pack(18916, Data)};

write (18917,[
    AutoId,
    Status,
    RewardTimes,
    TotalRewardTimes
]) ->
    Data = <<
        AutoId:64,
        Status:8,
        RewardTimes:8,
        TotalRewardTimes:8
    >>,
    {ok, pt:pack(18917, Data)};

write (18918,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18918, Data)};

write (18919,[
    AutoId
]) ->
    Data = <<
        AutoId:64
    >>,
    {ok, pt:pack(18919, Data)};

write (18920,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18920, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AutoId,
    ShippingId,
    SerId,
    SerNum,
    GuildId,
    GuildName,
    RoleId,
    RoleName,
    RoleLv,
    Power,
    Sex,
    Career,
    Turn,
    Pic,
    PicVer,
    EndTime,
    RobTimes
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Pic = pt:write_string(Pic), 

    Data = <<
        AutoId:64,
        ShippingId:8,
        SerId:32,
        SerNum:32,
        GuildId:64,
        Bin_GuildName/binary,
        RoleId:64,
        Bin_RoleName/binary,
        RoleLv:16,
        Power:64,
        Sex:8,
        Career:16,
        Turn:8,
        Bin_Pic/binary,
        PicVer:32,
        EndTime:32,
        RobTimes:8
    >>,
    Data.
item_to_bin_1 ({
    AutoId,
    Type,
    RoberSerid,
    RoberSernum,
    RoberGid,
    RoberGname,
    RoberId,
    RoberName,
    RoberPower,
    ShippingId,
    Reward,
    BackList,
    RecvList,
    Time
}) ->
    Bin_RoberGname = pt:write_string(RoberGname), 

    Bin_RoberName = pt:write_string(RoberName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Bin_BackList = pt:write_object_list(BackList), 

    Bin_RecvList = pt:write_object_list(RecvList), 

    Data = <<
        AutoId:64,
        Type:8,
        RoberSerid:32,
        RoberSernum:32,
        RoberGid:64,
        Bin_RoberGname/binary,
        RoberId:64,
        Bin_RoberName/binary,
        RoberPower:64,
        ShippingId:8,
        Bin_Reward/binary,
        Bin_BackList/binary,
        Bin_RecvList/binary,
        Time:32
    >>,
    Data.
item_to_bin_2 ({
    SerNum,
    SerId,
    Pic,
    PicVer,
    RoleId,
    Name,
    HpPer,
    Power
}) ->
    Bin_Pic = pt:write_string(Pic), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        SerNum:32,
        SerId:32,
        Bin_Pic/binary,
        PicVer:32,
        RoleId:64,
        Bin_Name/binary,
        HpPer:8,
        Power:64
    >>,
    Data.
item_to_bin_3 ({
    SerNum,
    SerId,
    Sex,
    Career,
    Pic,
    PicVer,
    Turn,
    RoleId,
    Name,
    HpPer,
    Power
}) ->
    Bin_Pic = pt:write_string(Pic), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        SerNum:32,
        SerId:32,
        Sex:8,
        Career:16,
        Bin_Pic/binary,
        PicVer:32,
        Turn:8,
        RoleId:64,
        Bin_Name/binary,
        HpPer:8,
        Power:64
    >>,
    Data.
item_to_bin_4 ({
    AutoId,
    Type,
    RoberSerid,
    RoberSernum,
    RoberGid,
    RoberGname,
    RoberId,
    RoberName,
    RoberPower,
    ShippingId,
    Reward,
    BackList,
    RecvList,
    Time
}) ->
    Bin_RoberGname = pt:write_string(RoberGname), 

    Bin_RoberName = pt:write_string(RoberName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Bin_BackList = pt:write_object_list(BackList), 

    Bin_RecvList = pt:write_object_list(RecvList), 

    Data = <<
        AutoId:64,
        Type:8,
        RoberSerid:32,
        RoberSernum:32,
        RoberGid:64,
        Bin_RoberGname/binary,
        RoberId:64,
        Bin_RoberName/binary,
        RoberPower:64,
        ShippingId:8,
        Bin_Reward/binary,
        Bin_BackList/binary,
        Bin_RecvList/binary,
        Time:32
    >>,
    Data.
item_to_bin_5 ({
    AutoId,
    ShippingId,
    SerId,
    SerNum,
    GuildId,
    GuildName,
    RoleId,
    RoleName,
    RoleLv,
    Power,
    Sex,
    Career,
    Turn,
    Pic,
    PicVer,
    EndTime,
    RobTimes
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Pic = pt:write_string(Pic), 

    Data = <<
        AutoId:64,
        ShippingId:8,
        SerId:32,
        SerNum:32,
        GuildId:64,
        Bin_GuildName/binary,
        RoleId:64,
        Bin_RoleName/binary,
        RoleLv:16,
        Power:64,
        Sex:8,
        Career:16,
        Turn:8,
        Bin_Pic/binary,
        PicVer:32,
        EndTime:32,
        RobTimes:8
    >>,
    Data.
item_to_bin_6 ({
    SerId,
    SerNum,
    SerName,
    WorldLv
}) ->
    Bin_SerName = pt:write_string(SerName), 

    Data = <<
        SerId:32,
        SerNum:16,
        Bin_SerName/binary,
        WorldLv:16
    >>,
    Data.
item_to_bin_7 ({
    SerId,
    SerNum,
    SerName,
    WorldLv
}) ->
    Bin_SerName = pt:write_string(SerName), 

    Data = <<
        SerId:32,
        SerNum:16,
        Bin_SerName/binary,
        WorldLv:16
    >>,
    Data.
