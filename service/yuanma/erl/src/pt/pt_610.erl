-module(pt_610).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(61001, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61002, _) ->
    {ok, []};
read(61003, _) ->
    {ok, []};
read(61004, _) ->
    {ok, []};
read(61006, Bin0) ->
    <<EventTypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [EventTypeId]};
read(61007, Bin0) ->
    <<X:16, Bin1/binary>> = Bin0, 
    <<Y:16, _Bin2/binary>> = Bin1, 
    {ok, [X, Y]};
read(61010, Bin0) ->
    <<StoryId:32, Bin1/binary>> = Bin0, 
    <<SubSotryId:32, Bin2/binary>> = Bin1, 
    <<IsEnd:8, _Bin3/binary>> = Bin2, 
    {ok, [StoryId, SubSotryId, IsEnd]};
read(61011, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61013, _) ->
    {ok, []};
read(61014, _) ->
    {ok, []};
read(61015, _) ->
    {ok, []};
read(61016, _) ->
    {ok, []};
read(61017, _) ->
    {ok, []};
read(61018, _) ->
    {ok, []};
read(61019, Bin0) ->
    <<SceneId:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(61020, Bin0) ->
    <<DunType:8, _Bin1/binary>> = Bin0, 
    {ok, [DunType]};
read(61021, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<Count:16, _Bin2/binary>> = Bin1, 
    {ok, [DunId, Count]};
read(61022, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<AutoNum:16, _Bin2/binary>> = Bin1, 
    {ok, [DunId, AutoNum]};
read(61023, _) ->
    {ok, []};
read(61024, _) ->
    {ok, []};
read(61025, Bin0) ->
    <<CostType:8, _Bin1/binary>> = Bin0, 
    {ok, [CostType]};
read(61026, _) ->
    {ok, []};
read(61027, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61028, Bin0) ->
    <<DunType:8, _Bin1/binary>> = Bin0, 
    {ok, [DunType]};
read(61030, _) ->
    {ok, []};
read(61031, _) ->
    {ok, []};
read(61032, _) ->
    {ok, []};
read(61034, _) ->
    {ok, []};
read(61035, _) ->
    {ok, []};
read(61036, _) ->
    {ok, []};
read(61037, _) ->
    {ok, []};
read(61038, Bin0) ->
    <<DunType:8, _Bin1/binary>> = Bin0, 
    {ok, [DunType]};
read(61039, Bin0) ->
    <<PrevId:32, _Bin1/binary>> = Bin0, 
    {ok, [PrevId]};
read(61040, _) ->
    {ok, []};
read(61041, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61042, Bin0) ->
    <<DunType:8, _Bin1/binary>> = Bin0, 
    {ok, [DunType]};
read(61043, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<RewardType:8, _Bin2/binary>> = Bin1, 
    {ok, [DunId, RewardType]};
read(61044, _) ->
    {ok, []};
read(61045, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61046, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<DunId:32, Bin2/binary>> = Bin1, 
    <<OtherId:64, _Bin3/binary>> = Bin2, 
    {ok, [Type, DunId, OtherId]};
read(61047, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<Inviter:64, Bin2/binary>> = Bin1, 
    <<Answer:8, _Bin3/binary>> = Bin2, 
    {ok, [DunId, Inviter, Answer]};
read(61050, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<Wave:8, _Bin2/binary>> = Bin1, 
    {ok, [DunId, Wave]};
read(61051, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61052, _) ->
    {ok, []};
read(61053, _) ->
    {ok, []};
read(61054, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<Wave:8, _Bin2/binary>> = Bin1, 
    {ok, [DunId, Wave]};
read(61055, _) ->
    {ok, []};
read(61056, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(61057, _) ->
    {ok, []};
read(61059, _) ->
    {ok, []};
read(61062, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61063, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<SelectType:8, Bin3/binary>> = Bin2, 
    <<IsOpen:8, Bin4/binary>> = Bin3, 
    <<Count:8, _Bin5/binary>> = Bin4, 
    {ok, [DunId, Type, SelectType, IsOpen, Count]};
read(61064, _) ->
    {ok, []};
read(61066, _) ->
    {ok, []};
read(61088, _) ->
    {ok, []};
read(61089, _) ->
    {ok, []};
read(61090, Bin0) ->
    {Answer, _Bin1} = pt:read_string(Bin0), 
    {ok, [Answer]};
read(61091, _) ->
    {ok, []};
read(61092, Bin0) ->
    <<DunType:8, Bin1/binary>> = Bin0, 
    <<DunId:32, _Bin2/binary>> = Bin1, 
    {ok, [DunType, DunId]};
read(61093, Bin0) ->
    <<DunType:8, Bin1/binary>> = Bin0, 
    <<DunId:32, _Bin2/binary>> = Bin1, 
    {ok, [DunType, DunId]};
read(61094, _) ->
    {ok, []};
read(61095, _) ->
    {ok, []};
read(61096, _) ->
    {ok, []};
read(61097, _) ->
    {ok, []};
read(61098, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (61000,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(61000, Data)};

write (61001,[
    DunId,
    SceneId,
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        DunId:32,
        SceneId:32,
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(61001, Data)};

write (61002,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(61002, Data)};

write (61003,[
    Result,
    ResultSubtype,
    DunId,
    Grade,
    SceneId,
    RewardList,
    OtherReward,
    ExData,
    Count
]) ->
    BinList_RewardList = [
        item_to_bin_0(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_OtherReward = [
        item_to_bin_1(OtherReward_Item) || OtherReward_Item <- OtherReward
    ], 

    OtherReward_Len = length(OtherReward), 
    Bin_OtherReward = list_to_binary(BinList_OtherReward),

    BinList_ExData = [
        item_to_bin_3(ExData_Item) || ExData_Item <- ExData
    ], 

    ExData_Len = length(ExData), 
    Bin_ExData = list_to_binary(BinList_ExData),

    Data = <<
        Result:8,
        ResultSubtype:8,
        DunId:32,
        Grade:8,
        SceneId:32,
        RewardList_Len:16, Bin_RewardList/binary,
        OtherReward_Len:16, Bin_OtherReward/binary,
        ExData_Len:16, Bin_ExData/binary,
        Count:8
    >>,
    {ok, pt:pack(61003, Data)};

write (61004,[
    StartTime,
    StartTimeMs,
    EndTime,
    Level,
    LevelEndTime,
    OwnerId,
    WaveNum
]) ->
    Data = <<
        StartTime:32,
        StartTimeMs:64,
        EndTime:32,
        Level:16,
        LevelEndTime:32,
        OwnerId:64,
        WaveNum:32
    >>,
    {ok, pt:pack(61004, Data)};

write (61005,[
    DunId,
    SceneId,
    Type,
    Time,
    WaveNum
]) ->
    Data = <<
        DunId:32,
        SceneId:32,
        Type:16,
        Time:32,
        WaveNum:32
    >>,
    {ok, pt:pack(61005, Data)};



write (61007,[
    X,
    Y
]) ->
    Data = <<
        X:16,
        Y:16
    >>,
    {ok, pt:pack(61007, Data)};

write (61009,[
    StoryId,
    SubSotryId
]) ->
    Data = <<
        StoryId:32,
        SubSotryId:32
    >>,
    {ok, pt:pack(61009, Data)};



write (61011,[
    DunId,
    LeftHelpCount
]) ->
    Data = <<
        DunId:32,
        LeftHelpCount:8
    >>,
    {ok, pt:pack(61011, Data)};

write (61012,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(61012, Data)};

write (61013,[
    Result,
    HelpType,
    Score,
    PassTime,
    RelaList,
    DropReward,
    RewardList
]) ->
    BinList_RelaList = [
        item_to_bin_4(RelaList_Item) || RelaList_Item <- RelaList
    ], 

    RelaList_Len = length(RelaList), 
    Bin_RelaList = list_to_binary(BinList_RelaList),

    Bin_DropReward = pt:write_object_list(DropReward), 

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Result:8,
        HelpType:8,
        Score:16,
        PassTime:16,
        RelaList_Len:16, Bin_RelaList/binary,
        Bin_DropReward/binary,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61013, Data)};

write (61014,[
    StoryList
]) ->
    BinList_StoryList = [
        item_to_bin_5(StoryList_Item) || StoryList_Item <- StoryList
    ], 

    StoryList_Len = length(StoryList), 
    Bin_StoryList = list_to_binary(BinList_StoryList),

    Data = <<
        StoryList_Len:16, Bin_StoryList/binary
    >>,
    {ok, pt:pack(61014, Data)};

write (61015,[
    DunId,
    SceneId,
    Level,
    IsLastLevel,
    Result,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        DunId:32,
        SceneId:32,
        Level:16,
        IsLastLevel:8,
        Result:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61015, Data)};

write (61016,[
    HelpType,
    Score,
    PassTime,
    LevelList,
    RelaList,
    RewardList
]) ->
    BinList_LevelList = [
        item_to_bin_6(LevelList_Item) || LevelList_Item <- LevelList
    ], 

    LevelList_Len = length(LevelList), 
    Bin_LevelList = list_to_binary(BinList_LevelList),

    BinList_RelaList = [
        item_to_bin_7(RelaList_Item) || RelaList_Item <- RelaList
    ], 

    RelaList_Len = length(RelaList), 
    Bin_RelaList = list_to_binary(BinList_RelaList),

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        HelpType:8,
        Score:16,
        PassTime:16,
        LevelList_Len:16, Bin_LevelList/binary,
        RelaList_Len:16, Bin_RelaList/binary,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61016, Data)};

write (61017,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(61017, Data)};

write (61018,[
    Type,
    EndTime
]) ->
    Data = <<
        Type:8,
        EndTime:32
    >>,
    {ok, pt:pack(61018, Data)};

write (61019,[
    XyList
]) ->
    BinList_XyList = [
        item_to_bin_8(XyList_Item) || XyList_Item <- XyList
    ], 

    XyList_Len = length(XyList), 
    Bin_XyList = list_to_binary(BinList_XyList),

    Data = <<
        XyList_Len:16, Bin_XyList/binary
    >>,
    {ok, pt:pack(61019, Data)};

write (61020,[
    DunType,
    DunList
]) ->
    BinList_DunList = [
        item_to_bin_9(DunList_Item) || DunList_Item <- DunList
    ], 

    DunList_Len = length(DunList), 
    Bin_DunList = list_to_binary(BinList_DunList),

    Data = <<
        DunType:8,
        DunList_Len:16, Bin_DunList/binary
    >>,
    {ok, pt:pack(61020, Data)};

write (61021,[
    ErrorCode,
    DunId,
    BuyCount
]) ->
    Data = <<
        ErrorCode:32,
        DunId:32,
        BuyCount:16
    >>,
    {ok, pt:pack(61021, Data)};

write (61022,[
    ErrorCode,
    DunId,
    Grade,
    LeftCount,
    AutoNum,
    SweepList
]) ->
    BinList_SweepList = [
        item_to_bin_11(SweepList_Item) || SweepList_Item <- SweepList
    ], 

    SweepList_Len = length(SweepList), 
    Bin_SweepList = list_to_binary(BinList_SweepList),

    Data = <<
        ErrorCode:32,
        DunId:32,
        Grade:8,
        LeftCount:16,
        AutoNum:16,
        SweepList_Len:16, Bin_SweepList/binary
    >>,
    {ok, pt:pack(61022, Data)};

write (61023,[
    CurScore,
    NextScore,
    ChangeTime
]) ->
    Data = <<
        CurScore:32,
        NextScore:32,
        ChangeTime:32
    >>,
    {ok, pt:pack(61023, Data)};

write (61024,[
    DunList
]) ->
    BinList_DunList = [
        item_to_bin_15(DunList_Item) || DunList_Item <- DunList
    ], 

    DunList_Len = length(DunList), 
    Bin_DunList = list_to_binary(BinList_DunList),

    Data = <<
        DunList_Len:16, Bin_DunList/binary
    >>,
    {ok, pt:pack(61024, Data)};

write (61025,[
    ErrorCode,
    CoinCount,
    GoldCount
]) ->
    Data = <<
        ErrorCode:32,
        CoinCount:8,
        GoldCount:8
    >>,
    {ok, pt:pack(61025, Data)};

write (61026,[
    CoinCount,
    GoldCount
]) ->
    Data = <<
        CoinCount:8,
        GoldCount:8
    >>,
    {ok, pt:pack(61026, Data)};

write (61027,[
    DunId
]) ->
    Data = <<
        DunId:32
    >>,
    {ok, pt:pack(61027, Data)};

write (61028,[
    DunType,
    SweepList
]) ->
    BinList_SweepList = [
        item_to_bin_16(SweepList_Item) || SweepList_Item <- SweepList
    ], 

    SweepList_Len = length(SweepList), 
    Bin_SweepList = list_to_binary(BinList_SweepList),

    Data = <<
        DunType:8,
        SweepList_Len:16, Bin_SweepList/binary
    >>,
    {ok, pt:pack(61028, Data)};

write (61029,[
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61029, Data)};

write (61030,[
    WaveNum,
    Time
]) ->
    Data = <<
        WaveNum:32,
        Time:32
    >>,
    {ok, pt:pack(61030, Data)};

write (61031,[
    KillCount
]) ->
    Data = <<
        KillCount:32
    >>,
    {ok, pt:pack(61031, Data)};

write (61032,[
    MyRank,
    MyHurt,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_20(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        MyRank:8,
        MyHurt:64,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(61032, Data)};

write (61033,[
    AutoId,
    MonTypeId,
    Hp,
    HpLimit
]) ->
    Data = <<
        AutoId:32,
        MonTypeId:32,
        Hp:64,
        HpLimit:64
    >>,
    {ok, pt:pack(61033, Data)};

write (61034,[
    ObjectList
]) ->
    BinList_ObjectList = [
        item_to_bin_21(ObjectList_Item) || ObjectList_Item <- ObjectList
    ], 

    ObjectList_Len = length(ObjectList), 
    Bin_ObjectList = list_to_binary(BinList_ObjectList),

    Data = <<
        ObjectList_Len:16, Bin_ObjectList/binary
    >>,
    {ok, pt:pack(61034, Data)};

write (61035,[
    DunId,
    WaveList
]) ->
    BinList_WaveList = [
        item_to_bin_22(WaveList_Item) || WaveList_Item <- WaveList
    ], 

    WaveList_Len = length(WaveList), 
    Bin_WaveList = list_to_binary(BinList_WaveList),

    Data = <<
        DunId:32,
        WaveList_Len:16, Bin_WaveList/binary
    >>,
    {ok, pt:pack(61035, Data)};

write (61036,[
    Score
]) ->
    Data = <<
        Score:32
    >>,
    {ok, pt:pack(61036, Data)};

write (61037,[
    TotalList
]) ->
    BinList_TotalList = [
        item_to_bin_23(TotalList_Item) || TotalList_Item <- TotalList
    ], 

    TotalList_Len = length(TotalList), 
    Bin_TotalList = list_to_binary(BinList_TotalList),

    Data = <<
        TotalList_Len:16, Bin_TotalList/binary
    >>,
    {ok, pt:pack(61037, Data)};

write (61038,[
    DunType,
    Available,
    LeftCount,
    MaxCount
]) ->
    Data = <<
        DunType:8,
        Available:8,
        LeftCount:16,
        MaxCount:16
    >>,
    {ok, pt:pack(61038, Data)};



write (61040,[
    Num
]) ->
    Data = <<
        Num:32
    >>,
    {ok, pt:pack(61040, Data)};

write (61041,[
    DunId,
    Exp
]) ->
    Data = <<
        DunId:32,
        Exp:64
    >>,
    {ok, pt:pack(61041, Data)};

write (61042,[
    DunType,
    DunList
]) ->
    BinList_DunList = [
        item_to_bin_24(DunList_Item) || DunList_Item <- DunList
    ], 

    DunList_Len = length(DunList), 
    Bin_DunList = list_to_binary(BinList_DunList),

    Data = <<
        DunType:8,
        DunList_Len:16, Bin_DunList/binary
    >>,
    {ok, pt:pack(61042, Data)};

write (61043,[
    ErrorCode,
    DunId,
    RewardType,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ErrorCode:32,
        DunId:32,
        RewardType:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61043, Data)};

write (61044,[
    KillNum,
    Exp
]) ->
    Data = <<
        KillNum:16,
        Exp:64
    >>,
    {ok, pt:pack(61044, Data)};

write (61045,[
    DunId,
    NextTime
]) ->
    Data = <<
        DunId:32,
        NextTime:32
    >>,
    {ok, pt:pack(61045, Data)};

write (61046,[
    CodeMsg
]) ->
    Bin_CodeMsg = pt:write_string(CodeMsg), 

    Data = <<
        Bin_CodeMsg/binary
    >>,
    {ok, pt:pack(61046, Data)};

write (61047,[
    Code,
    Answer
]) ->
    Data = <<
        Code:32,
        Answer:8
    >>,
    {ok, pt:pack(61047, Data)};

write (61048,[
    Code,
    List,
    DunId
]) ->
    BinList_List = [
        item_to_bin_25(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Code:32,
        List_Len:16, Bin_List/binary,
        DunId:32
    >>,
    {ok, pt:pack(61048, Data)};

write (61049,[
    DunId,
    OtherReward
]) ->
    BinList_OtherReward = [
        item_to_bin_26(OtherReward_Item) || OtherReward_Item <- OtherReward
    ], 

    OtherReward_Len = length(OtherReward), 
    Bin_OtherReward = list_to_binary(BinList_OtherReward),

    Data = <<
        DunId:32,
        OtherReward_Len:16, Bin_OtherReward/binary
    >>,
    {ok, pt:pack(61049, Data)};

write (61050,[
    DunId,
    Wave,
    MyTime,
    BestTime,
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_28(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        DunId:32,
        Wave:8,
        MyTime:32,
        BestTime:32,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(61050, Data)};

write (61051,[
    DunId,
    Wave,
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_29(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        DunId:32,
        Wave:8,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(61051, Data)};

write (61052,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(61052, Data)};

write (61053,[
    QuickCount,
    SumQuickCount,
    NextQuickTime
]) ->
    Data = <<
        QuickCount:16,
        SumQuickCount:16,
        NextQuickTime:32
    >>,
    {ok, pt:pack(61053, Data)};

write (61054,[
    Code,
    DunId,
    Wave
]) ->
    Data = <<
        Code:32,
        DunId:32,
        Wave:8
    >>,
    {ok, pt:pack(61054, Data)};

write (61055,[
    SkillList
]) ->
    BinList_SkillList = [
        item_to_bin_30(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(61055, Data)};

write (61056,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(61056, Data)};

write (61057,[
    DunId,
    EndTime,
    BattleWave,
    CurWave,
    HistoryWave
]) ->
    Data = <<
        DunId:32,
        EndTime:32,
        BattleWave:16,
        CurWave:16,
        HistoryWave:16
    >>,
    {ok, pt:pack(61057, Data)};

write (61058,[
    Wave,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Wave:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61058, Data)};

write (61059,[
    Wave,
    WaveStartTime,
    WaveEndTime,
    HistoryWave,
    Exp
]) ->
    Data = <<
        Wave:32,
        WaveStartTime:32,
        WaveEndTime:32,
        HistoryWave:32,
        Exp:64
    >>,
    {ok, pt:pack(61059, Data)};

write (61060,[
    Wave,
    HistoryWave,
    Exp
]) ->
    Data = <<
        Wave:32,
        HistoryWave:32,
        Exp:64
    >>,
    {ok, pt:pack(61060, Data)};

write (61061,[
    Wave,
    HistoryWave,
    Exp
]) ->
    Data = <<
        Wave:32,
        HistoryWave:32,
        Exp:64
    >>,
    {ok, pt:pack(61061, Data)};

write (61062,[
    DunId,
    SettingList
]) ->
    BinList_SettingList = [
        item_to_bin_31(SettingList_Item) || SettingList_Item <- SettingList
    ], 

    SettingList_Len = length(SettingList), 
    Bin_SettingList = list_to_binary(BinList_SettingList),

    Data = <<
        DunId:32,
        SettingList_Len:16, Bin_SettingList/binary
    >>,
    {ok, pt:pack(61062, Data)};

write (61063,[
    Errcode,
    DunId,
    Type,
    SelectType,
    IsOpen,
    Count
]) ->
    Data = <<
        Errcode:32,
        DunId:32,
        Type:8,
        SelectType:8,
        IsOpen:8,
        Count:8
    >>,
    {ok, pt:pack(61063, Data)};



write (61065,[
    CoinCount,
    GoldCount
]) ->
    Data = <<
        CoinCount:8,
        GoldCount:8
    >>,
    {ok, pt:pack(61065, Data)};

write (61066,[
    WaveNum,
    DeadMonNum,
    MonNum
]) ->
    Data = <<
        WaveNum:32,
        DeadMonNum:32,
        MonNum:32
    >>,
    {ok, pt:pack(61066, Data)};

write (61088,[
    DunId,
    DunType,
    PushType,
    Content
]) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        DunId:32,
        DunType:8,
        PushType:8,
        Bin_Content/binary
    >>,
    {ok, pt:pack(61088, Data)};

write (61089,[
    DunId,
    QuestionId,
    Type,
    EndTime
]) ->
    Data = <<
        DunId:32,
        QuestionId:16,
        Type:8,
        EndTime:32
    >>,
    {ok, pt:pack(61089, Data)};

write (61090,[
    Ret
]) ->
    Data = <<
        Ret:8
    >>,
    {ok, pt:pack(61090, Data)};

write (61091,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(61091, Data)};

write (61092,[
    DunId,
    ErrorCode,
    RewardStatus,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        DunId:32,
        ErrorCode:32,
        RewardStatus:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61092, Data)};

write (61093,[
    DunType,
    DunId,
    DValue,
    NextBornTime,
    EnterTimes,
    EndTime,
    RewardStatus
]) ->
    Data = <<
        DunType:8,
        DunId:32,
        DValue:16,
        NextBornTime:32,
        EnterTimes:8,
        EndTime:32,
        RewardStatus:8
    >>,
    {ok, pt:pack(61093, Data)};

write (61094,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(61094, Data)};

write (61095,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(61095, Data)};

write (61096,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(61096, Data)};

write (61097,[
    State,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        State:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61097, Data)};

write (61098,[
    SexList
]) ->
    BinList_SexList = [
        item_to_bin_32(SexList_Item) || SexList_Item <- SexList
    ], 

    SexList_Len = length(SexList), 
    Bin_SexList = list_to_binary(BinList_SexList),

    Data = <<
        SexList_Len:16, Bin_SexList/binary
    >>,
    {ok, pt:pack(61098, Data)};

write (61099,[
    Result,
    ResultSubtype,
    DunId,
    Grade,
    SceneId,
    RewardList,
    ExRewardList,
    TowerNum
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Bin_ExRewardList = pt:write_object_list(ExRewardList), 

    Data = <<
        Result:8,
        ResultSubtype:8,
        DunId:32,
        Grade:8,
        SceneId:32,
        Bin_RewardList/binary,
        Bin_ExRewardList/binary,
        TowerNum:8
    >>,
    {ok, pt:pack(61099, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Style,
    TypeId,
    Count,
    GoodsId
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:64,
        GoodsId:64
    >>,
    Data.
item_to_bin_1 ({
    RewardType,
    OtherRewardList
}) ->
    BinList_OtherRewardList = [
        item_to_bin_2(OtherRewardList_Item) || OtherRewardList_Item <- OtherRewardList
    ], 

    OtherRewardList_Len = length(OtherRewardList), 
    Bin_OtherRewardList = list_to_binary(BinList_OtherRewardList),

    Data = <<
        RewardType:8,
        OtherRewardList_Len:16, Bin_OtherRewardList/binary
    >>,
    Data.
item_to_bin_2 ({
    Style1,
    TypeId1,
    Count1,
    GoodsId1
}) ->
    Data = <<
        Style1:8,
        TypeId1:32,
        Count1:64,
        GoodsId1:64
    >>,
    Data.
item_to_bin_3 ({
    Key,
    Val
}) ->
    Data = <<
        Key:16,
        Val:32
    >>,
    Data.
item_to_bin_4 ({
    RoleId,
    RelaType,
    Intimacy,
    IsAskAdd,
    GuildId
}) ->
    Data = <<
        RoleId:64,
        RelaType:8,
        Intimacy:32,
        IsAskAdd:8,
        GuildId:64
    >>,
    Data.
item_to_bin_5 ({
    StoryId,
    SubSotryId,
    IsEnd
}) ->
    Data = <<
        StoryId:32,
        SubSotryId:32,
        IsEnd:8
    >>,
    Data.
item_to_bin_6 ({
    Level,
    Score
}) ->
    Data = <<
        Level:16,
        Score:32
    >>,
    Data.
item_to_bin_7 ({
    RoleId,
    RelaType,
    Intimacy,
    IsAskAdd,
    GuildId
}) ->
    Data = <<
        RoleId:64,
        RelaType:8,
        Intimacy:32,
        IsAskAdd:8,
        GuildId:64
    >>,
    Data.
item_to_bin_8 ({
    X,
    Y
}) ->
    Data = <<
        X:32,
        Y:32
    >>,
    Data.
item_to_bin_9 ({
    DunId,
    DailyCount,
    WeeklyCount,
    PermanentCount,
    ResetCount,
    VipCount,
    AddCount,
    IsSweep,
    RecData
}) ->
    BinList_RecData = [
        item_to_bin_10(RecData_Item) || RecData_Item <- RecData
    ], 

    RecData_Len = length(RecData), 
    Bin_RecData = list_to_binary(BinList_RecData),

    Data = <<
        DunId:32,
        DailyCount:16,
        WeeklyCount:16,
        PermanentCount:16,
        ResetCount:16,
        VipCount:16,
        AddCount:16,
        IsSweep:8,
        RecData_Len:16, Bin_RecData/binary
    >>,
    Data.
item_to_bin_10 ({
    Key,
    Val
}) ->
    Data = <<
        Key:16,
        Val:32
    >>,
    Data.
item_to_bin_11 ({
    RewardList,
    OtherReward
}) ->
    BinList_RewardList = [
        item_to_bin_12(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_OtherReward = [
        item_to_bin_13(OtherReward_Item) || OtherReward_Item <- OtherReward
    ], 

    OtherReward_Len = length(OtherReward), 
    Bin_OtherReward = list_to_binary(BinList_OtherReward),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary,
        OtherReward_Len:16, Bin_OtherReward/binary
    >>,
    Data.
item_to_bin_12 ({
    Style,
    TypeId,
    Count,
    GoodsId
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:32,
        GoodsId:64
    >>,
    Data.
item_to_bin_13 ({
    RewardType,
    OtherRewardList
}) ->
    BinList_OtherRewardList = [
        item_to_bin_14(OtherRewardList_Item) || OtherRewardList_Item <- OtherRewardList
    ], 

    OtherRewardList_Len = length(OtherRewardList), 
    Bin_OtherRewardList = list_to_binary(BinList_OtherRewardList),

    Data = <<
        RewardType:8,
        OtherRewardList_Len:16, Bin_OtherRewardList/binary
    >>,
    Data.
item_to_bin_14 ({
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
item_to_bin_15 ({
    DunType,
    LeftCount
}) ->
    Data = <<
        DunType:8,
        LeftCount:16
    >>,
    Data.
item_to_bin_16 ({
    DunId,
    RewardList,
    OtherReward
}) ->
    BinList_RewardList = [
        item_to_bin_17(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_OtherReward = [
        item_to_bin_18(OtherReward_Item) || OtherReward_Item <- OtherReward
    ], 

    OtherReward_Len = length(OtherReward), 
    Bin_OtherReward = list_to_binary(BinList_OtherReward),

    Data = <<
        DunId:32,
        RewardList_Len:16, Bin_RewardList/binary,
        OtherReward_Len:16, Bin_OtherReward/binary
    >>,
    Data.
item_to_bin_17 ({
    Style,
    TypeId,
    Count,
    GoodsId
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:32,
        GoodsId:64
    >>,
    Data.
item_to_bin_18 ({
    RewardType,
    OtherRewardList
}) ->
    BinList_OtherRewardList = [
        item_to_bin_19(OtherRewardList_Item) || OtherRewardList_Item <- OtherRewardList
    ], 

    OtherRewardList_Len = length(OtherRewardList), 
    Bin_OtherRewardList = list_to_binary(BinList_OtherRewardList),

    Data = <<
        RewardType:8,
        OtherRewardList_Len:16, Bin_OtherRewardList/binary
    >>,
    Data.
item_to_bin_19 ({
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
item_to_bin_20 ({
    RoleId,
    RoleName,
    HurtValue
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        HurtValue:64
    >>,
    Data.
item_to_bin_21 ({
    AutoId,
    MonTypeId,
    Hp,
    HpLimit
}) ->
    Data = <<
        AutoId:32,
        MonTypeId:32,
        Hp:64,
        HpLimit:64
    >>,
    Data.
item_to_bin_22 ({
    WaveType,
    WaveTypeArgs,
    WaveSubtype,
    CycleNum,
    MaxCycleNum,
    NextWaveTime
}) ->
    Bin_WaveTypeArgs = pt:write_string(WaveTypeArgs), 

    Data = <<
        WaveType:16,
        Bin_WaveTypeArgs/binary,
        WaveSubtype:16,
        CycleNum:16,
        MaxCycleNum:16,
        NextWaveTime:32
    >>,
    Data.
item_to_bin_23 ({
    DunType,
    Available,
    LeftCount,
    MaxCount
}) ->
    Data = <<
        DunType:8,
        Available:8,
        LeftCount:16,
        MaxCount:16
    >>,
    Data.
item_to_bin_24 ({
    DunId,
    RewardType,
    RewardStatus
}) ->
    Data = <<
        DunId:32,
        RewardType:8,
        RewardStatus:8
    >>,
    Data.
item_to_bin_25 ({
    Type,
    RoleId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Type:8,
        RoleId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_26 ({
    RewardType,
    OtherRewardList
}) ->
    BinList_OtherRewardList = [
        item_to_bin_27(OtherRewardList_Item) || OtherRewardList_Item <- OtherRewardList
    ], 

    OtherRewardList_Len = length(OtherRewardList), 
    Bin_OtherRewardList = list_to_binary(BinList_OtherRewardList),

    Data = <<
        RewardType:8,
        OtherRewardList_Len:16, Bin_OtherRewardList/binary
    >>,
    Data.
item_to_bin_27 ({
    Style1,
    TypeId1,
    Count1,
    GoodsId1
}) ->
    Data = <<
        Style1:8,
        TypeId1:32,
        Count1:64,
        GoodsId1:64
    >>,
    Data.
item_to_bin_28 ({
    RoleId,
    Name,
    Power,
    ServerNum,
    ServerId
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Power:32,
        ServerNum:32,
        ServerId:32
    >>,
    Data.
item_to_bin_29 (
    Wave
) ->
    Data = <<
        Wave:8
    >>,
    Data.
item_to_bin_30 ({
    SkillId,
    Num
}) ->
    Data = <<
        SkillId:32,
        Num:16
    >>,
    Data.
item_to_bin_31 ({
    Type,
    SelectType,
    IsOpen,
    Count
}) ->
    Data = <<
        Type:8,
        SelectType:8,
        IsOpen:8,
        Count:8
    >>,
    Data.
item_to_bin_32 ({
    Mid,
    Mtid,
    Sex
}) ->
    Data = <<
        Mid:32,
        Mtid:32,
        Sex:8
    >>,
    Data.
