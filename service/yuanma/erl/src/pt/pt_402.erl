-module(pt_402).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40201, _) ->
    {ok, []};
read(40203, _) ->
    {ok, []};
read(40204, _) ->
    {ok, []};
read(40209, Bin0) ->
    <<IsAuto:8, _Bin1/binary>> = Bin0, 
    {ok, [IsAuto]};
read(40211, _) ->
    {ok, []};
read(40212, _) ->
    {ok, []};
read(40213, _) ->
    {ok, []};
read(40214, _) ->
    {ok, []};
read(40215, _) ->
    {ok, []};
read(40216, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(40217, _) ->
    {ok, []};
read(40218, _) ->
    {ok, []};
read(40219, _) ->
    {ok, []};
read(40220, _) ->
    {ok, []};
read(40221, _) ->
    {ok, []};
read(40222, _) ->
    {ok, []};
read(40230, _) ->
    {ok, []};
read(40231, _) ->
    {ok, []};
read(40232, _) ->
    {ok, []};
read(40240, _) ->
    {ok, []};
read(40241, _) ->
    {ok, []};
read(40242, _) ->
    {ok, []};
read(40243, _) ->
    {ok, []};
read(40244, _) ->
    {ok, []};
read(40245, _) ->
    {ok, []};
read(40246, _) ->
    {ok, []};
read(40247, _) ->
    {ok, []};
read(40250, _) ->
    {ok, []};
read(40251, _) ->
    {ok, []};
read(40252, _) ->
    {ok, []};
read(40253, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<SpecifyId:64, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Id:32, _Args1/binary>> = RestBin0, 
        {Id,_Args1}
        end,
    {List, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [Type, SpecifyId, List]};
read(40254, _) ->
    {ok, []};
read(40255, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(40256, _) ->
    {ok, []};
read(40257, Bin0) ->
    <<FireId:32, _Bin1/binary>> = Bin0, 
    {ok, [FireId]};
read(40259, Bin0) ->
    <<Answer:8, _Bin1/binary>> = Bin0, 
    {ok, [Answer]};
read(40260, _) ->
    {ok, []};
read(40261, Bin0) ->
    <<DragonSpirit:64, _Bin1/binary>> = Bin0, 
    {ok, [DragonSpirit]};
read(40263, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(40264, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(40265, _) ->
    {ok, []};
read(40267, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (40200,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40200, Data)};

write (40201,[
    Etime,
    AutoDrumupTime,
    DunId,
    GbossMat,
    RemainTimes,
    IsAuto,
    IsDrumToday,
    MonState
]) ->
    Data = <<
        Etime:32,
        AutoDrumupTime:32,
        DunId:32,
        GbossMat:32,
        RemainTimes:8,
        IsAuto:8,
        IsDrumToday:8,
        MonState:8
    >>,
    {ok, pt:pack(40201, Data)};

write (40203,[
    AddGbossMat,
    GbossMat
]) ->
    Data = <<
        AddGbossMat:32,
        GbossMat:32
    >>,
    {ok, pt:pack(40203, Data)};

write (40204,[
    Errcode,
    RoleId
]) ->
    Data = <<
        Errcode:32,
        RoleId:64
    >>,
    {ok, pt:pack(40204, Data)};

write (40208,[
    GbossResult,
    FixReward,
    AuctionReward
]) ->
    BinList_FixReward = [
        item_to_bin_0(FixReward_Item) || FixReward_Item <- FixReward
    ], 

    FixReward_Len = length(FixReward), 
    Bin_FixReward = list_to_binary(BinList_FixReward),

    BinList_AuctionReward = [
        item_to_bin_1(AuctionReward_Item) || AuctionReward_Item <- AuctionReward
    ], 

    AuctionReward_Len = length(AuctionReward), 
    Bin_AuctionReward = list_to_binary(BinList_AuctionReward),

    Data = <<
        GbossResult:8,
        FixReward_Len:16, Bin_FixReward/binary,
        AuctionReward_Len:16, Bin_AuctionReward/binary
    >>,
    {ok, pt:pack(40208, Data)};

write (40209,[
    Errcode,
    IsAuto
]) ->
    Data = <<
        Errcode:32,
        IsAuto:8
    >>,
    {ok, pt:pack(40209, Data)};

write (40210,[
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(40210, Data)};

write (40211,[
    Status,
    ActEndTime,
    Etime,
    Stage
]) ->
    Data = <<
        Status:8,
        ActEndTime:32,
        Etime:32,
        Stage:8
    >>,
    {ok, pt:pack(40211, Data)};

write (40212,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40212, Data)};

write (40213,[
    Exp,
    Donate
]) ->
    Data = <<
        Exp:32,
        Donate:32
    >>,
    {ok, pt:pack(40213, Data)};

write (40214,[
    IsKf,
    GuildList,
    RankList
]) ->
    BinList_GuildList = [
        item_to_bin_2(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    BinList_RankList = [
        item_to_bin_3(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        IsKf:8,
        GuildList_Len:16, Bin_GuildList/binary,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(40214, Data)};

write (40215,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40215, Data)};



write (40217,[
    Status,
    Etime,
    No,
    Id
]) ->
    Data = <<
        Status:8,
        Etime:32,
        No:32,
        Id:64
    >>,
    {ok, pt:pack(40217, Data)};

write (40218,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40218, Data)};

write (40219,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40219, Data)};

write (40220,[
    Rank,
    Point
]) ->
    Data = <<
        Rank:16,
        Point:64
    >>,
    {ok, pt:pack(40220, Data)};

write (40221,[
    IsFinish
]) ->
    Data = <<
        IsFinish:8
    >>,
    {ok, pt:pack(40221, Data)};

write (40222,[
    GameType
]) ->
    Data = <<
        GameType:8
    >>,
    {ok, pt:pack(40222, Data)};

write (40230,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40230, Data)};

write (40231,[
    State,
    EndTime,
    IsEnd
]) ->
    Data = <<
        State:8,
        EndTime:32,
        IsEnd:8
    >>,
    {ok, pt:pack(40231, Data)};

write (40232,[
    WaveNum
]) ->
    Data = <<
        WaveNum:16
    >>,
    {ok, pt:pack(40232, Data)};

write (40240,[
    Status,
    GameTimes,
    Round,
    Etime
]) ->
    Data = <<
        Status:8,
        GameTimes:16,
        Round:8,
        Etime:32
    >>,
    {ok, pt:pack(40240, Data)};

write (40241,[
    List
]) ->
    BinList_List = [
        item_to_bin_4(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40241, Data)};

write (40242,[
    List
]) ->
    BinList_List = [
        item_to_bin_5(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40242, Data)};

write (40243,[
    List
]) ->
    BinList_List = [
        item_to_bin_6(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40243, Data)};

write (40244,[
    List
]) ->
    BinList_List = [
        item_to_bin_8(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40244, Data)};

write (40245,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40245, Data)};

write (40246,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40246, Data)};

write (40247,[
    StartPkTime,
    List
]) ->
    BinList_List = [
        item_to_bin_10(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        StartPkTime:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40247, Data)};

write (40248,[
    GuildId,
    List
]) ->
    BinList_List = [
        item_to_bin_11(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        GuildId:64,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40248, Data)};

write (40249,[
    Result,
    Exp,
    Donate,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_12(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Result:8,
        Exp:32,
        Donate:32,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(40249, Data)};

write (40250,[
    GuildId,
    GuildName,
    ChiefFigure,
    StreakTimes,
    SalaryStatus
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_ChiefFigure = pt:write_figure(ChiefFigure), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        Bin_ChiefFigure/binary,
        StreakTimes:16,
        SalaryStatus:8
    >>,
    {ok, pt:pack(40250, Data)};

write (40251,[
    GuildId,
    MaxStreakTimes,
    RewardList,
    NotAllotList
]) ->
    BinList_RewardList = [
        item_to_bin_13(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_NotAllotList = [
        item_to_bin_15(NotAllotList_Item) || NotAllotList_Item <- NotAllotList
    ], 

    NotAllotList_Len = length(NotAllotList), 
    Bin_NotAllotList = list_to_binary(BinList_NotAllotList),

    Data = <<
        GuildId:64,
        MaxStreakTimes:16,
        RewardList_Len:16, Bin_RewardList/binary,
        NotAllotList_Len:16, Bin_NotAllotList/binary
    >>,
    {ok, pt:pack(40251, Data)};

write (40252,[
    GuildId,
    AllotStatus,
    ObtainRewards,
    PreviewRewards
]) ->
    BinList_ObtainRewards = [
        item_to_bin_16(ObtainRewards_Item) || ObtainRewards_Item <- ObtainRewards
    ], 

    ObtainRewards_Len = length(ObtainRewards), 
    Bin_ObtainRewards = list_to_binary(BinList_ObtainRewards),

    BinList_PreviewRewards = [
        item_to_bin_17(PreviewRewards_Item) || PreviewRewards_Item <- PreviewRewards
    ], 

    PreviewRewards_Len = length(PreviewRewards), 
    Bin_PreviewRewards = list_to_binary(BinList_PreviewRewards),

    Data = <<
        GuildId:64,
        AllotStatus:8,
        ObtainRewards_Len:16, Bin_ObtainRewards/binary,
        PreviewRewards_Len:16, Bin_PreviewRewards/binary
    >>,
    {ok, pt:pack(40252, Data)};

write (40253,[
    Errcode,
    Type
]) ->
    Data = <<
        Errcode:32,
        Type:8
    >>,
    {ok, pt:pack(40253, Data)};

write (40254,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(40254, Data)};

write (40255,[
    Type,
    Exp
]) ->
    Data = <<
        Type:8,
        Exp:64
    >>,
    {ok, pt:pack(40255, Data)};

write (40256,[
    Wave,
    NextTime
]) ->
    Data = <<
        Wave:32,
        NextTime:64
    >>,
    {ok, pt:pack(40256, Data)};

write (40257,[
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(40257, Data)};

write (40258,[
    Stage,
    Time
]) ->
    Data = <<
        Stage:8,
        Time:16
    >>,
    {ok, pt:pack(40258, Data)};

write (40259,[
    Status
]) ->
    Data = <<
        Status:8
    >>,
    {ok, pt:pack(40259, Data)};

write (40260,[
    DragonSpirit
]) ->
    Data = <<
        DragonSpirit:64
    >>,
    {ok, pt:pack(40260, Data)};



write (40262,[
    Status,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Status:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(40262, Data)};

write (40263,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(40263, Data)};

write (40264,[
    Code,
    FoodList
]) ->
    BinList_FoodList = [
        item_to_bin_18(FoodList_Item) || FoodList_Item <- FoodList
    ], 

    FoodList_Len = length(FoodList), 
    Bin_FoodList = list_to_binary(BinList_FoodList),

    Data = <<
        Code:32,
        FoodList_Len:16, Bin_FoodList/binary
    >>,
    {ok, pt:pack(40264, Data)};

write (40265,[
    FoodList
]) ->
    BinList_FoodList = [
        item_to_bin_19(FoodList_Item) || FoodList_Item <- FoodList
    ], 

    FoodList_Len = length(FoodList), 
    Bin_FoodList = list_to_binary(BinList_FoodList),

    Data = <<
        FoodList_Len:16, Bin_FoodList/binary
    >>,
    {ok, pt:pack(40265, Data)};

write (40266,[
    Rank,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Rank:32,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(40266, Data)};

write (40267,[
    Ratio
]) ->
    Data = <<
        Ratio:32
    >>,
    {ok, pt:pack(40267, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Gtype,
    GtypeId,
    Gnum
}) ->
    Data = <<
        Gtype:8,
        GtypeId:32,
        Gnum:16
    >>,
    Data.
item_to_bin_1 ({
    Gtype,
    GtypeId,
    Gnum
}) ->
    Data = <<
        Gtype:8,
        GtypeId:32,
        Gnum:16
    >>,
    Data.
item_to_bin_2 ({
    GuildId,
    ServerNum,
    GuildName,
    GuildScore,
    GuildRank
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        GuildId:64,
        ServerNum:32,
        Bin_GuildName/binary,
        GuildScore:32,
        GuildRank:16
    >>,
    Data.
item_to_bin_3 ({
    SerId,
    SerNum,
    Rank,
    Name,
    Score
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        SerId:32,
        SerNum:32,
        Rank:16,
        Bin_Name/binary,
        Score:32
    >>,
    Data.
item_to_bin_4 ({
    GuildId,
    GuildName,
    Ranking
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        Ranking:8
    >>,
    Data.
item_to_bin_5 ({
    AGuildId,
    AGname,
    BGuildId,
    BGname,
    VictoryId
}) ->
    Bin_AGname = pt:write_string(AGname), 

    Bin_BGname = pt:write_string(BGname), 

    Data = <<
        AGuildId:64,
        Bin_AGname/binary,
        BGuildId:64,
        Bin_BGname/binary,
        VictoryId:64
    >>,
    Data.
item_to_bin_6 ({
    Division,
    GuildList
}) ->
    BinList_GuildList = [
        item_to_bin_7(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        Division:8,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    Data.
item_to_bin_7 ({
    GuildId,
    GuildName,
    Ranking
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        Ranking:8
    >>,
    Data.
item_to_bin_8 ({
    Division,
    GuildList
}) ->
    BinList_GuildList = [
        item_to_bin_9(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        Division:8,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    Data.
item_to_bin_9 ({
    AGuildId,
    AGname,
    BGuildId,
    BGname,
    VictoryId
}) ->
    Bin_AGname = pt:write_string(AGname), 

    Bin_BGname = pt:write_string(BGname), 

    Data = <<
        AGuildId:64,
        Bin_AGname/binary,
        BGuildId:64,
        Bin_BGname/binary,
        VictoryId:64
    >>,
    Data.
item_to_bin_10 ({
    GuildId,
    GroupId,
    MemberNum,
    Resource,
    ResourcePoint,
    PlusRate
}) ->
    Data = <<
        GuildId:64,
        GroupId:8,
        MemberNum:16,
        Resource:32,
        ResourcePoint:8,
        PlusRate:8
    >>,
    Data.
item_to_bin_11 ({
    Key,
    Val
}) ->
    Data = <<
        Key:8,
        Val:16
    >>,
    Data.
item_to_bin_12 ({
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_13 ({
    StreakTimes,
    Rewards
}) ->
    BinList_Rewards = [
        item_to_bin_14(Rewards_Item) || Rewards_Item <- Rewards
    ], 

    Rewards_Len = length(Rewards), 
    Bin_Rewards = list_to_binary(BinList_Rewards),

    Data = <<
        StreakTimes:16,
        Rewards_Len:16, Bin_Rewards/binary
    >>,
    Data.
item_to_bin_14 ({
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_15 ({
    Id,
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        Id:32,
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_16 ({
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_17 ({
    ObjectType,
    GtypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        GtypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_18 ({
    Type,
    Status
}) ->
    Data = <<
        Type:8,
        Status:8
    >>,
    Data.
item_to_bin_19 ({
    Type,
    Status
}) ->
    Data = <<
        Type:8,
        Status:8
    >>,
    Data.
