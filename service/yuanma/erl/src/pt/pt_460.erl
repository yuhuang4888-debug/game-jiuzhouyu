-module(pt_460).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(46000, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(46001, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(46002, _) ->
    {ok, []};
read(46003, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(46004, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(46005, _) ->
    {ok, []};
read(46006, _) ->
    {ok, []};
read(46007, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, Bin2/binary>> = Bin1, 
    <<Remind:8, Bin3/binary>> = Bin2, 
    <<IsAuto:8, _Bin4/binary>> = Bin3, 
    {ok, [BossType, BossId, Remind, IsAuto]};
read(46010, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(46012, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(46015, _) ->
    {ok, []};
read(46017, _) ->
    {ok, []};
read(46018, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(46020, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(46022, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(46023, _) ->
    {ok, []};
read(46026, _) ->
    {ok, []};
read(46031, Bin0) ->
    <<BossId:32, _Bin1/binary>> = Bin0, 
    {ok, [BossId]};
read(46032, Bin0) ->
    <<BossId:32, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [BossId, Type]};
read(46034, _) ->
    {ok, []};
read(46037, _) ->
    {ok, []};
read(46038, Bin0) ->
    <<RewardId:32, _Bin1/binary>> = Bin0, 
    {ok, [RewardId]};
read(46039, _) ->
    {ok, []};
read(46040, _) ->
    {ok, []};
read(46041, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [BossType, BossId]};
read(46043, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(46044, Bin0) ->
    <<BossType:8, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(46045, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<VitNum:16, _Bin2/binary>> = Bin1, 
    {ok, [BossType, VitNum]};
read(46046, Bin0) ->
    <<BossType:16, _Bin1/binary>> = Bin0, 
    {ok, [BossType]};
read(_Cmd, _R) -> {error, no_match}.

write (46000,[
    BossType,
    AllCount,
    Count,
    Tired,
    AllTired,
    Vit,
    LastVitTime,
    CollectTimes,
    AllCollectTimes,
    BossInfo
]) ->
    BinList_BossInfo = [
        item_to_bin_0(BossInfo_Item) || BossInfo_Item <- BossInfo
    ], 

    BossInfo_Len = length(BossInfo), 
    Bin_BossInfo = list_to_binary(BinList_BossInfo),

    Data = <<
        BossType:8,
        AllCount:8,
        Count:8,
        Tired:16,
        AllTired:16,
        Vit:16,
        LastVitTime:32,
        CollectTimes:8,
        AllCollectTimes:8,
        BossInfo_Len:16, Bin_BossInfo/binary
    >>,
    {ok, pt:pack(46000, Data)};

write (46001,[
    KillLog
]) ->
    BinList_KillLog = [
        item_to_bin_1(KillLog_Item) || KillLog_Item <- KillLog
    ], 

    KillLog_Len = length(KillLog), 
    Bin_KillLog = list_to_binary(BinList_KillLog),

    Data = <<
        KillLog_Len:16, Bin_KillLog/binary
    >>,
    {ok, pt:pack(46001, Data)};

write (46002,[
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
    {ok, pt:pack(46002, Data)};

write (46003,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(46003, Data)};

write (46004,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(46004, Data)};

write (46005,[
    Anger,
    MaxAnger
]) ->
    Data = <<
        Anger:16,
        MaxAnger:16
    >>,
    {ok, pt:pack(46005, Data)};

write (46006,[
    Type,
    TickoutTime
]) ->
    Data = <<
        Type:8,
        TickoutTime:8
    >>,
    {ok, pt:pack(46006, Data)};

write (46007,[
    Code,
    BossType,
    BossId,
    Remind,
    IsAuto
]) ->
    Data = <<
        Code:32,
        BossType:8,
        BossId:32,
        Remind:8,
        IsAuto:8
    >>,
    {ok, pt:pack(46007, Data)};

write (46008,[
    BossType,
    BossId
]) ->
    Data = <<
        BossType:8,
        BossId:32
    >>,
    {ok, pt:pack(46008, Data)};

write (46009,[
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
    {ok, pt:pack(46009, Data)};

write (46010,[
    BossType,
    Scene,
    MonIds
]) ->
    BinList_MonIds = [
        item_to_bin_4(MonIds_Item) || MonIds_Item <- MonIds
    ], 

    MonIds_Len = length(MonIds), 
    Bin_MonIds = list_to_binary(BinList_MonIds),

    Data = <<
        BossType:8,
        Scene:32,
        MonIds_Len:16, Bin_MonIds/binary
    >>,
    {ok, pt:pack(46010, Data)};

write (46011,[
    BossTired
]) ->
    Data = <<
        BossTired:8
    >>,
    {ok, pt:pack(46011, Data)};

write (46012,[
    Code,
    BossId,
    X,
    Y
]) ->
    Data = <<
        Code:32,
        BossId:32,
        X:16,
        Y:16
    >>,
    {ok, pt:pack(46012, Data)};

write (46013,[
    BossType,
    BossId,
    Num
]) ->
    Data = <<
        BossType:8,
        BossId:32,
        Num:8
    >>,
    {ok, pt:pack(46013, Data)};

write (46014,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(46014, Data)};

write (46015,[
    RewardType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_5(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardType:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(46015, Data)};

write (46016,[
    BossType,
    BossId
]) ->
    Data = <<
        BossType:8,
        BossId:32
    >>,
    {ok, pt:pack(46016, Data)};

write (46017,[
    ShowIcon
]) ->
    Data = <<
        ShowIcon:8
    >>,
    {ok, pt:pack(46017, Data)};

write (46018,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(46018, Data)};

write (46019,[
    Rank
]) ->
    BinList_Rank = [
        item_to_bin_6(Rank_Item) || Rank_Item <- Rank
    ], 

    Rank_Len = length(Rank), 
    Bin_Rank = list_to_binary(BinList_Rank),

    Data = <<
        Rank_Len:16, Bin_Rank/binary
    >>,
    {ok, pt:pack(46019, Data)};

write (46020,[
    Code,
    Times1,
    Times2
]) ->
    Data = <<
        Code:32,
        Times1:8,
        Times2:8
    >>,
    {ok, pt:pack(46020, Data)};

write (46021,[
    FirstName,
    FirstDamage,
    AttrName,
    SelfRank,
    Lv,
    Figure,
    Reward
]) ->
    Bin_FirstName = pt:write_string(FirstName), 

    Bin_AttrName = pt:write_string(AttrName), 

    Bin_Figure = pt:write_figure(Figure), 

    BinList_Reward = [
        item_to_bin_7(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Bin_FirstName/binary,
        FirstDamage:32,
        Bin_AttrName/binary,
        SelfRank:8,
        Lv:8,
        Bin_Figure/binary,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(46021, Data)};

write (46022,[
    SelfRank,
    SelfDamage,
    SelfName,
    Distance
]) ->
    Bin_SelfName = pt:write_string(SelfName), 

    Data = <<
        SelfRank:8,
        SelfDamage:32,
        Bin_SelfName/binary,
        Distance:32
    >>,
    {ok, pt:pack(46022, Data)};

write (46023,[
    Boss
]) ->
    BinList_Boss = [
        item_to_bin_8(Boss_Item) || Boss_Item <- Boss
    ], 

    Boss_Len = length(Boss), 
    Bin_Boss = list_to_binary(BinList_Boss),

    Data = <<
        Boss_Len:16, Bin_Boss/binary
    >>,
    {ok, pt:pack(46023, Data)};

write (46024,[
    RoleId,
    Figure,
    Dkill
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        Dkill:16
    >>,
    {ok, pt:pack(46024, Data)};

write (46025,[
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_9(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(46025, Data)};

write (46026,[
    BoxList
]) ->
    BinList_BoxList = [
        item_to_bin_10(BoxList_Item) || BoxList_Item <- BoxList
    ], 

    BoxList_Len = length(BoxList), 
    Bin_BoxList = list_to_binary(BinList_BoxList),

    Data = <<
        BoxList_Len:16, Bin_BoxList/binary
    >>,
    {ok, pt:pack(46026, Data)};

write (46027,[
    BossId,
    BossX,
    BossY,
    BoxList
]) ->
    BinList_BoxList = [
        item_to_bin_11(BoxList_Item) || BoxList_Item <- BoxList
    ], 

    BoxList_Len = length(BoxList), 
    Bin_BoxList = list_to_binary(BinList_BoxList),

    Data = <<
        BossId:32,
        BossX:32,
        BossY:32,
        BoxList_Len:16, Bin_BoxList/binary
    >>,
    {ok, pt:pack(46027, Data)};

write (46028,[
    Code,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(46028, Data)};

write (46029,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(46029, Data)};

write (46030,[
    RoleId,
    Figure
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary
    >>,
    {ok, pt:pack(46030, Data)};

write (46031,[
    BossId,
    RoleId,
    Name,
    Career,
    Lv,
    Combat,
    Picture,
    PictureVer,
    Time,
    Curtimes,
    LimitTimes
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        BossId:32,
        RoleId:64,
        Bin_Name/binary,
        Career:8,
        Lv:16,
        Combat:64,
        Bin_Picture/binary,
        PictureVer:32,
        Time:32,
        Curtimes:16,
        LimitTimes:16
    >>,
    {ok, pt:pack(46031, Data)};

write (46032,[
    Code,
    BossId,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        BossId:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(46032, Data)};

write (46033,[
    NextWave,
    Time
]) ->
    Data = <<
        NextWave:32,
        Time:32
    >>,
    {ok, pt:pack(46033, Data)};

write (46034,[
    DieTimes,
    Time,
    DebuffTime,
    SafeTime
]) ->
    Data = <<
        DieTimes:16,
        Time:32,
        DebuffTime:32,
        SafeTime:32
    >>,
    {ok, pt:pack(46034, Data)};

write (46035,[
    BossType,
    Layer
]) ->
    Data = <<
        BossType:8,
        Layer:8
    >>,
    {ok, pt:pack(46035, Data)};

write (46036,[
    BossId,
    Xylist
]) ->
    BinList_Xylist = [
        item_to_bin_12(Xylist_Item) || Xylist_Item <- Xylist
    ], 

    Xylist_Len = length(Xylist), 
    Bin_Xylist = list_to_binary(BinList_Xylist),

    Data = <<
        BossId:32,
        Xylist_Len:16, Bin_Xylist/binary
    >>,
    {ok, pt:pack(46036, Data)};

write (46037,[
    KillNum,
    HadRewardList
]) ->
    BinList_HadRewardList = [
        item_to_bin_13(HadRewardList_Item) || HadRewardList_Item <- HadRewardList
    ], 

    HadRewardList_Len = length(HadRewardList), 
    Bin_HadRewardList = list_to_binary(BinList_HadRewardList),

    Data = <<
        KillNum:32,
        HadRewardList_Len:16, Bin_HadRewardList/binary
    >>,
    {ok, pt:pack(46037, Data)};

write (46038,[
    RewardId,
    Code
]) ->
    Data = <<
        RewardId:32,
        Code:32
    >>,
    {ok, pt:pack(46038, Data)};

write (46039,[
    Info
]) ->
    BinList_Info = [
        item_to_bin_14(Info_Item) || Info_Item <- Info
    ], 

    Info_Len = length(Info), 
    Bin_Info = list_to_binary(BinList_Info),

    Data = <<
        Info_Len:16, Bin_Info/binary
    >>,
    {ok, pt:pack(46039, Data)};

write (46040,[
    List
]) ->
    BinList_List = [
        item_to_bin_16(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(46040, Data)};

write (46041,[
    Errcode,
    BossType,
    BossId
]) ->
    Data = <<
        Errcode:32,
        BossType:8,
        BossId:32
    >>,
    {ok, pt:pack(46041, Data)};

write (46042,[
    BossType,
    BossId
]) ->
    Data = <<
        BossType:8,
        BossId:32
    >>,
    {ok, pt:pack(46042, Data)};

write (46043,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(46043, Data)};

write (46044,[
    Vit,
    MaxVit,
    AddVit,
    BackVit,
    LastVitTime
]) ->
    Data = <<
        Vit:16,
        MaxVit:16,
        AddVit:16,
        BackVit:16,
        LastVitTime:32
    >>,
    {ok, pt:pack(46044, Data)};

write (46045,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(46045, Data)};

write (46046,[
    BossType,
    DropLog
]) ->
    BinList_DropLog = [
        item_to_bin_17(DropLog_Item) || DropLog_Item <- DropLog
    ], 

    DropLog_Len = length(DropLog), 
    Bin_DropLog = list_to_binary(BinList_DropLog),

    Data = <<
        BossType:16,
        DropLog_Len:16, Bin_DropLog/binary
    >>,
    {ok, pt:pack(46046, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BossId,
    Num,
    RebornTime,
    IsRemind,
    AutoRemind
}) ->
    Data = <<
        BossId:32,
        Num:8,
        RebornTime:32,
        IsRemind:8,
        AutoRemind:8
    >>,
    Data.
item_to_bin_1 ({
    Time,
    RoleId,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Time:32,
        RoleId:64,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_2 ({
    Time,
    RoleId,
    Name,
    BossType,
    BossId,
    GoodsId,
    Num,
    Rating,
    EquipExtraAttr,
    IsTop
}) ->
    Bin_Name = pt:write_string(Name), 

    BinList_EquipExtraAttr = [
        item_to_bin_3(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Time:32,
        RoleId:64,
        Bin_Name/binary,
        BossType:8,
        BossId:32,
        GoodsId:32,
        Num:32,
        Rating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        IsTop:8
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
    MonId,
    X,
    Y
}) ->
    Data = <<
        MonId:32,
        X:16,
        Y:16
    >>,
    Data.
item_to_bin_5 ({
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
item_to_bin_6 ({
    RoleName,
    Damage
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        Damage:32
    >>,
    Data.
item_to_bin_7 ({
    Type,
    Goodtypeid,
    Num
}) ->
    Data = <<
        Type:32,
        Goodtypeid:32,
        Num:8
    >>,
    Data.
item_to_bin_8 ({
    Bossid,
    BossStatus
}) ->
    Data = <<
        Bossid:32,
        BossStatus:8
    >>,
    Data.
item_to_bin_9 ({
    Key,
    Val
}) ->
    Data = <<
        Key:8,
        Val:32
    >>,
    Data.
item_to_bin_10 (
    BoxId
) ->
    Data = <<
        BoxId:32
    >>,
    Data.
item_to_bin_11 ({
    X,
    Y,
    AutoId,
    MonCfgId,
    Hp,
    HpLim,
    Lv,
    Name,
    Sp,
    MonResource,
    MonRes,
    ImagId,
    WeaponId,
    AttType,
    Kind,
    Color,
    OnHook,
    Boss,
    CollectTime,
    IsBeClicked,
    IsBeAtted,
    Hide,
    Ghost,
    MonGroup,
    GuildId,
    Angel,
    AttrType,
    Title
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_MonRes = pt:write_string(MonRes), 

    Data = <<
        X:16,
        Y:16,
        AutoId:32,
        MonCfgId:32,
        Hp:64,
        HpLim:64,
        Lv:16,
        Bin_Name/binary,
        Sp:16,
        MonResource:32,
        Bin_MonRes/binary,
        ImagId:32,
        WeaponId:32,
        AttType:8,
        Kind:8,
        Color:8,
        OnHook:8,
        Boss:8,
        CollectTime:32,
        IsBeClicked:8,
        IsBeAtted:8,
        Hide:8,
        Ghost:8,
        MonGroup:16,
        GuildId:64,
        Angel:16,
        AttrType:8,
        Title:32
    >>,
    Data.
item_to_bin_12 ({
    X,
    Y
}) ->
    Data = <<
        X:16,
        Y:16
    >>,
    Data.
item_to_bin_13 (
    Stage
) ->
    Data = <<
        Stage:16
    >>,
    Data.
item_to_bin_14 ({
    BossId,
    Xylist
}) ->
    BinList_Xylist = [
        item_to_bin_15(Xylist_Item) || Xylist_Item <- Xylist
    ], 

    Xylist_Len = length(Xylist), 
    Bin_Xylist = list_to_binary(BinList_Xylist),

    Data = <<
        BossId:32,
        Xylist_Len:16, Bin_Xylist/binary
    >>,
    Data.
item_to_bin_15 ({
    X,
    Y
}) ->
    Data = <<
        X:16,
        Y:16
    >>,
    Data.
item_to_bin_16 ({
    MonId,
    AutoId,
    Hp,
    HpMax
}) ->
    Data = <<
        MonId:32,
        AutoId:64,
        Hp:64,
        HpMax:64
    >>,
    Data.
item_to_bin_17 ({
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
        item_to_bin_18(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
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
item_to_bin_18 ({
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
