-module(pt_650).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(65000, _) ->
    {ok, []};
read(65001, _) ->
    {ok, []};
read(65002, _) ->
    {ok, []};
read(65003, _) ->
    {ok, []};
read(65004, Bin0) ->
    <<Index:8, _Bin1/binary>> = Bin0, 
    {ok, [Index]};
read(65005, _) ->
    {ok, []};
read(65010, _) ->
    {ok, []};
read(65011, _) ->
    {ok, []};
read(65012, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65014, Bin0) ->
    <<Op:8, _Bin1/binary>> = Bin0, 
    {ok, [Op]};
read(65017, _) ->
    {ok, []};
read(65021, _) ->
    {ok, []};
read(65022, _) ->
    {ok, []};
read(65023, Bin0) ->
    <<Ready:8, _Bin1/binary>> = Bin0, 
    {ok, [Ready]};
read(65024, Bin0) ->
    <<AutoStart:8, _Bin1/binary>> = Bin0, 
    {ok, [AutoStart]};
read(65030, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65038, _) ->
    {ok, []};
read(65039, Bin0) ->
    <<Page:8, _Bin1/binary>> = Bin0, 
    {ok, [Page]};
read(65040, _) ->
    {ok, []};
read(65041, Bin0) ->
    <<Range:8, _Bin1/binary>> = Bin0, 
    {ok, [Range]};
read(65042, Bin0) ->
    <<Behavior:8, Bin1/binary>> = Bin0, 
    <<TowerId:8, _Bin2/binary>> = Bin1, 
    {ok, [Behavior, TowerId]};
read(65043, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65044, _) ->
    {ok, []};
read(65045, _) ->
    {ok, []};
read(65047, Bin0) ->
    <<Id:8, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(65049, Bin0) ->
    {Name, _Bin1} = pt:read_string(Bin0), 
    {ok, [Name]};
read(65050, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65051, _) ->
    {ok, []};
read(65052, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65053, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(65054, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(65055, _) ->
    {ok, []};
read(65056, _) ->
    {ok, []};
read(65057, _) ->
    {ok, []};
read(65058, Bin0) ->
    {Name, _Bin1} = pt:read_string(Bin0), 
    {ok, [Name]};
read(65059, _) ->
    {ok, []};
read(65060, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Type]};
read(65061, _) ->
    {ok, []};
read(65062, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(65064, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65065, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(65066, _) ->
    {ok, []};
read(65067, Bin0) ->
    <<Res:8, _Bin1/binary>> = Bin0, 
    {ok, [Res]};
read(65071, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65073, _) ->
    {ok, []};
read(65075, _) ->
    {ok, []};
read(65076, _) ->
    {ok, []};
read(65077, _) ->
    {ok, []};
read(65078, _) ->
    {ok, []};
read(65079, _) ->
    {ok, []};
read(65080, Bin0) ->
    <<Turn:8, Bin1/binary>> = Bin0, 
    <<TeamAId:64, Bin2/binary>> = Bin1, 
    <<TeamBId:64, Bin3/binary>> = Bin2, 
    <<Opt:8, Bin4/binary>> = Bin3, 
    <<CostType:32, Bin5/binary>> = Bin4, 
    <<CostNum:32, _Bin6/binary>> = Bin5, 
    {ok, [Turn, TeamAId, TeamBId, Opt, CostType, CostNum]};
read(65081, _) ->
    {ok, []};
read(65082, _) ->
    {ok, []};
read(65083, Bin0) ->
    <<Turn:8, Bin1/binary>> = Bin0, 
    <<TeamAId:64, Bin2/binary>> = Bin1, 
    <<TeamBId:64, Bin3/binary>> = Bin2, 
    <<Time:32, _Bin4/binary>> = Bin3, 
    {ok, [Turn, TeamAId, TeamBId, Time]};
read(65084, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65085, Bin0) ->
    <<TeamAId:64, Bin1/binary>> = Bin0, 
    <<TeamBId:64, _Bin2/binary>> = Bin1, 
    {ok, [TeamAId, TeamBId]};
read(65086, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65087, Bin0) ->
    <<TeamId:64, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(65088, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (65000,[
    GradeNum,
    StartNum,
    SerialWin,
    DailyWin,
    DailyCount,
    SeasonWin,
    SeasonCount,
    RewardInfos,
    HonorValue,
    YesterdayTier,
    ChampionRank,
    TodayGet,
    SeasonEndTime,
    ActEndTime,
    MatchingStatus
]) ->
    BinList_RewardInfos = [
        item_to_bin_0(RewardInfos_Item) || RewardInfos_Item <- RewardInfos
    ], 

    RewardInfos_Len = length(RewardInfos), 
    Bin_RewardInfos = list_to_binary(BinList_RewardInfos),

    Data = <<
        GradeNum:8,
        StartNum:16,
        SerialWin:8,
        DailyWin:8,
        DailyCount:8,
        SeasonWin:32,
        SeasonCount:32,
        RewardInfos_Len:16, Bin_RewardInfos/binary,
        HonorValue:32,
        YesterdayTier:32,
        ChampionRank:32,
        TodayGet:8,
        SeasonEndTime:32,
        ActEndTime:32,
        MatchingStatus:8
    >>,
    {ok, pt:pack(65000, Data)};

write (65001,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65001, Data)};



write (65003,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(65003, Data)};

write (65004,[
    Res,
    Index
]) ->
    Data = <<
        Res:32,
        Index:8
    >>,
    {ok, pt:pack(65004, Data)};

write (65005,[
    Time
]) ->
    Data = <<
        Time:32
    >>,
    {ok, pt:pack(65005, Data)};

write (65010,[
    Res,
    TeamId,
    PowerLimit,
    LvLimit,
    TeamPsw,
    AutoStart,
    LeaderId,
    Members
]) ->
    BinList_Members = [
        item_to_bin_1(Members_Item) || Members_Item <- Members
    ], 

    Members_Len = length(Members), 
    Bin_Members = list_to_binary(BinList_Members),

    Data = <<
        Res:32,
        TeamId:64,
        PowerLimit:32,
        LvLimit:16,
        TeamPsw:32,
        AutoStart:8,
        LeaderId:64,
        Members_Len:16, Bin_Members/binary
    >>,
    {ok, pt:pack(65010, Data)};

write (65011,[
    Res,
    TeamList
]) ->
    BinList_TeamList = [
        item_to_bin_2(TeamList_Item) || TeamList_Item <- TeamList
    ], 

    TeamList_Len = length(TeamList), 
    Bin_TeamList = list_to_binary(BinList_TeamList),

    Data = <<
        Res:32,
        TeamList_Len:16, Bin_TeamList/binary
    >>,
    {ok, pt:pack(65011, Data)};

write (65012,[
    Res,
    TeamId,
    LeaderServName,
    LeaderServNum,
    LeaderId,
    LeaderName,
    LeaderLv,
    LeaderPower,
    TeamNum,
    PowerLimit,
    LvLimit,
    NeedPsw,
    AutoStart
]) ->
    Bin_LeaderServName = pt:write_string(LeaderServName), 

    Bin_LeaderName = pt:write_string(LeaderName), 

    Data = <<
        Res:32,
        TeamId:64,
        Bin_LeaderServName/binary,
        LeaderServNum:16,
        LeaderId:64,
        Bin_LeaderName/binary,
        LeaderLv:16,
        LeaderPower:64,
        TeamNum:8,
        PowerLimit:32,
        LvLimit:16,
        NeedPsw:8,
        AutoStart:8
    >>,
    {ok, pt:pack(65012, Data)};

write (65014,[
    Res,
    Op
]) ->
    Data = <<
        Res:32,
        Op:8
    >>,
    {ok, pt:pack(65014, Data)};

write (65017,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(65017, Data)};

write (65021,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(65021, Data)};

write (65022,[
    Res,
    ServerName,
    ServerNum,
    RoleId
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        Res:32,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64
    >>,
    {ok, pt:pack(65022, Data)};

write (65023,[
    Res,
    Ready
]) ->
    Data = <<
        Res:32,
        Ready:8
    >>,
    {ok, pt:pack(65023, Data)};

write (65024,[
    Res,
    AutoStart
]) ->
    Data = <<
        Res:32,
        AutoStart:8
    >>,
    {ok, pt:pack(65024, Data)};

write (65025,[
    ServerName,
    ServerNum,
    RoleId,
    RoleName
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(65025, Data)};

write (65026,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(65026, Data)};

write (65027,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(65027, Data)};

write (65029,[
    TeamList
]) ->
    BinList_TeamList = [
        item_to_bin_4(TeamList_Item) || TeamList_Item <- TeamList
    ], 

    TeamList_Len = length(TeamList), 
    Bin_TeamList = list_to_binary(BinList_TeamList),

    Data = <<
        TeamList_Len:16, Bin_TeamList/binary
    >>,
    {ok, pt:pack(65029, Data)};

write (65030,[
    Res,
    EndTime,
    Score,
    TeamId,
    ProgressRate,
    EnemyScore,
    EnemyTeamId
]) ->
    BinList_ProgressRate = [
        item_to_bin_5(ProgressRate_Item) || ProgressRate_Item <- ProgressRate
    ], 

    ProgressRate_Len = length(ProgressRate), 
    Bin_ProgressRate = list_to_binary(BinList_ProgressRate),

    Data = <<
        Res:32,
        EndTime:16,
        Score:16,
        TeamId:64,
        ProgressRate_Len:16, Bin_ProgressRate/binary,
        EnemyScore:16,
        EnemyTeamId:64
    >>,
    {ok, pt:pack(65030, Data)};

write (65031,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(65031, Data)};

write (65032,[
    TeamId,
    ServerName,
    ServerNum,
    RoleId
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        TeamId:64,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64
    >>,
    {ok, pt:pack(65032, Data)};

write (65033,[
    TeamId,
    ServerName,
    ServerNum,
    RoleId
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        TeamId:64,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64
    >>,
    {ok, pt:pack(65033, Data)};

write (65035,[
    Score1,
    Score2
]) ->
    Data = <<
        Score1:16,
        Score2:16
    >>,
    {ok, pt:pack(65035, Data)};

write (65036,[
    ServerName,
    ServerNum,
    RoleId,
    KillCount,
    DieCount,
    HoldCount
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        KillCount:16,
        DieCount:16,
        HoldCount:16
    >>,
    {ok, pt:pack(65036, Data)};

write (65037,[
    Type,
    WinSide,
    RedPoint,
    BluePoint,
    HoldCount1,
    RoleList1,
    HoldCount2,
    RoleList2,
    StartNum,
    SerialWin,
    HonorValue,
    TierId
]) ->
    BinList_RoleList1 = [
        item_to_bin_6(RoleList1_Item) || RoleList1_Item <- RoleList1
    ], 

    RoleList1_Len = length(RoleList1), 
    Bin_RoleList1 = list_to_binary(BinList_RoleList1),

    BinList_RoleList2 = [
        item_to_bin_7(RoleList2_Item) || RoleList2_Item <- RoleList2
    ], 

    RoleList2_Len = length(RoleList2), 
    Bin_RoleList2 = list_to_binary(BinList_RoleList2),

    Data = <<
        Type:8,
        WinSide:8,
        RedPoint:32,
        BluePoint:32,
        HoldCount1:8,
        RoleList1_Len:16, Bin_RoleList1/binary,
        HoldCount2:8,
        RoleList2_Len:16, Bin_RoleList2/binary,
        StartNum:16,
        SerialWin:8,
        HonorValue:16,
        TierId:32
    >>,
    {ok, pt:pack(65037, Data)};

write (65038,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_8(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(65038, Data)};

write (65039,[
    Page,
    RoleList,
    YesterdayGrade,
    YesterdayStart,
    Rank,
    GradeReward
]) ->
    BinList_RoleList = [
        item_to_bin_9(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        Page:8,
        RoleList_Len:16, Bin_RoleList/binary,
        YesterdayGrade:8,
        YesterdayStart:16,
        Rank:16,
        GradeReward:32
    >>,
    {ok, pt:pack(65039, Data)};







write (65043,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_10(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(65043, Data)};

write (65044,[
    TowerId,
    TeamGroup,
    Type,
    EndTime,
    Rate
]) ->
    Data = <<
        TowerId:32,
        TeamGroup:8,
        Type:8,
        EndTime:32,
        Rate:32
    >>,
    {ok, pt:pack(65044, Data)};

write (65045,[
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_11(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(65045, Data)};

write (65047,[
    Id,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Id:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(65047, Data)};

write (65048,[
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
    {ok, pt:pack(65048, Data)};

write (65049,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65049, Data)};

write (65050,[
    TeamId,
    Code
]) ->
    Data = <<
        TeamId:64,
        Code:32
    >>,
    {ok, pt:pack(65050, Data)};

write (65051,[
    TeamList
]) ->
    BinList_TeamList = [
        item_to_bin_12(TeamList_Item) || TeamList_Item <- TeamList
    ], 

    TeamList_Len = length(TeamList), 
    Bin_TeamList = list_to_binary(BinList_TeamList),

    Data = <<
        TeamList_Len:16, Bin_TeamList/binary
    >>,
    {ok, pt:pack(65051, Data)};

write (65052,[
    TeamId,
    Flag,
    TeamName,
    LeaderId,
    MatchCount,
    WinCount,
    Point,
    Status,
    Rank,
    RankLv,
    Power,
    ChangeName,
    Members
]) ->
    Bin_TeamName = pt:write_string(TeamName), 

    BinList_Members = [
        item_to_bin_13(Members_Item) || Members_Item <- Members
    ], 

    Members_Len = length(Members), 
    Bin_Members = list_to_binary(BinList_Members),

    Data = <<
        TeamId:64,
        Flag:8,
        Bin_TeamName/binary,
        LeaderId:64,
        MatchCount:32,
        WinCount:32,
        Point:32,
        Status:8,
        Rank:32,
        RankLv:32,
        Power:64,
        ChangeName:8,
        Members_Len:16, Bin_Members/binary
    >>,
    {ok, pt:pack(65052, Data)};

write (65053,[
    RoleId,
    Code
]) ->
    Data = <<
        RoleId:64,
        Code:32
    >>,
    {ok, pt:pack(65053, Data)};

write (65054,[
    RoleId,
    Code
]) ->
    Data = <<
        RoleId:64,
        Code:32
    >>,
    {ok, pt:pack(65054, Data)};

write (65055,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65055, Data)};

write (65056,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65056, Data)};

write (65057,[
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_14(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(65057, Data)};

write (65058,[
    Name,
    Code
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Bin_Name/binary,
        Code:32
    >>,
    {ok, pt:pack(65058, Data)};

write (65059,[
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
    {ok, pt:pack(65059, Data)};

write (65060,[
    RoleId,
    Type,
    Code
]) ->
    Data = <<
        RoleId:64,
        Type:8,
        Code:32
    >>,
    {ok, pt:pack(65060, Data)};

write (65061,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65061, Data)};

write (65062,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65062, Data)};

write (65063,[
    LeaderId,
    LeaderName,
    TeamId,
    TeamName
]) ->
    Bin_LeaderName = pt:write_string(LeaderName), 

    Bin_TeamName = pt:write_string(TeamName), 

    Data = <<
        LeaderId:64,
        Bin_LeaderName/binary,
        TeamId:64,
        Bin_TeamName/binary
    >>,
    {ok, pt:pack(65063, Data)};

write (65064,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65064, Data)};

write (65065,[
    Type,
    ArrayList
]) ->
    BinList_ArrayList = [
        item_to_bin_16(ArrayList_Item) || ArrayList_Item <- ArrayList
    ], 

    ArrayList_Len = length(ArrayList), 
    Bin_ArrayList = list_to_binary(BinList_ArrayList),

    Data = <<
        Type:8,
        ArrayList_Len:16, Bin_ArrayList/binary
    >>,
    {ok, pt:pack(65065, Data)};

write (65066,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(65066, Data)};

write (65067,[
    ErrorCode,
    Res
]) ->
    Data = <<
        ErrorCode:32,
        Res:8
    >>,
    {ok, pt:pack(65067, Data)};

write (65068,[
    RoleId,
    RoleName,
    Res
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Res:8
    >>,
    {ok, pt:pack(65068, Data)};

write (65069,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(65069, Data)};

write (65070,[
    ServerId,
    ServerNum,
    RoleId,
    RoleName,
    CombatPower,
    Lv,
    Picture,
    PictureId,
    Career
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        ServerId:32,
        ServerNum:32,
        RoleId:64,
        Bin_RoleName/binary,
        CombatPower:64,
        Lv:32,
        Bin_Picture/binary,
        PictureId:32,
        Career:8
    >>,
    {ok, pt:pack(65070, Data)};

write (65071,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_17(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(65071, Data)};

write (65072,[
    TeamId,
    Type
]) ->
    Data = <<
        TeamId:64,
        Type:8
    >>,
    {ok, pt:pack(65072, Data)};

write (65073,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65073, Data)};

write (65074,[
    RoleId,
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(65074, Data)};

write (65075,[
    StartTime,
    TeamList
]) ->
    BinList_TeamList = [
        item_to_bin_18(TeamList_Item) || TeamList_Item <- TeamList
    ], 

    TeamList_Len = length(TeamList), 
    Bin_TeamList = list_to_binary(BinList_TeamList),

    Data = <<
        StartTime:32,
        TeamList_Len:16, Bin_TeamList/binary
    >>,
    {ok, pt:pack(65075, Data)};





write (65078,[
    Turn,
    WinCount,
    Num,
    Stage,
    WheelSpace,
    StageEndTime
]) ->
    Data = <<
        Turn:8,
        WinCount:8,
        Num:8,
        Stage:8,
        WheelSpace:8,
        StageEndTime:32
    >>,
    {ok, pt:pack(65078, Data)};

write (65079,[
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(65079, Data)};

write (65080,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65080, Data)};

write (65081,[
    Turn,
    GuessList
]) ->
    BinList_GuessList = [
        item_to_bin_19(GuessList_Item) || GuessList_Item <- GuessList
    ], 

    GuessList_Len = length(GuessList), 
    Bin_GuessList = list_to_binary(BinList_GuessList),

    Data = <<
        Turn:8,
        GuessList_Len:16, Bin_GuessList/binary
    >>,
    {ok, pt:pack(65081, Data)};

write (65082,[
    GuessList
]) ->
    BinList_GuessList = [
        item_to_bin_20(GuessList_Item) || GuessList_Item <- GuessList
    ], 

    GuessList_Len = length(GuessList), 
    Bin_GuessList = list_to_binary(BinList_GuessList),

    Data = <<
        GuessList_Len:16, Bin_GuessList/binary
    >>,
    {ok, pt:pack(65082, Data)};

write (65083,[
    Code,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(65083, Data)};

write (65084,[
    TeamId,
    TeamName,
    LeaderId,
    MatchCount,
    WinCount,
    Rank,
    RankLv,
    Point,
    Power,
    Members
]) ->
    Bin_TeamName = pt:write_string(TeamName), 

    BinList_Members = [
        item_to_bin_21(Members_Item) || Members_Item <- Members
    ], 

    Members_Len = length(Members), 
    Bin_Members = list_to_binary(BinList_Members),

    Data = <<
        TeamId:64,
        Bin_TeamName/binary,
        LeaderId:64,
        MatchCount:32,
        WinCount:32,
        Rank:32,
        RankLv:32,
        Point:32,
        Power:64,
        Members_Len:16, Bin_Members/binary
    >>,
    {ok, pt:pack(65084, Data)};

write (65085,[
    TeamList
]) ->
    BinList_TeamList = [
        item_to_bin_22(TeamList_Item) || TeamList_Item <- TeamList
    ], 

    TeamList_Len = length(TeamList), 
    Bin_TeamList = list_to_binary(BinList_TeamList),

    Data = <<
        TeamList_Len:16, Bin_TeamList/binary
    >>,
    {ok, pt:pack(65085, Data)};

write (65086,[
    Code,
    TeamId,
    OtherTeamId,
    LeaderAId,
    LeaderBId
]) ->
    Data = <<
        Code:32,
        TeamId:64,
        OtherTeamId:64,
        LeaderAId:64,
        LeaderBId:64
    >>,
    {ok, pt:pack(65086, Data)};



write (65088,[
    Code,
    Stage,
    EndTime
]) ->
    Data = <<
        Code:32,
        Stage:8,
        EndTime:32
    >>,
    {ok, pt:pack(65088, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Index,
    Status
}) ->
    Data = <<
        Index:8,
        Status:32
    >>,
    Data.
item_to_bin_1 ({
    ServerName,
    ServerNum,
    ServerId,
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Power,
    Fashion,
    Weapon,
    Wing,
    Leader,
    Ready
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_ServerName/binary,
        ServerNum:16,
        ServerId:16,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Power:64,
        Fashion:32,
        Weapon:16,
        Wing:16,
        Leader:8,
        Ready:8
    >>,
    Data.
item_to_bin_2 ({
    TeamId,
    LeaderServName,
    LeaderServNum,
    LeaderId,
    LeaderName,
    LeaderLv,
    LeaderPower,
    TeamNum,
    PowerLimit,
    LvLimit,
    NeedPsw,
    AutoStart,
    CareerList
}) ->
    Bin_LeaderServName = pt:write_string(LeaderServName), 

    Bin_LeaderName = pt:write_string(LeaderName), 

    BinList_CareerList = [
        item_to_bin_3(CareerList_Item) || CareerList_Item <- CareerList
    ], 

    CareerList_Len = length(CareerList), 
    Bin_CareerList = list_to_binary(BinList_CareerList),

    Data = <<
        TeamId:64,
        Bin_LeaderServName/binary,
        LeaderServNum:16,
        LeaderId:64,
        Bin_LeaderName/binary,
        LeaderLv:16,
        LeaderPower:32,
        TeamNum:8,
        PowerLimit:64,
        LvLimit:16,
        NeedPsw:8,
        AutoStart:8,
        CareerList_Len:16, Bin_CareerList/binary
    >>,
    Data.
item_to_bin_3 (
    Career
) ->
    Data = <<
        Career:8
    >>,
    Data.
item_to_bin_4 ({
    TeamId,
    ServerName,
    ServerNum,
    RoleId,
    RoleName,
    Power,
    VipLv,
    Career,
    Sex,
    Lv,
    Turn,
    Picture,
    PictureId
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        TeamId:64,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        Power:64,
        VipLv:8,
        Career:8,
        Sex:8,
        Lv:16,
        Turn:8,
        Bin_Picture/binary,
        PictureId:32
    >>,
    Data.
item_to_bin_5 ({
    TeamGroup,
    TowerId,
    Rate
}) ->
    Data = <<
        TeamGroup:8,
        TowerId:8,
        Rate:16
    >>,
    Data.
item_to_bin_6 ({
    ServerName,
    ServerNum,
    RoleId,
    RoleName,
    Career,
    Sex,
    Lv,
    Turn,
    Power,
    KillCount,
    AssistCount,
    DieCount,
    HoldCount,
    Mvp
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Lv:16,
        Turn:8,
        Power:64,
        KillCount:16,
        AssistCount:16,
        DieCount:16,
        HoldCount:16,
        Mvp:8
    >>,
    Data.
item_to_bin_7 ({
    ServerName,
    ServerNum,
    RoleId,
    RoleName,
    Career,
    Sex,
    Lv,
    Turn,
    Power,
    KillCount,
    AssistCount,
    DieCount,
    HoldCount,
    Mvp
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Lv:16,
        Turn:8,
        Power:64,
        KillCount:16,
        AssistCount:16,
        DieCount:16,
        HoldCount:16,
        Mvp:8
    >>,
    Data.
item_to_bin_8 ({
    Rank,
    TierId,
    ServerName,
    ServerNum,
    RoleName,
    StartNum
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        TierId:16,
        Bin_ServerName/binary,
        ServerNum:16,
        Bin_RoleName/binary,
        StartNum:16
    >>,
    Data.
item_to_bin_9 ({
    ServerName,
    ServerNum,
    ServerId,
    RoleId,
    RoleName,
    Career,
    Sex,
    GradeNum,
    StartNum,
    Power
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_ServerName/binary,
        ServerNum:16,
        ServerId:16,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        GradeNum:8,
        StartNum:16,
        Power:64
    >>,
    Data.
item_to_bin_10 ({
    TeamGroup,
    ServerName,
    ServerNum,
    RoleId,
    RoleName,
    Power,
    Career,
    Sex,
    Lv,
    Turn,
    KillCount,
    AssistCount,
    ContinuousKillCount,
    DieCount
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        TeamGroup:8,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        Power:64,
        Career:8,
        Sex:8,
        Lv:16,
        Turn:8,
        KillCount:16,
        AssistCount:16,
        ContinuousKillCount:16,
        DieCount:16
    >>,
    Data.
item_to_bin_11 ({
    Id,
    Status
}) ->
    Data = <<
        Id:8,
        Status:8
    >>,
    Data.
item_to_bin_12 ({
    TeamId,
    TeamName,
    Point,
    LeaderId,
    LeaderName,
    Num,
    Rank,
    Status
}) ->
    Bin_TeamName = pt:write_string(TeamName), 

    Bin_LeaderName = pt:write_string(LeaderName), 

    Data = <<
        TeamId:64,
        Bin_TeamName/binary,
        Point:32,
        LeaderId:64,
        Bin_LeaderName/binary,
        Num:8,
        Rank:32,
        Status:8
    >>,
    Data.
item_to_bin_13 ({
    ServerId,
    ServerName,
    ServerNum,
    RoleId,
    RoleName,
    OnLine,
    Leader
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerId:32,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        OnLine:8,
        Leader:8
    >>,
    Data.
item_to_bin_14 ({
    TeamId,
    Rank,
    LeaderId,
    LeaderName,
    ServerNum,
    ServerName,
    TeamName,
    Power,
    Point
}) ->
    Bin_LeaderName = pt:write_string(LeaderName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_TeamName = pt:write_string(TeamName), 

    Data = <<
        TeamId:64,
        Rank:32,
        LeaderId:64,
        Bin_LeaderName/binary,
        ServerNum:32,
        Bin_ServerName/binary,
        Bin_TeamName/binary,
        Power:64,
        Point:32
    >>,
    Data.
item_to_bin_15 ({
    RoleId,
    RoleName,
    Picture,
    PictureId,
    Career,
    Lv,
    CombatPower
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Bin_Picture/binary,
        PictureId:32,
        Career:8,
        Lv:32,
        CombatPower:64
    >>,
    Data.
item_to_bin_16 ({
    RoleId,
    RoleName,
    Picture,
    PictureId,
    Career,
    Lv,
    CombatPower
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Bin_Picture/binary,
        PictureId:32,
        Career:8,
        Lv:32,
        CombatPower:64
    >>,
    Data.
item_to_bin_17 (
    RoleId
) ->
    Data = <<
        RoleId:64
    >>,
    Data.
item_to_bin_18 ({
    TeamId,
    TeamName,
    ServerId,
    ServerNum,
    ServerName,
    Pos,
    WinCount
}) ->
    Bin_TeamName = pt:write_string(TeamName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        TeamId:64,
        Bin_TeamName/binary,
        ServerId:32,
        ServerNum:32,
        Bin_ServerName/binary,
        Pos:8,
        WinCount:8
    >>,
    Data.
item_to_bin_19 ({
    TeamAId,
    TeamBId,
    TeamAName,
    TeamBName,
    Opt,
    CostType,
    CostNum
}) ->
    Bin_TeamAName = pt:write_string(TeamAName), 

    Bin_TeamBName = pt:write_string(TeamBName), 

    Data = <<
        TeamAId:64,
        TeamBId:64,
        Bin_TeamAName/binary,
        Bin_TeamBName/binary,
        Opt:8,
        CostType:32,
        CostNum:32
    >>,
    Data.
item_to_bin_20 ({
    Turn,
    TeamAId,
    TeamBId,
    TeamAName,
    TeamBName,
    Opt,
    Result,
    RewardType,
    RewardNum,
    RightResult,
    Status,
    Time
}) ->
    Bin_TeamAName = pt:write_string(TeamAName), 

    Bin_TeamBName = pt:write_string(TeamBName), 

    Data = <<
        Turn:8,
        TeamAId:64,
        TeamBId:64,
        Bin_TeamAName/binary,
        Bin_TeamBName/binary,
        Opt:8,
        Result:8,
        RewardType:32,
        RewardNum:32,
        RightResult:8,
        Status:8,
        Time:32
    >>,
    Data.
item_to_bin_21 ({
    ServerId,
    ServerName,
    ServerNum,
    RoleId,
    Leader
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:32,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Leader:8
    >>,
    Data.
item_to_bin_22 ({
    TeamName,
    TeamId,
    ServerName,
    ServerNum,
    RoleId,
    RoleName,
    Power,
    VipLv,
    Career,
    Sex,
    Lv,
    Turn,
    Picture,
    PictureId
}) ->
    Bin_TeamName = pt:write_string(TeamName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        Bin_TeamName/binary,
        TeamId:64,
        Bin_ServerName/binary,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        Power:32,
        VipLv:8,
        Career:8,
        Sex:8,
        Lv:16,
        Turn:8,
        Bin_Picture/binary,
        PictureId:32
    >>,
    Data.
