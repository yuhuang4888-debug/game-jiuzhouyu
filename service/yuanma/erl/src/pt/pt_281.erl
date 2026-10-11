-module(pt_281).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28101, _) ->
    {ok, []};
read(28102, _) ->
    {ok, []};
read(28103, Bin0) ->
    <<Count:8, _Bin1/binary>> = Bin0, 
    {ok, [Count]};
read(28104, Bin0) ->
    <<BuyCount:16, _Bin1/binary>> = Bin0, 
    {ok, [BuyCount]};
read(28105, _) ->
    {ok, []};
read(28106, Bin0) ->
    <<RankLv:8, _Bin1/binary>> = Bin0, 
    {ok, [RankLv]};
read(28107, _) ->
    {ok, []};
read(28110, _) ->
    {ok, []};
read(28114, _) ->
    {ok, []};
read(28115, _) ->
    {ok, []};
read(28116, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (28100,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(28100, Data)};

write (28101,[
    SeasonNum,
    SeasonEndTime,
    RankLv,
    Point,
    SeasonCount,
    SeasonWinCount,
    DailyHonorValue,
    HonorIsGot,
    DailyCount,
    DailyRewardCounts,
    DailyBuyCount,
    YesterdayRankLv
]) ->
    BinList_DailyRewardCounts = [
        item_to_bin_0(DailyRewardCounts_Item) || DailyRewardCounts_Item <- DailyRewardCounts
    ], 

    DailyRewardCounts_Len = length(DailyRewardCounts), 
    Bin_DailyRewardCounts = list_to_binary(BinList_DailyRewardCounts),

    Data = <<
        SeasonNum:16,
        SeasonEndTime:32,
        RankLv:8,
        Point:32,
        SeasonCount:32,
        SeasonWinCount:32,
        DailyHonorValue:32,
        HonorIsGot:8,
        DailyCount:16,
        DailyRewardCounts_Len:16, Bin_DailyRewardCounts/binary,
        DailyBuyCount:16,
        YesterdayRankLv:8
    >>,
    {ok, pt:pack(28101, Data)};

write (28102,[
    RewardObjList
]) ->
    Bin_RewardObjList = pt:write_object_list(RewardObjList), 

    Data = <<
        Bin_RewardObjList/binary
    >>,
    {ok, pt:pack(28102, Data)};

write (28103,[
    Count,
    RewardObjList
]) ->
    Bin_RewardObjList = pt:write_object_list(RewardObjList), 

    Data = <<
        Count:8,
        Bin_RewardObjList/binary
    >>,
    {ok, pt:pack(28103, Data)};

write (28104,[
    DailyBuyCount
]) ->
    Data = <<
        DailyBuyCount:16
    >>,
    {ok, pt:pack(28104, Data)};

write (28105,[
    GotList
]) ->
    BinList_GotList = [
        item_to_bin_1(GotList_Item) || GotList_Item <- GotList
    ], 

    GotList_Len = length(GotList), 
    Bin_GotList = list_to_binary(BinList_GotList),

    Data = <<
        GotList_Len:16, Bin_GotList/binary
    >>,
    {ok, pt:pack(28105, Data)};

write (28106,[
    RankLv,
    RewardObjList
]) ->
    Bin_RewardObjList = pt:write_object_list(RewardObjList), 

    Data = <<
        RankLv:8,
        Bin_RewardObjList/binary
    >>,
    {ok, pt:pack(28106, Data)};

write (28107,[
    State,
    StartTime,
    EndTime
]) ->
    Data = <<
        State:8,
        StartTime:32,
        EndTime:32
    >>,
    {ok, pt:pack(28107, Data)};

write (28110,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(28110, Data)};

write (28111,[
    Res,
    MyRankLv,
    EnemyRankLv,
    FakeManPower
]) ->
    Data = <<
        Res:8,
        MyRankLv:8,
        EnemyRankLv:8,
        FakeManPower:64
    >>,
    {ok, pt:pack(28111, Data)};

write (28112,[
    Stage,
    Time
]) ->
    Data = <<
        Stage:8,
        Time:32
    >>,
    {ok, pt:pack(28112, Data)};

write (28113,[
    Res,
    Honor,
    Flag,
    Point
]) ->
    Data = <<
        Res:8,
        Honor:32,
        Flag:8,
        Point:32
    >>,
    {ok, pt:pack(28113, Data)};

write (28114,[
    Res
]) ->
    Data = <<
        Res:8
    >>,
    {ok, pt:pack(28114, Data)};

write (28115,[
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_2(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28115, Data)};



write (28117,[
    OldRankLv,
    OldPoint,
    NewRankLv,
    NewPoint
]) ->
    Data = <<
        OldRankLv:8,
        OldPoint:32,
        NewRankLv:8,
        NewPoint:32
    >>,
    {ok, pt:pack(28117, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Count,
    State
}) ->
    Data = <<
        Count:8,
        State:8
    >>,
    Data.
item_to_bin_1 ({
    RankLv,
    State
}) ->
    Data = <<
        RankLv:8,
        State:8
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    RoleName,
    Career,
    Power,
    GuildName,
    Platform,
    Server,
    RankLv,
    Point
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Bin_Platform = pt:write_string(Platform), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Power:64,
        Bin_GuildName/binary,
        Bin_Platform/binary,
        Server:16,
        RankLv:8,
        Point:32
    >>,
    Data.
