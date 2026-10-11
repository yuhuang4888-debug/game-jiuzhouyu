-module(pt_400).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40001, Bin0) ->
    {GuildName, Bin1} = pt:read_string(Bin0), 
    <<PageSize:16, Bin2/binary>> = Bin1, 
    <<PageNo:16, _Bin3/binary>> = Bin2, 
    {ok, [GuildName, PageSize, PageNo]};
read(40002, Bin0) ->
    <<GuildId:64, _Bin1/binary>> = Bin0, 
    {ok, [GuildId]};
read(40003, _) ->
    {ok, []};
read(40004, Bin0) ->
    <<CfgId:64, Bin1/binary>> = Bin0, 
    {GuildName, _Bin2} = pt:read_string(Bin1), 
    {ok, [CfgId, GuildName]};
read(40005, _) ->
    {ok, []};
read(40006, _) ->
    {ok, []};
read(40007, _) ->
    {ok, []};
read(40008, _) ->
    {ok, []};
read(40009, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Type]};
read(40010, _) ->
    {ok, []};
read(40011, Bin0) ->
    <<ApproveType:8, Bin1/binary>> = Bin0, 
    <<AutoApproveLv:16, Bin2/binary>> = Bin1, 
    <<AutoApprovePower:32, _Bin3/binary>> = Bin2, 
    {ok, [ApproveType, AutoApproveLv, AutoApprovePower]};
read(40012, Bin0) ->
    <<SaveType:8, Bin1/binary>> = Bin0, 
    {Announce, _Bin2} = pt:read_string(Bin1), 
    {ok, [SaveType, Announce]};
read(40013, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Position:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Position]};
read(40014, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(40015, _) ->
    {ok, []};
read(40016, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(40018, _) ->
    {ok, []};
read(40019, _) ->
    {ok, []};
read(40020, _) ->
    {ok, []};
read(40021, _) ->
    {ok, []};
read(40023, _) ->
    {ok, []};
read(40024, Bin0) ->
    <<DonateType:8, Bin1/binary>> = Bin0, 
    <<Times:8, _Bin2/binary>> = Bin1, 
    {ok, [DonateType, Times]};
read(40025, Bin0) ->
    <<GiftId:16, _Bin1/binary>> = Bin0, 
    {ok, [GiftId]};
read(40027, _) ->
    {ok, []};
read(40028, _) ->
    {ok, []};
read(40029, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(40030, _) ->
    {ok, []};
read(40031, _) ->
    {ok, []};
read(40040, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(40041, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(40042, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(40043, Bin0) ->
    {NewName, _Bin1} = pt:read_string(Bin0), 
    {ok, [NewName]};
read(40044, _) ->
    {ok, []};
read(40050, _) ->
    {ok, []};
read(40051, Bin0) ->
    <<GiftId:16, _Bin1/binary>> = Bin0, 
    {ok, [GiftId]};
read(40052, _) ->
    {ok, []};
read(40053, Bin0) ->
    <<Door:8, _Bin1/binary>> = Bin0, 
    {ok, [Door]};
read(40054, _) ->
    {ok, []};
read(40055, _) ->
    {ok, []};
read(40056, _) ->
    {ok, []};
read(40057, _) ->
    {ok, []};
read(40058, _) ->
    {ok, []};
read(40060, _) ->
    {ok, []};
read(40061, _) ->
    {ok, []};
read(40062, Bin0) ->
    <<GuildId:64, _Bin1/binary>> = Bin0, 
    {ok, [GuildId]};
read(40063, Bin0) ->
    <<OpType:8, Bin1/binary>> = Bin0, 
    <<GuildId:64, _Bin2/binary>> = Bin1, 
    {ok, [OpType, GuildId]};
read(_Cmd, _R) -> {error, no_match}.

write (40000,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40000, Data)};

write (40001,[
    PageTotal,
    PageNo,
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_0(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        PageTotal:16,
        PageNo:16,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(40001, Data)};

write (40002,[
    ErrorCode,
    GuildId,
    ApplyType
]) ->
    Data = <<
        ErrorCode:32,
        GuildId:64,
        ApplyType:8
    >>,
    {ok, pt:pack(40002, Data)};

write (40003,[
    ErrorCode,
    GuildId,
    ApplyType
]) ->
    Data = <<
        ErrorCode:32,
        GuildId:64,
        ApplyType:8
    >>,
    {ok, pt:pack(40003, Data)};

write (40004,[
    ErrorCode,
    GuildId
]) ->
    Data = <<
        ErrorCode:32,
        GuildId:64
    >>,
    {ok, pt:pack(40004, Data)};

write (40005,[
    GuildId,
    GuildName,
    Announce,
    PositionList,
    GuildLv,
    Gfunds,
    GrowthVal,
    Gactivity,
    MemberNum,
    MemberCapacity,
    CombatPower,
    OnlineNum,
    DisbandWarnningTime,
    SalaryStatus,
    Division,
    JoinTime,
    IsInMerge
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_Announce = pt:write_string(Announce), 

    BinList_PositionList = [
        item_to_bin_1(PositionList_Item) || PositionList_Item <- PositionList
    ], 

    PositionList_Len = length(PositionList), 
    Bin_PositionList = list_to_binary(BinList_PositionList),

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        Bin_Announce/binary,
        PositionList_Len:16, Bin_PositionList/binary,
        GuildLv:16,
        Gfunds:32,
        GrowthVal:32,
        Gactivity:32,
        MemberNum:16,
        MemberCapacity:16,
        CombatPower:64,
        OnlineNum:16,
        DisbandWarnningTime:32,
        SalaryStatus:8,
        Division:8,
        JoinTime:32,
        IsInMerge:8
    >>,
    {ok, pt:pack(40005, Data)};

write (40006,[
    MemberList
]) ->
    BinList_MemberList = [
        item_to_bin_2(MemberList_Item) || MemberList_Item <- MemberList
    ], 

    MemberList_Len = length(MemberList), 
    Bin_MemberList = list_to_binary(BinList_MemberList),

    Data = <<
        MemberList_Len:16, Bin_MemberList/binary
    >>,
    {ok, pt:pack(40006, Data)};

write (40007,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40007, Data)};

write (40008,[
    ApplyList
]) ->
    BinList_ApplyList = [
        item_to_bin_3(ApplyList_Item) || ApplyList_Item <- ApplyList
    ], 

    ApplyList_Len = length(ApplyList), 
    Bin_ApplyList = list_to_binary(BinList_ApplyList),

    Data = <<
        ApplyList_Len:16, Bin_ApplyList/binary
    >>,
    {ok, pt:pack(40008, Data)};

write (40009,[
    ErrorCode,
    Type,
    RoleId
]) ->
    Data = <<
        ErrorCode:32,
        Type:8,
        RoleId:64
    >>,
    {ok, pt:pack(40009, Data)};

write (40010,[
    ApproveType,
    AutoApproveLv,
    AutoApprovePower
]) ->
    Data = <<
        ApproveType:8,
        AutoApproveLv:16,
        AutoApprovePower:32
    >>,
    {ok, pt:pack(40010, Data)};

write (40011,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40011, Data)};

write (40012,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40012, Data)};

write (40013,[
    ErrorCode,
    RoleId,
    Position
]) ->
    Data = <<
        ErrorCode:32,
        RoleId:64,
        Position:8
    >>,
    {ok, pt:pack(40013, Data)};

write (40014,[
    ErrorCode,
    RoleId
]) ->
    Data = <<
        ErrorCode:32,
        RoleId:64
    >>,
    {ok, pt:pack(40014, Data)};

write (40015,[
    GuildId,
    GuildName,
    GuildLv,
    Position,
    PositionName
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_PositionName = pt:write_string(PositionName), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        GuildLv:16,
        Position:8,
        Bin_PositionName/binary
    >>,
    {ok, pt:pack(40015, Data)};

write (40016,[
    ErrorCode,
    Type
]) ->
    Data = <<
        ErrorCode:32,
        Type:8
    >>,
    {ok, pt:pack(40016, Data)};

write (40017,[
    RoleId,
    GuildId,
    GuildName,
    Position,
    PositionName
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_PositionName = pt:write_string(PositionName), 

    Data = <<
        RoleId:64,
        GuildId:64,
        Bin_GuildName/binary,
        Position:8,
        Bin_PositionName/binary
    >>,
    {ok, pt:pack(40017, Data)};

write (40018,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40018, Data)};

write (40019,[
    RemainTimes,
    FreeTimes
]) ->
    Data = <<
        RemainTimes:8,
        FreeTimes:8
    >>,
    {ok, pt:pack(40019, Data)};

write (40020,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40020, Data)};

write (40021,[
    PermissionTypeList
]) ->
    BinList_PermissionTypeList = [
        item_to_bin_4(PermissionTypeList_Item) || PermissionTypeList_Item <- PermissionTypeList
    ], 

    PermissionTypeList_Len = length(PermissionTypeList), 
    Bin_PermissionTypeList = list_to_binary(BinList_PermissionTypeList),

    Data = <<
        PermissionTypeList_Len:16, Bin_PermissionTypeList/binary
    >>,
    {ok, pt:pack(40021, Data)};

write (40023,[
    Gactivity,
    DonateTimes,
    SelfGiftList,
    DonateRecord
]) ->
    BinList_SelfGiftList = [
        item_to_bin_5(SelfGiftList_Item) || SelfGiftList_Item <- SelfGiftList
    ], 

    SelfGiftList_Len = length(SelfGiftList), 
    Bin_SelfGiftList = list_to_binary(BinList_SelfGiftList),

    BinList_DonateRecord = [
        item_to_bin_6(DonateRecord_Item) || DonateRecord_Item <- DonateRecord
    ], 

    DonateRecord_Len = length(DonateRecord), 
    Bin_DonateRecord = list_to_binary(BinList_DonateRecord),

    Data = <<
        Gactivity:32,
        DonateTimes:8,
        SelfGiftList_Len:16, Bin_SelfGiftList/binary,
        DonateRecord_Len:16, Bin_DonateRecord/binary
    >>,
    {ok, pt:pack(40023, Data)};

write (40024,[
    ErrorCode,
    DonateType,
    DonateTimes,
    Donate,
    HistoricalDonate,
    Gfunds,
    Gactivity
]) ->
    Data = <<
        ErrorCode:32,
        DonateType:8,
        DonateTimes:8,
        Donate:32,
        HistoricalDonate:32,
        Gfunds:32,
        Gactivity:32
    >>,
    {ok, pt:pack(40024, Data)};

write (40025,[
    ErrorCode,
    GiftId
]) ->
    Data = <<
        ErrorCode:32,
        GiftId:16
    >>,
    {ok, pt:pack(40025, Data)};

write (40026,[
    DonateRecord
]) ->
    BinList_DonateRecord = [
        item_to_bin_7(DonateRecord_Item) || DonateRecord_Item <- DonateRecord
    ], 

    DonateRecord_Len = length(DonateRecord), 
    Bin_DonateRecord = list_to_binary(BinList_DonateRecord),

    Data = <<
        DonateRecord_Len:16, Bin_DonateRecord/binary
    >>,
    {ok, pt:pack(40026, Data)};

write (40027,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40027, Data)};

write (40028,[
    Gactivity
]) ->
    Data = <<
        Gactivity:32
    >>,
    {ok, pt:pack(40028, Data)};

write (40029,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(40029, Data)};

write (40030,[
    AllPrestige,
    TitleId,
    PrestigeWeek,
    PrestigeLimit
]) ->
    Data = <<
        AllPrestige:32,
        TitleId:32,
        PrestigeWeek:32,
        PrestigeLimit:32
    >>,
    {ok, pt:pack(40030, Data)};

write (40031,[
    AllPrestige,
    PrestigeDay,
    PrestigeDayLimit
]) ->
    Data = <<
        AllPrestige:32,
        PrestigeDay:32,
        PrestigeDayLimit:32
    >>,
    {ok, pt:pack(40031, Data)};

write (40039,[
    Donate
]) ->
    Data = <<
        Donate:32
    >>,
    {ok, pt:pack(40039, Data)};

write (40040,[
    Donate,
    SkillList
]) ->
    BinList_SkillList = [
        item_to_bin_8(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Donate:32,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(40040, Data)};

write (40041,[
    ErrorCode,
    SkillId,
    ResearchLv,
    Gfunds
]) ->
    Data = <<
        ErrorCode:32,
        SkillId:32,
        ResearchLv:8,
        Gfunds:32
    >>,
    {ok, pt:pack(40041, Data)};

write (40042,[
    ErrorCode,
    SkillId,
    LearnLv,
    Donate,
    CurPower,
    NextPower
]) ->
    Data = <<
        ErrorCode:32,
        SkillId:32,
        LearnLv:8,
        Donate:32,
        CurPower:64,
        NextPower:64
    >>,
    {ok, pt:pack(40042, Data)};

write (40043,[
    ErrorCode,
    NewName
]) ->
    Bin_NewName = pt:write_string(NewName), 

    Data = <<
        ErrorCode:32,
        Bin_NewName/binary
    >>,
    {ok, pt:pack(40043, Data)};

write (40044,[
    IsFree,
    NextRenameTime
]) ->
    Data = <<
        IsFree:8,
        NextRenameTime:32
    >>,
    {ok, pt:pack(40044, Data)};

write (40050,[
    Code,
    Level,
    DunScore,
    ChallengeTimes,
    RoleScore,
    ScoreGiftList
]) ->
    BinList_ScoreGiftList = [
        item_to_bin_9(ScoreGiftList_Item) || ScoreGiftList_Item <- ScoreGiftList
    ], 

    ScoreGiftList_Len = length(ScoreGiftList), 
    Bin_ScoreGiftList = list_to_binary(BinList_ScoreGiftList),

    Data = <<
        Code:32,
        Level:8,
        DunScore:32,
        ChallengeTimes:8,
        RoleScore:32,
        ScoreGiftList_Len:16, Bin_ScoreGiftList/binary
    >>,
    {ok, pt:pack(40050, Data)};

write (40051,[
    Code,
    GiftId
]) ->
    Data = <<
        Code:32,
        GiftId:16
    >>,
    {ok, pt:pack(40051, Data)};

write (40052,[
    EndTime,
    Type,
    TargetId,
    CombatPower
]) ->
    Data = <<
        EndTime:32,
        Type:8,
        TargetId:64,
        CombatPower:64
    >>,
    {ok, pt:pack(40052, Data)};

write (40053,[
    Code,
    Door
]) ->
    Data = <<
        Code:32,
        Door:8
    >>,
    {ok, pt:pack(40053, Data)};

write (40054,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(40054, Data)};

write (40055,[
    Type,
    Level,
    Door,
    NotifyTimes,
    IsWin,
    ScoreAdd,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Type:8,
        Level:8,
        Door:8,
        NotifyTimes:8,
        IsWin:8,
        ScoreAdd:16,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(40055, Data)};

write (40056,[
    ChallengeList
]) ->
    BinList_ChallengeList = [
        item_to_bin_10(ChallengeList_Item) || ChallengeList_Item <- ChallengeList
    ], 

    ChallengeList_Len = length(ChallengeList), 
    Bin_ChallengeList = list_to_binary(BinList_ChallengeList),

    Data = <<
        ChallengeList_Len:16, Bin_ChallengeList/binary
    >>,
    {ok, pt:pack(40056, Data)};

write (40057,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(40057, Data)};

write (40058,[
    NotifyList
]) ->
    BinList_NotifyList = [
        item_to_bin_11(NotifyList_Item) || NotifyList_Item <- NotifyList
    ], 

    NotifyList_Len = length(NotifyList), 
    Bin_NotifyList = list_to_binary(BinList_NotifyList),

    Data = <<
        NotifyList_Len:16, Bin_NotifyList/binary
    >>,
    {ok, pt:pack(40058, Data)};

write (40060,[
    RoleId,
    RoleName,
    RoleLv,
    RoleCareer,
    RoleSex,
    RolePic,
    RolePicVer,
    BossType,
    BossTypeName,
    BossId,
    Layer,
    SceneId,
    X,
    Y
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_RolePic = pt:write_string(RolePic), 

    Bin_BossTypeName = pt:write_string(BossTypeName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        RoleLv:16,
        RoleCareer:8,
        RoleSex:8,
        Bin_RolePic/binary,
        RolePicVer:32,
        BossType:16,
        Bin_BossTypeName/binary,
        BossId:32,
        Layer:8,
        SceneId:32,
        X:16,
        Y:16
    >>,
    {ok, pt:pack(40060, Data)};

write (40061,[
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_12(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(40061, Data)};

write (40062,[
    ErrorCode,
    GuildId
]) ->
    Data = <<
        ErrorCode:32,
        GuildId:64
    >>,
    {ok, pt:pack(40062, Data)};

write (40063,[
    ErrorCode,
    GuildId
]) ->
    Data = <<
        ErrorCode:32,
        GuildId:64
    >>,
    {ok, pt:pack(40063, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GuildId,
    GuildName,
    GuildLv,
    GuildExp,
    ChiefId,
    ChiefName,
    MemberNum,
    MemberCapacity,
    IsApply,
    AutoApprovePower,
    CombatPower,
    MergeStatus,
    IsMaster
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_ChiefName = pt:write_string(ChiefName), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        GuildLv:16,
        GuildExp:32,
        ChiefId:64,
        Bin_ChiefName/binary,
        MemberNum:16,
        MemberCapacity:16,
        IsApply:8,
        AutoApprovePower:32,
        CombatPower:64,
        MergeStatus:8,
        IsMaster:8
    >>,
    Data.
item_to_bin_1 ({
    Position,
    RoleId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Position:8,
        RoleId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    Figure,
    Position,
    TitleId,
    CombatPower,
    OnlineFlag,
    OfflineTime,
    CreateTime
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        Position:8,
        TitleId:32,
        CombatPower:64,
        OnlineFlag:8,
        OfflineTime:32,
        CreateTime:32
    >>,
    Data.
item_to_bin_3 ({
    RoleId,
    Figure,
    CombatPower
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        CombatPower:64
    >>,
    Data.
item_to_bin_4 (
    PermissionType
) ->
    Data = <<
        PermissionType:8
    >>,
    Data.
item_to_bin_5 ({
    GiftId,
    GiftStatus
}) ->
    Data = <<
        GiftId:16,
        GiftStatus:8
    >>,
    Data.
item_to_bin_6 ({
    DonateId,
    RoleId,
    RoleName,
    DonateType,
    Times,
    DonateAdd,
    GfundsAdd,
    GuildActivity,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        DonateId:32,
        RoleId:64,
        Bin_RoleName/binary,
        DonateType:8,
        Times:8,
        DonateAdd:16,
        GfundsAdd:16,
        GuildActivity:16,
        Time:32
    >>,
    Data.
item_to_bin_7 ({
    DonateId,
    RoleId,
    RoleName,
    DonateType,
    Times,
    DonateAdd,
    GfundsAdd,
    GuildActivity,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        DonateId:32,
        RoleId:64,
        Bin_RoleName/binary,
        DonateType:8,
        Times:8,
        DonateAdd:16,
        GfundsAdd:16,
        GuildActivity:16,
        Time:32
    >>,
    Data.
item_to_bin_8 ({
    SkillId,
    LearnLv,
    ResearchLv,
    CurPower,
    NextPower
}) ->
    Data = <<
        SkillId:32,
        LearnLv:8,
        ResearchLv:8,
        CurPower:64,
        NextPower:64
    >>,
    Data.
item_to_bin_9 ({
    GiftId,
    GiftStatus
}) ->
    Data = <<
        GiftId:16,
        GiftStatus:8
    >>,
    Data.
item_to_bin_10 ({
    RoleId,
    RoleName,
    Level,
    RoleScore
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Level:8,
        RoleScore:32
    >>,
    Data.
item_to_bin_11 ({
    Id,
    RoleId,
    RoleName,
    Level,
    Door,
    Type,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Id:32,
        RoleId:64,
        Bin_RoleName/binary,
        Level:8,
        Door:8,
        Type:8,
        Time:32
    >>,
    Data.
item_to_bin_12 ({
    GuildId,
    GuildName,
    GuildLv,
    GuildExp,
    ChiefId,
    ChiefName,
    MemberNum,
    MemberCapacity,
    IsApply,
    AutoApprovePower,
    CombatPower,
    MergeStatus,
    IsMaster
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_ChiefName = pt:write_string(ChiefName), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        GuildLv:16,
        GuildExp:32,
        ChiefId:64,
        Bin_ChiefName/binary,
        MemberNum:16,
        MemberCapacity:16,
        IsApply:8,
        AutoApprovePower:32,
        CombatPower:64,
        MergeStatus:8,
        IsMaster:8
    >>,
    Data.
