-module(pt_621).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(62100, _) ->
    {ok, []};
read(62101, _) ->
    {ok, []};
read(62102, _) ->
    {ok, []};
read(62103, _) ->
    {ok, []};
read(62104, _) ->
    {ok, []};
read(62105, _) ->
    {ok, []};
read(62107, _) ->
    {ok, []};
read(62110, Bin0) ->
    <<Area:8, _Bin1/binary>> = Bin0, 
    {ok, [Area]};
read(62111, _) ->
    {ok, []};
read(62112, _) ->
    {ok, []};
read(62114, _) ->
    {ok, []};
read(62115, _) ->
    {ok, []};
read(62116, Bin0) ->
    <<Area:8, _Bin1/binary>> = Bin0, 
    {ok, [Area]};
read(62117, _) ->
    {ok, []};
read(62118, Bin0) ->
    <<Turn:16, Bin1/binary>> = Bin0, 
    <<BattleId:16, Bin2/binary>> = Bin1, 
    <<OptNo:8, Bin3/binary>> = Bin2, 
    <<CostType:8, _Bin4/binary>> = Bin3, 
    {ok, [Turn, BattleId, OptNo, CostType]};
read(62119, _) ->
    {ok, []};
read(62121, Bin0) ->
    <<BattleId:16, _Bin1/binary>> = Bin0, 
    {ok, [BattleId]};
read(62124, _) ->
    {ok, []};
read(62125, Bin0) ->
    <<AuctionId:16, _Bin1/binary>> = Bin0, 
    {ok, [AuctionId]};
read(62126, Bin0) ->
    <<AuctionId:16, Bin1/binary>> = Bin0, 
    <<PriceAdd:32, Bin2/binary>> = Bin1, 
    <<VoucherNum:32, _Bin3/binary>> = Bin2, 
    {ok, [AuctionId, PriceAdd, VoucherNum]};
read(62127, Bin0) ->
    <<Follow:8, _Bin1/binary>> = Bin0, 
    {ok, [Follow]};
read(62128, _) ->
    {ok, []};
read(62129, _) ->
    {ok, []};
read(62130, _) ->
    {ok, []};
read(62131, _) ->
    {ok, []};
read(62133, _) ->
    {ok, []};
read(62134, Bin0) ->
    <<Key:64, _Bin1/binary>> = Bin0, 
    {ok, [Key]};
read(62136, Bin0) ->
    <<Area:8, _Bin1/binary>> = Bin0, 
    {ok, [Area]};
read(_Cmd, _R) -> {error, no_match}.

write (62100,[
    IsSign,
    SignNum,
    DefNum,
    Zone
]) ->
    Data = <<
        IsSign:8,
        SignNum:32,
        DefNum:16,
        Zone:8
    >>,
    {ok, pt:pack(62100, Data)};

write (62101,[
    Stage,
    Turn,
    Edtime,
    SubStage,
    SubEdtime
]) ->
    Data = <<
        Stage:8,
        Turn:16,
        Edtime:32,
        SubStage:8,
        SubEdtime:32
    >>,
    {ok, pt:pack(62101, Data)};

write (62102,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(62102, Data)};

write (62103,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(62103, Data)};

write (62104,[
    LeftTimes,
    Score,
    Time,
    Win,
    Lose,
    ExpSum,
    DefNum
]) ->
    Data = <<
        LeftTimes:8,
        Score:32,
        Time:32,
        Win:16,
        Lose:8,
        ExpSum:64,
        DefNum:16
    >>,
    {ok, pt:pack(62104, Data)};

write (62105,[
    BattleList,
    LoadingTime,
    BattleTime
]) ->
    BinList_BattleList = [
        item_to_bin_0(BattleList_Item) || BattleList_Item <- BattleList
    ], 

    BattleList_Len = length(BattleList), 
    Bin_BattleList = list_to_binary(BinList_BattleList),

    Data = <<
        BattleList_Len:16, Bin_BattleList/binary,
        LoadingTime:32,
        BattleTime:32
    >>,
    {ok, pt:pack(62105, Data)};

write (62107,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(62107, Data)};

write (62108,[
    Result,
    OldScore,
    AddScore,
    LeftTimes,
    IsTimeout,
    BattleList
]) ->
    BinList_BattleList = [
        item_to_bin_1(BattleList_Item) || BattleList_Item <- BattleList
    ], 

    BattleList_Len = length(BattleList), 
    Bin_BattleList = list_to_binary(BinList_BattleList),

    Data = <<
        Result:8,
        OldScore:32,
        AddScore:16,
        LeftTimes:8,
        IsTimeout:8,
        BattleList_Len:16, Bin_BattleList/binary
    >>,
    {ok, pt:pack(62108, Data)};

write (62109,[
    IsDef,
    Rank,
    Score,
    Award
]) ->
    Bin_Award = pt:write_object_list(Award), 

    Data = <<
        IsDef:8,
        Rank:16,
        Score:32,
        Bin_Award/binary
    >>,
    {ok, pt:pack(62109, Data)};

write (62110,[
    Area,
    Rank1List
]) ->
    BinList_Rank1List = [
        item_to_bin_2(Rank1List_Item) || Rank1List_Item <- Rank1List
    ], 

    Rank1List_Len = length(Rank1List), 
    Bin_Rank1List = list_to_binary(BinList_Rank1List),

    Data = <<
        Area:8,
        Rank1List_Len:16, Bin_Rank1List/binary
    >>,
    {ok, pt:pack(62110, Data)};

write (62111,[
    Score,
    ExpSum,
    IsDef
]) ->
    Data = <<
        Score:32,
        ExpSum:64,
        IsDef:8
    >>,
    {ok, pt:pack(62111, Data)};

write (62112,[
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Career,
    CombatPower,
    Win,
    Lose,
    Sex,
    Picture,
    PictureVer,
    Lv,
    ChallengerList,
    LoadingTime,
    BattleTime
]) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_ChallengerList = [
        item_to_bin_3(ChallengerList_Item) || ChallengerList_Item <- ChallengerList
    ], 

    ChallengerList_Len = length(ChallengerList), 
    Bin_ChallengerList = list_to_binary(BinList_ChallengerList),

    Data = <<
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Career:8,
        CombatPower:64,
        Win:16,
        Lose:8,
        Sex:8,
        Bin_Picture/binary,
        PictureVer:32,
        Lv:16,
        ChallengerList_Len:16, Bin_ChallengerList/binary,
        LoadingTime:32,
        BattleTime:32
    >>,
    {ok, pt:pack(62112, Data)};

write (62113,[
    Result,
    ChallengerNum,
    TotalChallengerNum,
    RoleId,
    Platform,
    ServerNum,
    Name,
    Career,
    Sex,
    Picture,
    PictureVer,
    Lv,
    Hp,
    HpLim,
    Award
]) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Bin_Award = pt:write_object_list(Award), 

    Data = <<
        Result:8,
        ChallengerNum:8,
        TotalChallengerNum:8,
        RoleId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_Name/binary,
        Career:8,
        Sex:8,
        Bin_Picture/binary,
        PictureVer:32,
        Lv:16,
        Hp:64,
        HpLim:64,
        Bin_Award/binary
    >>,
    {ok, pt:pack(62113, Data)};

write (62114,[
    Rank2DefRank
]) ->
    BinList_Rank2DefRank = [
        item_to_bin_4(Rank2DefRank_Item) || Rank2DefRank_Item <- Rank2DefRank
    ], 

    Rank2DefRank_Len = length(Rank2DefRank), 
    Bin_Rank2DefRank = list_to_binary(BinList_Rank2DefRank),

    Data = <<
        Rank2DefRank_Len:16, Bin_Rank2DefRank/binary
    >>,
    {ok, pt:pack(62114, Data)};

write (62115,[
    Rank2ScoreRank
]) ->
    BinList_Rank2ScoreRank = [
        item_to_bin_5(Rank2ScoreRank_Item) || Rank2ScoreRank_Item <- Rank2ScoreRank
    ], 

    Rank2ScoreRank_Len = length(Rank2ScoreRank), 
    Bin_Rank2ScoreRank = list_to_binary(BinList_Rank2ScoreRank),

    Data = <<
        Rank2ScoreRank_Len:16, Bin_Rank2ScoreRank/binary
    >>,
    {ok, pt:pack(62115, Data)};

write (62116,[
    Area,
    Rank2DefRank,
    DailyAward
]) ->
    BinList_Rank2DefRank = [
        item_to_bin_6(Rank2DefRank_Item) || Rank2DefRank_Item <- Rank2DefRank
    ], 

    Rank2DefRank_Len = length(Rank2DefRank), 
    Bin_Rank2DefRank = list_to_binary(BinList_Rank2DefRank),

    Bin_DailyAward = pt:write_object_list(DailyAward), 

    Data = <<
        Area:8,
        Rank2DefRank_Len:16, Bin_Rank2DefRank/binary,
        Bin_DailyAward/binary
    >>,
    {ok, pt:pack(62116, Data)};

write (62117,[
    BetList,
    DefNum,
    BetNum
]) ->
    BinList_BetList = [
        item_to_bin_7(BetList_Item) || BetList_Item <- BetList
    ], 

    BetList_Len = length(BetList), 
    Bin_BetList = list_to_binary(BinList_BetList),

    Data = <<
        BetList_Len:16, Bin_BetList/binary,
        DefNum:16,
        BetNum:8
    >>,
    {ok, pt:pack(62117, Data)};

write (62118,[
    ErrorCode,
    Turn,
    BattleId
]) ->
    Data = <<
        ErrorCode:32,
        Turn:16,
        BattleId:16
    >>,
    {ok, pt:pack(62118, Data)};

write (62119,[
    Rank,
    TopName
]) ->
    Bin_TopName = pt:write_string(TopName), 

    Data = <<
        Rank:8,
        Bin_TopName/binary
    >>,
    {ok, pt:pack(62119, Data)};

write (62120,[
    Rank,
    Score,
    Award,
    Turn
]) ->
    Bin_Award = pt:write_object_list(Award), 

    Data = <<
        Rank:8,
        Score:16,
        Bin_Award/binary,
        Turn:8
    >>,
    {ok, pt:pack(62120, Data)};

write (62121,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(62121, Data)};

write (62122,[
    ExpSum
]) ->
    Data = <<
        ExpSum:64
    >>,
    {ok, pt:pack(62122, Data)};

write (62123,[
    BattleId,
    BattleResult,
    BetResult
]) ->
    Data = <<
        BattleId:16,
        BattleResult:8,
        BetResult:8
    >>,
    {ok, pt:pack(62123, Data)};

write (62124,[
    AuctionList,
    Edtime
]) ->
    BinList_AuctionList = [
        item_to_bin_9(AuctionList_Item) || AuctionList_Item <- AuctionList
    ], 

    AuctionList_Len = length(AuctionList), 
    Bin_AuctionList = list_to_binary(BinList_AuctionList),

    Data = <<
        AuctionList_Len:16, Bin_AuctionList/binary,
        Edtime:32
    >>,
    {ok, pt:pack(62124, Data)};

write (62125,[
    AuctionId,
    AuctionRankList
]) ->
    BinList_AuctionRankList = [
        item_to_bin_10(AuctionRankList_Item) || AuctionRankList_Item <- AuctionRankList
    ], 

    AuctionRankList_Len = length(AuctionRankList), 
    Bin_AuctionRankList = list_to_binary(BinList_AuctionRankList),

    Data = <<
        AuctionId:16,
        AuctionRankList_Len:16, Bin_AuctionRankList/binary
    >>,
    {ok, pt:pack(62125, Data)};

write (62126,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(62126, Data)};

write (62127,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(62127, Data)};

write (62128,[
    PastAuctionList
]) ->
    BinList_PastAuctionList = [
        item_to_bin_11(PastAuctionList_Item) || PastAuctionList_Item <- PastAuctionList
    ], 

    PastAuctionList_Len = length(PastAuctionList), 
    Bin_PastAuctionList = list_to_binary(BinList_PastAuctionList),

    Data = <<
        PastAuctionList_Len:16, Bin_PastAuctionList/binary
    >>,
    {ok, pt:pack(62128, Data)};

write (62129,[
    Stage,
    Edtime
]) ->
    Data = <<
        Stage:8,
        Edtime:32
    >>,
    {ok, pt:pack(62129, Data)};

write (62130,[
    SignNum,
    RoleList,
    MyPower
]) ->
    BinList_RoleList = [
        item_to_bin_12(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        SignNum:32,
        RoleList_Len:16, Bin_RoleList/binary,
        MyPower:32
    >>,
    {ok, pt:pack(62130, Data)};

write (62131,[
    DefType,
    Turn
]) ->
    Data = <<
        DefType:8,
        Turn:8
    >>,
    {ok, pt:pack(62131, Data)};

write (62132,[
    ErrorCode,
    ErrorArgs
]) ->
    Bin_ErrorArgs = pt:write_string(ErrorArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorArgs/binary
    >>,
    {ok, pt:pack(62132, Data)};

write (62133,[
    BetList
]) ->
    BinList_BetList = [
        item_to_bin_13(BetList_Item) || BetList_Item <- BetList
    ], 

    BetList_Len = length(BetList), 
    Bin_BetList = list_to_binary(BinList_BetList),

    Data = <<
        BetList_Len:16, Bin_BetList/binary
    >>,
    {ok, pt:pack(62133, Data)};

write (62134,[
    Key
]) ->
    Data = <<
        Key:64
    >>,
    {ok, pt:pack(62134, Data)};

write (62135,[
    BattleId,
    BattleResult
]) ->
    Data = <<
        BattleId:16,
        BattleResult:8
    >>,
    {ok, pt:pack(62135, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Career,
    CombatPower,
    Win,
    Lose,
    Sex,
    Picture,
    PictureVer,
    Lv
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Career:8,
        CombatPower:64,
        Win:16,
        Lose:8,
        Sex:8,
        Bin_Picture/binary,
        PictureVer:32,
        Lv:16
    >>,
    Data.
item_to_bin_1 ({
    PlayerId,
    Platform,
    ServerNum,
    Name,
    Career,
    Sex,
    Picture,
    PictureVer,
    Lv,
    Hp,
    HpLim
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_Name/binary,
        Career:8,
        Sex:8,
        Bin_Picture/binary,
        PictureVer:32,
        Lv:16,
        Hp:64,
        HpLim:64
    >>,
    Data.
item_to_bin_2 ({
    Rank,
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Gname,
    Vip,
    Score,
    Win,
    Lose,
    CombatPower,
    Career,
    Lv
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Gname = pt:write_string(Gname), 

    Data = <<
        Rank:8,
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Bin_Gname/binary,
        Vip:8,
        Score:32,
        Win:16,
        Lose:8,
        CombatPower:64,
        Career:8,
        Lv:16
    >>,
    Data.
item_to_bin_3 ({
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Career,
    Turn,
    Sex,
    Picture,
    PictureVer,
    Lv,
    CombatPower
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Career:8,
        Turn:8,
        Sex:8,
        Bin_Picture/binary,
        PictureVer:32,
        Lv:16,
        CombatPower:64
    >>,
    Data.
item_to_bin_4 ({
    Rank,
    PlayerId,
    Platform,
    ServerNum,
    Name,
    Gname,
    Vip,
    Score,
    Turn,
    Lose,
    CombatPower,
    SurvivalTime,
    Lv
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Name = pt:write_string(Name), 

    Bin_Gname = pt:write_string(Gname), 

    Data = <<
        Rank:8,
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_Name/binary,
        Bin_Gname/binary,
        Vip:8,
        Score:32,
        Turn:8,
        Lose:8,
        CombatPower:64,
        SurvivalTime:16,
        Lv:16
    >>,
    Data.
item_to_bin_5 ({
    Rank,
    PlayerId,
    ServerNum,
    Name,
    Gname,
    Vip,
    Score,
    CombatPower,
    Career
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Gname = pt:write_string(Gname), 

    Data = <<
        Rank:8,
        PlayerId:64,
        ServerNum:16,
        Bin_Name/binary,
        Bin_Gname/binary,
        Vip:8,
        Score:32,
        CombatPower:64,
        Career:8
    >>,
    Data.
item_to_bin_6 ({
    Rank,
    ServerId,
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Gname,
    Vip,
    Score,
    Turn,
    CombatPower,
    Career,
    SurvivalTime,
    Lose,
    Lv,
    Hp,
    HpLim
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Gname = pt:write_string(Gname), 

    Data = <<
        Rank:8,
        ServerId:16,
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Bin_Gname/binary,
        Vip:8,
        Score:32,
        Turn:8,
        CombatPower:64,
        Career:8,
        SurvivalTime:16,
        Lose:8,
        Lv:16,
        Hp:64,
        HpLim:64
    >>,
    Data.
item_to_bin_7 ({
    BattleId,
    Status,
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Career,
    Turn,
    Sex,
    Lv,
    Picture,
    PictureVer,
    CombatPower,
    ChallengerList,
    BattleResult,
    IsBet,
    BetResult
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_ChallengerList = [
        item_to_bin_8(ChallengerList_Item) || ChallengerList_Item <- ChallengerList
    ], 

    ChallengerList_Len = length(ChallengerList), 
    Bin_ChallengerList = list_to_binary(BinList_ChallengerList),

    Data = <<
        BattleId:16,
        Status:8,
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Career:8,
        Turn:8,
        Sex:8,
        Lv:16,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64,
        ChallengerList_Len:16, Bin_ChallengerList/binary,
        BattleResult:8,
        IsBet:8,
        BetResult:8
    >>,
    Data.
item_to_bin_8 ({
    PlayerId,
    Platform,
    ServerNum,
    ServerName,
    Name,
    Career,
    Turn,
    Sex,
    Lv,
    Picture,
    PictureVer,
    CombatPower
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_ServerName = pt:write_string(ServerName), 

    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        PlayerId:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_ServerName/binary,
        Bin_Name/binary,
        Career:8,
        Turn:8,
        Sex:8,
        Lv:16,
        Bin_Picture/binary,
        PictureVer:32,
        CombatPower:64
    >>,
    Data.
item_to_bin_9 ({
    AuctionId,
    Result,
    LastPrice,
    MyPrice
}) ->
    Data = <<
        AuctionId:16,
        Result:8,
        LastPrice:32,
        MyPrice:32
    >>,
    Data.
item_to_bin_10 ({
    ServerNum,
    Name,
    Price
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        ServerNum:16,
        Bin_Name/binary,
        Price:32
    >>,
    Data.
item_to_bin_11 ({
    Issue,
    ServerNum,
    Name,
    Award,
    Price
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Award = pt:write_object_list(Award), 

    Data = <<
        Issue:32,
        ServerNum:16,
        Bin_Name/binary,
        Bin_Award/binary,
        Price:32
    >>,
    Data.
item_to_bin_12 ({
    RoleId,
    RoleName,
    ServerName,
    Power
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Bin_ServerName/binary,
        Power:32
    >>,
    Data.
item_to_bin_13 ({
    Key,
    Platform,
    ServerNum,
    Name,
    Race2Turn,
    BetCostType,
    BetResult,
    Status
}) ->
    Bin_Platform = pt:write_string(Platform), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        Key:64,
        Bin_Platform/binary,
        ServerNum:16,
        Bin_Name/binary,
        Race2Turn:8,
        BetCostType:8,
        BetResult:8,
        Status:8
    >>,
    Data.
