-module(pt_332).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(33201, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33202, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33203, _) ->
    {ok, []};
read(33204, Bin0) ->
    <<Subtype:16, _Bin1/binary>> = Bin0, 
    {ok, [Subtype]};
read(33205, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33206, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Index:8, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Index, AutoBuy]};
read(33207, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, GradeId]};
read(33208, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33209, _) ->
    {ok, []};
read(33211, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33212, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Lv:8, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Lv]};
read(33213, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33214, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Times:16, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, Times, AutoBuy]};
read(33215, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Grade]};
read(33216, _) ->
    {ok, []};
read(33217, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33218, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33219, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Id:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Id]};
read(33220, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Times:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Times]};
read(33221, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33222, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33223, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33224, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<IsNext:8, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, IsNext]};
read(33225, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33226, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33227, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33228, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33229, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, Bin3/binary>> = Bin2, 
    <<PurchaseType:8, _Bin4/binary>> = Bin3, 
    {ok, [BaseType, SubType, GradeId, PurchaseType]};
read(33231, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33232, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33233, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<ItemId:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, ItemId]};
read(33236, Bin0) ->
    <<QuestionType:8, _Bin1/binary>> = Bin0, 
    {ok, [QuestionType]};
read(33237, _) ->
    {ok, []};
read(33238, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33239, _) ->
    {ok, []};
read(33240, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33241, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33243, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33244, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Times:16, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, Bin4/binary>> = Bin3, 
    <<Turn:16, _Bin5/binary>> = Bin4, 
    {ok, [BaseType, SubType, Times, AutoBuy, Turn]};
read(33245, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33246, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Times:16, Bin3/binary>> = Bin2, 
    <<AutoBuy:8, Bin4/binary>> = Bin3, 
    <<LucencyField:8, _Bin5/binary>> = Bin4, 
    {ok, [BaseType, SubType, Times, AutoBuy, LucencyField]};
read(33247, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33248, _) ->
    {ok, []};
read(33249, _) ->
    {ok, []};
read(33250, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33251, _) ->
    {ok, []};
read(33252, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33253, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33254, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<RewardId:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, RewardId]};
read(33255, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33256, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<WithdrawType:8, Bin3/binary>> = Bin2, 
    {PackageCode, Bin4} = pt:read_string(Bin3), 
    {TokenId, _Bin5} = pt:read_string(Bin4), 
    {ok, [Type, Subtype, WithdrawType, PackageCode, TokenId]};
read(33257, _) ->
    {ok, []};
read(33258, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33259, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33260, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33261, Bin0) ->
    <<ProtoId:16, _Bin1/binary>> = Bin0, 
    {ok, [ProtoId]};
read(33262, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33263, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(33264, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33265, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, Grade]};
read(33266, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<GoodsId:64, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, GoodsId]};
read(33267, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<GradeId:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, GradeId]};
read(_Cmd, _R) -> {error, no_match}.

write (33201,[
    ErrorCode,
    Type,
    Subtype,
    HireTimes,
    AccHireTimes,
    Time,
    HireState
]) ->
    Data = <<
        ErrorCode:32,
        Type:16,
        Subtype:16,
        HireTimes:8,
        AccHireTimes:8,
        Time:32,
        HireState:8
    >>,
    {ok, pt:pack(33201, Data)};

write (33202,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(33202, Data)};

write (33203,[
    MyRank,
    Cost,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        MyRank:32,
        Cost:64,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(33203, Data)};

write (33204,[
    Subtype,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_1(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Subtype:16,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(33204, Data)};

write (33205,[
    BaseType,
    SubType,
    FreeTimes,
    TotalTimesUse,
    CumulateReward,
    RewardList
]) ->
    BinList_CumulateReward = [
        item_to_bin_2(CumulateReward_Item) || CumulateReward_Item <- CumulateReward
    ], 

    CumulateReward_Len = length(CumulateReward), 
    Bin_CumulateReward = list_to_binary(BinList_CumulateReward),

    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        FreeTimes:8,
        TotalTimesUse:16,
        CumulateReward_Len:16, Bin_CumulateReward/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33205, Data)};

write (33206,[
    ErrorCode,
    BaseType,
    SubType,
    FreeTimes,
    TotalTimesUse,
    ShowLuckeyVal,
    List
]) ->
    BinList_List = [
        item_to_bin_4(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        FreeTimes:8,
        TotalTimesUse:16,
        ShowLuckeyVal:16,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33206, Data)};

write (33207,[
    ErrorCode,
    BaseType,
    SubType,
    GradeId,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        GradeId:16,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(33207, Data)};

write (33208,[
    BaseType,
    SubType,
    ShowLuckeyVal
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        ShowLuckeyVal:16
    >>,
    {ok, pt:pack(33208, Data)};

write (33209,[
    Liveness
]) ->
    Data = <<
        Liveness:16
    >>,
    {ok, pt:pack(33209, Data)};

write (33211,[
    BaseType,
    SubType,
    Investments,
    BuyTime
]) ->
    BinList_Investments = [
        item_to_bin_5(Investments_Item) || Investments_Item <- Investments
    ], 

    Investments_Len = length(Investments), 
    Bin_Investments = list_to_binary(BinList_Investments),

    Data = <<
        BaseType:16,
        SubType:16,
        Investments_Len:16, Bin_Investments/binary,
        BuyTime:32
    >>,
    {ok, pt:pack(33211, Data)};

write (33212,[
    ErrorCode,
    BaseType,
    SubType,
    Lv,
    LoginDays,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        Lv:8,
        LoginDays:16,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(33212, Data)};

write (33213,[
    BaseType,
    SubType,
    Pool,
    ErrorCode
]) ->
    Bin_Pool = pt:write_object_list(Pool), 

    Data = <<
        BaseType:16,
        SubType:16,
        Bin_Pool/binary,
        ErrorCode:32
    >>,
    {ok, pt:pack(33213, Data)};

write (33214,[
    BaseType,
    SubType,
    ErrorCode,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_6(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        BaseType:16,
        SubType:16,
        ErrorCode:32,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(33214, Data)};

write (33215,[
    ErrorCode,
    BaseType,
    SubType,
    Grade,
    NowCost
]) ->
    Bin_NowCost = pt:write_object_list(NowCost), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        Grade:16,
        Bin_NowCost/binary
    >>,
    {ok, pt:pack(33215, Data)};

write (33216,[
    Gold,
    ReturnGold,
    LoginDays
]) ->
    Data = <<
        Gold:32,
        ReturnGold:32,
        LoginDays:32
    >>,
    {ok, pt:pack(33216, Data)};

write (33217,[
    ErrorCode,
    BaseType,
    SubType,
    DrawTime,
    IsWinner,
    WinnerList
]) ->
    BinList_WinnerList = [
        item_to_bin_7(WinnerList_Item) || WinnerList_Item <- WinnerList
    ], 

    WinnerList_Len = length(WinnerList), 
    Bin_WinnerList = list_to_binary(BinList_WinnerList),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        DrawTime:32,
        IsWinner:8,
        WinnerList_Len:16, Bin_WinnerList/binary
    >>,
    {ok, pt:pack(33217, Data)};

write (33218,[
    BaseType,
    SubType,
    Activation,
    ActivationState,
    SelfLog
]) ->
    BinList_ActivationState = [
        item_to_bin_8(ActivationState_Item) || ActivationState_Item <- ActivationState
    ], 

    ActivationState_Len = length(ActivationState), 
    Bin_ActivationState = list_to_binary(BinList_ActivationState),

    BinList_SelfLog = [
        item_to_bin_9(SelfLog_Item) || SelfLog_Item <- SelfLog
    ], 

    SelfLog_Len = length(SelfLog), 
    Bin_SelfLog = list_to_binary(BinList_SelfLog),

    Data = <<
        BaseType:16,
        SubType:16,
        Activation:16,
        ActivationState_Len:16, Bin_ActivationState/binary,
        SelfLog_Len:16, Bin_SelfLog/binary
    >>,
    {ok, pt:pack(33218, Data)};

write (33219,[
    BaseType,
    SubType,
    ActivationState,
    ErrorCode,
    RewardList
]) ->
    BinList_ActivationState = [
        item_to_bin_10(ActivationState_Item) || ActivationState_Item <- ActivationState
    ], 

    ActivationState_Len = length(ActivationState), 
    Bin_ActivationState = list_to_binary(BinList_ActivationState),

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        BaseType:16,
        SubType:16,
        ActivationState_Len:16, Bin_ActivationState/binary,
        ErrorCode:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(33219, Data)};

write (33220,[
    BaseType,
    SubType,
    ErrorCode,
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_11(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        BaseType:16,
        SubType:16,
        ErrorCode:32,
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(33220, Data)};

write (33221,[
    BaseType,
    SubType,
    ErrorCode,
    AllTimes,
    FreeTimes,
    ShowList,
    CumulateReward,
    RarePool,
    RareDrawTimes
]) ->
    BinList_ShowList = [
        item_to_bin_12(ShowList_Item) || ShowList_Item <- ShowList
    ], 

    ShowList_Len = length(ShowList), 
    Bin_ShowList = list_to_binary(BinList_ShowList),

    BinList_CumulateReward = [
        item_to_bin_13(CumulateReward_Item) || CumulateReward_Item <- CumulateReward
    ], 

    CumulateReward_Len = length(CumulateReward), 
    Bin_CumulateReward = list_to_binary(BinList_CumulateReward),

    BinList_RarePool = [
        item_to_bin_14(RarePool_Item) || RarePool_Item <- RarePool
    ], 

    RarePool_Len = length(RarePool), 
    Bin_RarePool = list_to_binary(BinList_RarePool),

    Data = <<
        BaseType:16,
        SubType:16,
        ErrorCode:32,
        AllTimes:16,
        FreeTimes:16,
        ShowList_Len:16, Bin_ShowList/binary,
        CumulateReward_Len:16, Bin_CumulateReward/binary,
        RarePool_Len:16, Bin_RarePool/binary,
        RareDrawTimes:16
    >>,
    {ok, pt:pack(33221, Data)};

write (33222,[
    ErrorCode,
    BaseType,
    SubType,
    RareDrawTimes,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_15(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        RareDrawTimes:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33222, Data)};

write (33223,[
    Code,
    Status,
    RoleId,
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Code:32,
        Status:8,
        RoleId:64,
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(33223, Data)};

write (33224,[
    BaseType,
    SubType,
    Turns,
    CgoodsId,
    CgoodsNum,
    RoundsList,
    RewardList
]) ->
    BinList_RoundsList = [
        item_to_bin_16(RoundsList_Item) || RoundsList_Item <- RoundsList
    ], 

    RoundsList_Len = length(RoundsList), 
    Bin_RoundsList = list_to_binary(BinList_RoundsList),

    BinList_RewardList = [
        item_to_bin_17(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        Turns:32,
        CgoodsId:32,
        CgoodsNum:32,
        RoundsList_Len:16, Bin_RoundsList/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33224, Data)};

write (33225,[
    ErrorCode,
    BaseType,
    SubType,
    GradeId,
    GoodsId,
    GoodsNum
]) ->
    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        GradeId:16,
        GoodsId:32,
        GoodsNum:32
    >>,
    {ok, pt:pack(33225, Data)};

write (33226,[
    BaseType,
    SubType,
    SelfList,
    GolbList
]) ->
    BinList_SelfList = [
        item_to_bin_18(SelfList_Item) || SelfList_Item <- SelfList
    ], 

    SelfList_Len = length(SelfList), 
    Bin_SelfList = list_to_binary(BinList_SelfList),

    BinList_GolbList = [
        item_to_bin_19(GolbList_Item) || GolbList_Item <- GolbList
    ], 

    GolbList_Len = length(GolbList), 
    Bin_GolbList = list_to_binary(BinList_GolbList),

    Data = <<
        BaseType:16,
        SubType:16,
        SelfList_Len:16, Bin_SelfList/binary,
        GolbList_Len:16, Bin_GolbList/binary
    >>,
    {ok, pt:pack(33226, Data)};

write (33227,[
    BaseType,
    SubType,
    GpGoods,
    LastShoutTime
]) ->
    BinList_GpGoods = [
        item_to_bin_20(GpGoods_Item) || GpGoods_Item <- GpGoods
    ], 

    GpGoods_Len = length(GpGoods), 
    Bin_GpGoods = list_to_binary(BinList_GpGoods),

    Data = <<
        BaseType:16,
        SubType:16,
        GpGoods_Len:16, Bin_GpGoods/binary,
        LastShoutTime:32
    >>,
    {ok, pt:pack(33227, Data)};

write (33228,[
    BaseType,
    SubType,
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_21(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        BaseType:16,
        SubType:16,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(33228, Data)};

write (33229,[
    ErrorCode,
    BaseType,
    SubType,
    GradeId,
    PurchaseType,
    BuyCount,
    BuyNum,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        GradeId:16,
        PurchaseType:8,
        BuyCount:8,
        BuyNum:16,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(33229, Data)};

write (33230,[
    BaseType,
    SubType,
    GradeId,
    BuyNum
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        GradeId:16,
        BuyNum:16
    >>,
    {ok, pt:pack(33230, Data)};

write (33231,[
    BaseType,
    SubType,
    Currency
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        Currency:32
    >>,
    {ok, pt:pack(33231, Data)};

write (33232,[
    BaseType,
    SubType,
    SumPoint,
    IsLegend,
    FlushTime,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_24(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        BaseType:16,
        SubType:16,
        SumPoint:32,
        IsLegend:8,
        FlushTime:64,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(33232, Data)};

write (33233,[
    ErrorCode,
    BaseType,
    SubType,
    ItemId,
    SumPoint,
    ChallengeType
]) ->
    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        ItemId:16,
        SumPoint:32,
        ChallengeType:8
    >>,
    {ok, pt:pack(33233, Data)};

write (33234,[
    BaseType,
    SubType,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_25(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        BaseType:16,
        SubType:16,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(33234, Data)};

write (33235,[
    BaseType,
    SubType,
    IsLegend
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        IsLegend:8
    >>,
    {ok, pt:pack(33235, Data)};

write (33236,[
    ErrorCode,
    QuestionType
]) ->
    Data = <<
        ErrorCode:32,
        QuestionType:8
    >>,
    {ok, pt:pack(33236, Data)};

write (33237,[
    PlayerId,
    BuffList
]) ->
    BinList_BuffList = [
        item_to_bin_26(BuffList_Item) || BuffList_Item <- BuffList
    ], 

    BuffList_Len = length(BuffList), 
    Bin_BuffList = list_to_binary(BinList_BuffList),

    Data = <<
        PlayerId:64,
        BuffList_Len:16, Bin_BuffList/binary
    >>,
    {ok, pt:pack(33237, Data)};

write (33238,[
    BaseType,
    SubType,
    Turn,
    Point,
    NeedPoint,
    MaxTurn,
    RewardList,
    DoublePoint,
    Label
]) ->
    BinList_RewardList = [
        item_to_bin_27(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_DoublePoint = [
        item_to_bin_28(DoublePoint_Item) || DoublePoint_Item <- DoublePoint
    ], 

    DoublePoint_Len = length(DoublePoint), 
    Bin_DoublePoint = list_to_binary(BinList_DoublePoint),

    Data = <<
        BaseType:16,
        SubType:16,
        Turn:16,
        Point:32,
        NeedPoint:32,
        MaxTurn:16,
        RewardList_Len:16, Bin_RewardList/binary,
        DoublePoint_Len:16, Bin_DoublePoint/binary,
        Label:8
    >>,
    {ok, pt:pack(33238, Data)};

write (33239,[
    BaseType,
    SubType,
    Turn,
    Point,
    NeedPoint
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        Turn:16,
        Point:32,
        NeedPoint:32
    >>,
    {ok, pt:pack(33239, Data)};

write (33240,[
    ErrorCode,
    BaseType,
    SubType,
    GradeId,
    Reward,
    Turn,
    Point,
    NeedPoint
]) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        GradeId:16,
        Bin_Reward/binary,
        Turn:16,
        Point:32,
        NeedPoint:32
    >>,
    {ok, pt:pack(33240, Data)};

write (33241,[
    BaseType,
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_29(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33241, Data)};

write (33242,[
    BaseType,
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_30(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33242, Data)};

write (33243,[
    BaseType,
    SubType,
    DrawTime,
    Turn,
    GradeInfo,
    RewardList
]) ->
    BinList_GradeInfo = [
        item_to_bin_31(GradeInfo_Item) || GradeInfo_Item <- GradeInfo
    ], 

    GradeInfo_Len = length(GradeInfo), 
    Bin_GradeInfo = list_to_binary(BinList_GradeInfo),

    BinList_RewardList = [
        item_to_bin_32(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        DrawTime:16,
        Turn:16,
        GradeInfo_Len:16, Bin_GradeInfo/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33243, Data)};

write (33244,[
    BaseType,
    SubType,
    Times,
    AutoBuy,
    ErrorCode,
    GradeList,
    Reward,
    DrawTime,
    Turn,
    GradeInfo
]) ->
    BinList_GradeList = [
        item_to_bin_33(GradeList_Item) || GradeList_Item <- GradeList
    ], 

    GradeList_Len = length(GradeList), 
    Bin_GradeList = list_to_binary(BinList_GradeList),

    Bin_Reward = pt:write_object_list(Reward), 

    BinList_GradeInfo = [
        item_to_bin_34(GradeInfo_Item) || GradeInfo_Item <- GradeInfo
    ], 

    GradeInfo_Len = length(GradeInfo), 
    Bin_GradeInfo = list_to_binary(BinList_GradeInfo),

    Data = <<
        BaseType:16,
        SubType:16,
        Times:16,
        AutoBuy:8,
        ErrorCode:32,
        GradeList_Len:16, Bin_GradeList/binary,
        Bin_Reward/binary,
        DrawTime:16,
        Turn:16,
        GradeInfo_Len:16, Bin_GradeInfo/binary
    >>,
    {ok, pt:pack(33244, Data)};

write (33245,[
    BaseType,
    SubType,
    MaxLuck,
    CurrentLuck,
    PerLuck,
    TotalTimes,
    OneCost,
    TenCost,
    DrawList,
    GrandList,
    ExchangeList
]) ->
    Bin_OneCost = pt:write_string(OneCost), 

    Bin_TenCost = pt:write_string(TenCost), 

    BinList_DrawList = [
        item_to_bin_35(DrawList_Item) || DrawList_Item <- DrawList
    ], 

    DrawList_Len = length(DrawList), 
    Bin_DrawList = list_to_binary(BinList_DrawList),

    BinList_GrandList = [
        item_to_bin_36(GrandList_Item) || GrandList_Item <- GrandList
    ], 

    GrandList_Len = length(GrandList), 
    Bin_GrandList = list_to_binary(BinList_GrandList),

    BinList_ExchangeList = [
        item_to_bin_37(ExchangeList_Item) || ExchangeList_Item <- ExchangeList
    ], 

    ExchangeList_Len = length(ExchangeList), 
    Bin_ExchangeList = list_to_binary(BinList_ExchangeList),

    Data = <<
        BaseType:16,
        SubType:16,
        MaxLuck:32,
        CurrentLuck:32,
        PerLuck:16,
        TotalTimes:32,
        Bin_OneCost/binary,
        Bin_TenCost/binary,
        DrawList_Len:16, Bin_DrawList/binary,
        GrandList_Len:16, Bin_GrandList/binary,
        ExchangeList_Len:16, Bin_ExchangeList/binary
    >>,
    {ok, pt:pack(33245, Data)};

write (33246,[
    ErrorCode,
    BaseType,
    SubType,
    AutoBuy,
    LucencyField,
    CurrentLuck,
    CurrentTimes,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_38(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        BaseType:16,
        SubType:16,
        AutoBuy:8,
        LucencyField:8,
        CurrentLuck:32,
        CurrentTimes:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33246, Data)};

write (33247,[
    BaseType,
    SubType,
    Times
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        Times:8
    >>,
    {ok, pt:pack(33247, Data)};

write (33248,[
    MinTime,
    MaxTime
]) ->
    Data = <<
        MinTime:32,
        MaxTime:32
    >>,
    {ok, pt:pack(33248, Data)};

write (33249,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33249, Data)};

write (33250,[
    BaseType,
    SubType,
    CdLists
]) ->
    BinList_CdLists = [
        item_to_bin_39(CdLists_Item) || CdLists_Item <- CdLists
    ], 

    CdLists_Len = length(CdLists), 
    Bin_CdLists = list_to_binary(BinList_CdLists),

    Data = <<
        BaseType:16,
        SubType:16,
        CdLists_Len:16, Bin_CdLists/binary
    >>,
    {ok, pt:pack(33250, Data)};

write (33251,[
    RushRankId,
    Type,
    Rank,
    Value,
    SubValue
]) ->
    Data = <<
        RushRankId:32,
        Type:32,
        Rank:32,
        Value:32,
        SubValue:32
    >>,
    {ok, pt:pack(33251, Data)};

write (33252,[
    Type,
    Subtype,
    Score,
    TodayScore,
    Condition,
    RewardList,
    StageList,
    WorldLv
]) ->
    Bin_Condition = pt:write_string(Condition), 

    BinList_RewardList = [
        item_to_bin_40(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_StageList = [
        item_to_bin_41(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        Type:16,
        Subtype:16,
        Score:32,
        TodayScore:32,
        Bin_Condition/binary,
        RewardList_Len:16, Bin_RewardList/binary,
        StageList_Len:16, Bin_StageList/binary,
        WorldLv:32
    >>,
    {ok, pt:pack(33252, Data)};

write (33253,[
    Type,
    Subtype,
    Score,
    Rank,
    RankList,
    SeverScore,
    ServerRank,
    ServerRankList
]) ->
    BinList_RankList = [
        item_to_bin_42(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    BinList_ServerRankList = [
        item_to_bin_43(ServerRankList_Item) || ServerRankList_Item <- ServerRankList
    ], 

    ServerRankList_Len = length(ServerRankList), 
    Bin_ServerRankList = list_to_binary(BinList_ServerRankList),

    Data = <<
        Type:16,
        Subtype:16,
        Score:32,
        Rank:16,
        RankList_Len:16, Bin_RankList/binary,
        SeverScore:32,
        ServerRank:16,
        ServerRankList_Len:16, Bin_ServerRankList/binary
    >>,
    {ok, pt:pack(33253, Data)};

write (33254,[
    Type,
    Subtype,
    RewardId,
    ErrorCode
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        RewardId:16,
        ErrorCode:32
    >>,
    {ok, pt:pack(33254, Data)};

write (33255,[
    Type,
    Subtype,
    IsQuality,
    StartTime,
    EndTime,
    LoginMoney,
    RechargeMoney,
    LoginStatus,
    RechargeStatus,
    LoginWithdrawal,
    RechargeWithdrawal,
    LoginGlobalTimes,
    RechargeGlobalTimes
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        IsQuality:8,
        StartTime:32,
        EndTime:32,
        LoginMoney:16,
        RechargeMoney:16,
        LoginStatus:8,
        RechargeStatus:8,
        LoginWithdrawal:8,
        RechargeWithdrawal:8,
        LoginGlobalTimes:32,
        RechargeGlobalTimes:32
    >>,
    {ok, pt:pack(33255, Data)};

write (33256,[
    Type,
    Subtype,
    Errcode,
    LoginMoney,
    RechargeMoney,
    LoginStatus,
    RechargeStatus
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Errcode:32,
        LoginMoney:16,
        RechargeMoney:16,
        LoginStatus:8,
        RechargeStatus:8
    >>,
    {ok, pt:pack(33256, Data)};

write (33257,[
    Type,
    Subtype,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_44(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Type:16,
        Subtype:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33257, Data)};

write (33258,[
    Type,
    Subtype,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_45(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        Type:16,
        Subtype:16,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(33258, Data)};

write (33259,[
    BaseType,
    SubType,
    RechargeNum,
    IsRecharge,
    List
]) ->
    BinList_List = [
        item_to_bin_46(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        BaseType:16,
        SubType:16,
        RechargeNum:16,
        IsRecharge:16,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(33259, Data)};

write (33260,[
    Type,
    Subtype,
    FreeTimes,
    IsFirstRecharge,
    Turn,
    Times,
    FreeGiftStatus
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        FreeTimes:8,
        IsFirstRecharge:8,
        Turn:8,
        Times:16,
        FreeGiftStatus:8
    >>,
    {ok, pt:pack(33260, Data)};

write (33261,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(33261, Data)};

write (33262,[
    Type,
    Subtype,
    Grade,
    Turn,
    Times,
    Errcode
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Grade:16,
        Turn:8,
        Times:16,
        Errcode:32
    >>,
    {ok, pt:pack(33262, Data)};

write (33263,[
    Type,
    Subtype,
    Errcode
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Errcode:32
    >>,
    {ok, pt:pack(33263, Data)};

write (33264,[
    BaseType,
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_48(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33264, Data)};

write (33265,[
    Type,
    Subtype,
    Grade,
    Errcode
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Grade:16,
        Errcode:32
    >>,
    {ok, pt:pack(33265, Data)};

write (33266,[
    Type,
    Subtype,
    Power,
    Errcode
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Power:64,
        Errcode:32
    >>,
    {ok, pt:pack(33266, Data)};

write (33267,[
    Code,
    Type,
    Subtype,
    LastShoutTime
]) ->
    Data = <<
        Code:32,
        Type:16,
        Subtype:16,
        LastShoutTime:32
    >>,
    {ok, pt:pack(33267, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    RoleId,
    RoleName,
    Rank,
    Cost
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerId:32,
        ServerNum:32,
        RoleId:64,
        Bin_RoleName/binary,
        Rank:16,
        Cost:64
    >>,
    Data.
item_to_bin_1 ({
    GradeId,
    LimitCost,
    MinRank,
    MaxRank,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        LimitCost:64,
        MinRank:16,
        MaxRank:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_2 ({
    GradeId,
    Times,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    Grade,
    FormType,
    Status,
    ReceiveTimes,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        ReceiveTimes:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_4 ({
    GradeId,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_5 (
    Lv
) ->
    Data = <<
        Lv:8
    >>,
    Data.
item_to_bin_6 ({
    Grade,
    RewardList,
    Rare
}) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Grade:16,
        Bin_RewardList/binary,
        Rare:8
    >>,
    Data.
item_to_bin_7 ({
    RoleId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_8 ({
    Id,
    Status
}) ->
    Data = <<
        Id:16,
        Status:8
    >>,
    Data.
item_to_bin_9 ({
    Name,
    RewardList
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Bin_Name/binary,
        Bin_RewardList/binary
    >>,
    Data.
item_to_bin_10 ({
    Id,
    Status
}) ->
    Data = <<
        Id:16,
        Status:8
    >>,
    Data.
item_to_bin_11 ({
    Grade,
    RewardList,
    Rare
}) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Grade:16,
        Bin_RewardList/binary,
        Rare:8
    >>,
    Data.
item_to_bin_12 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_13 ({
    GradeId,
    Times,
    Reward,
    Status
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        Times:16,
        Bin_Reward/binary,
        Status:8
    >>,
    Data.
item_to_bin_14 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_15 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_16 ({
    Rounds,
    MaxNum,
    MinNum,
    RewardId
}) ->
    Data = <<
        Rounds:32,
        MaxNum:32,
        MinNum:32,
        RewardId:64
    >>,
    Data.
item_to_bin_17 ({
    GradeId,
    GoodsId,
    GoodsNum,
    IsHead
}) ->
    Data = <<
        GradeId:16,
        GoodsId:32,
        GoodsNum:32,
        IsHead:8
    >>,
    Data.
item_to_bin_18 ({
    RoleId,
    RoleName,
    GoodsId,
    GoodsNum
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        GoodsId:32,
        GoodsNum:32
    >>,
    Data.
item_to_bin_19 ({
    RoleId,
    RoleName,
    GoodsId,
    GoodsNum
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        GoodsId:32,
        GoodsNum:32
    >>,
    Data.
item_to_bin_20 ({
    GradeId,
    FirstBuyCount,
    TailBuyCount,
    BuyNum
}) ->
    Data = <<
        GradeId:16,
        FirstBuyCount:8,
        TailBuyCount:8,
        BuyNum:16
    >>,
    Data.
item_to_bin_21 ({
    RoleId,
    RoleName,
    ServerId,
    ServerNum,
    GradeId,
    FirstBuy,
    FirstBuyTime,
    TailBuy,
    TailBuyTime
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    BinList_FirstBuy = [
        item_to_bin_22(FirstBuy_Item) || FirstBuy_Item <- FirstBuy
    ], 

    FirstBuy_Len = length(FirstBuy), 
    Bin_FirstBuy = list_to_binary(BinList_FirstBuy),

    BinList_TailBuy = [
        item_to_bin_23(TailBuy_Item) || TailBuy_Item <- TailBuy
    ], 

    TailBuy_Len = length(TailBuy), 
    Bin_TailBuy = list_to_binary(BinList_TailBuy),

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        ServerId:16,
        ServerNum:16,
        GradeId:16,
        FirstBuy_Len:16, Bin_FirstBuy/binary,
        FirstBuyTime:32,
        TailBuy_Len:16, Bin_TailBuy/binary,
        TailBuyTime:32
    >>,
    Data.
item_to_bin_22 (
    GapTime
) ->
    Data = <<
        GapTime:32
    >>,
    Data.
item_to_bin_23 (
    GapTime
) ->
    Data = <<
        GapTime:32
    >>,
    Data.
item_to_bin_24 ({
    ItemId,
    TaskId,
    ChallengeType,
    ChallengeName,
    IconType,
    Point,
    GrandNum,
    JumpId,
    ProcessNum,
    IsGet,
    IsOpen
}) ->
    Bin_ChallengeName = pt:write_string(ChallengeName), 

    Bin_IconType = pt:write_string(IconType), 

    Data = <<
        ItemId:16,
        TaskId:16,
        ChallengeType:8,
        Bin_ChallengeName/binary,
        Bin_IconType/binary,
        Point:32,
        GrandNum:32,
        JumpId:32,
        ProcessNum:32,
        IsGet:8,
        IsOpen:8
    >>,
    Data.
item_to_bin_25 ({
    ItemId,
    ChallengeType,
    ProcessNum,
    IsGet
}) ->
    Data = <<
        ItemId:16,
        ChallengeType:8,
        ProcessNum:32,
        IsGet:8
    >>,
    Data.
item_to_bin_26 ({
    GoodsId,
    BuffType,
    Time
}) ->
    Data = <<
        GoodsId:32,
        BuffType:8,
        Time:32
    >>,
    Data.
item_to_bin_27 ({
    Grade,
    FormType,
    Status,
    Name,
    Desc,
    Reward,
    Condition
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Reward = pt:write_string(Reward), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Reward/binary,
        Bin_Condition/binary
    >>,
    Data.
item_to_bin_28 ({
    JumpId,
    IsBuy
}) ->
    Data = <<
        JumpId:32,
        IsBuy:8
    >>,
    Data.
item_to_bin_29 ({
    Grade,
    FormType,
    Status,
    Process,
    ReceiveTimes,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        Process:16,
        ReceiveTimes:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_30 ({
    Grade,
    Process
}) ->
    Data = <<
        Grade:16,
        Process:16
    >>,
    Data.
item_to_bin_31 ({
    GradeId,
    Count
}) ->
    Data = <<
        GradeId:16,
        Count:16
    >>,
    Data.
item_to_bin_32 ({
    Grade,
    FormType,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_33 (
    GradeId
) ->
    Data = <<
        GradeId:16
    >>,
    Data.
item_to_bin_34 ({
    GradeId,
    Count
}) ->
    Data = <<
        GradeId:16,
        Count:16
    >>,
    Data.
item_to_bin_35 ({
    GradeId,
    IsNice,
    IsGet1,
    Reward
}) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        GradeId:16,
        IsNice:8,
        IsGet1:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_36 ({
    GradeId,
    IsGet2,
    NeedNum,
    Reward
}) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        GradeId:16,
        IsGet2:8,
        NeedNum:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_37 ({
    GradeId,
    NeedPoint,
    Reward
}) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        GradeId:16,
        NeedPoint:16,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_38 ({
    GradeId,
    Reward,
    IsNice
}) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        GradeId:16,
        Bin_Reward/binary,
        IsNice:8
    >>,
    Data.
item_to_bin_39 ({
    GradeId,
    CdTime
}) ->
    Data = <<
        GradeId:32,
        CdTime:32
    >>,
    Data.
item_to_bin_40 ({
    GradeId,
    IsRare,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        GradeId:16,
        IsRare:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_41 ({
    Id,
    GotType
}) ->
    Data = <<
        Id:16,
        GotType:8
    >>,
    Data.
item_to_bin_42 ({
    Rank,
    ServerId,
    RoleId,
    RoleName,
    RoleScore
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        ServerId:32,
        RoleId:64,
        Bin_RoleName/binary,
        RoleScore:32
    >>,
    Data.
item_to_bin_43 ({
    Rank,
    ServerId,
    ServerName,
    ServerScore
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        Rank:16,
        ServerId:32,
        Bin_ServerName/binary,
        ServerScore:32
    >>,
    Data.
item_to_bin_44 ({
    Style,
    GoodsId,
    Num
}) ->
    Data = <<
        Style:16,
        GoodsId:32,
        Num:32
    >>,
    Data.
item_to_bin_45 ({
    Grade,
    Process
}) ->
    Data = <<
        Grade:16,
        Process:32
    >>,
    Data.
item_to_bin_46 ({
    Grade,
    Condition,
    Name,
    Desc,
    RewardList
}) ->
    Bin_Condition = pt:write_string(Condition), 

    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    BinList_RewardList = [
        item_to_bin_47(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Grade:16,
        Bin_Condition/binary,
        Bin_Name/binary,
        Bin_Desc/binary,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    Data.
item_to_bin_47 ({
    FormType,
    Status,
    Reward
}) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        FormType:8,
        Status:8,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_48 ({
    Grade,
    FormType,
    Reward
}) ->
    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Bin_Reward/binary
    >>,
    Data.
