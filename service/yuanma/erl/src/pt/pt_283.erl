-module(pt_283).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28301, Bin0) ->
    <<SanctuaryId:8, _Bin1/binary>> = Bin0, 
    {ok, [SanctuaryId]};
read(28302, _) ->
    {ok, []};
read(28303, Bin0) ->
    <<SanctuaryId:8, _Bin1/binary>> = Bin0, 
    {ok, [SanctuaryId]};
read(28304, _) ->
    {ok, []};
read(28305, Bin0) ->
    <<SanctuaryId:8, Bin1/binary>> = Bin0, 
    <<BossId:32, Bin2/binary>> = Bin1, 
    <<Remind:8, _Bin3/binary>> = Bin2, 
    {ok, [SanctuaryId, BossId, Remind]};
read(28308, _) ->
    {ok, []};
read(28310, _) ->
    {ok, []};
read(28311, Bin0) ->
    <<SanctuaryId:8, Bin1/binary>> = Bin0, 
    <<BossId:32, _Bin2/binary>> = Bin1, 
    {ok, [SanctuaryId, BossId]};
read(28312, Bin0) ->
    <<SanctuaryId:8, _Bin1/binary>> = Bin0, 
    {ok, [SanctuaryId]};
read(28314, _) ->
    {ok, []};
read(28315, _) ->
    {ok, []};
read(28316, _) ->
    {ok, []};
read(28318, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (28300,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(28300, Data)};

write (28301,[
    SanctuaryId,
    Point,
    Belong,
    BelongName,
    EndTime,
    BossInfo
]) ->
    Bin_BelongName = pt:write_string(BelongName), 

    BinList_BossInfo = [
        item_to_bin_0(BossInfo_Item) || BossInfo_Item <- BossInfo
    ], 

    BossInfo_Len = length(BossInfo), 
    Bin_BossInfo = list_to_binary(BinList_BossInfo),

    Data = <<
        SanctuaryId:8,
        Point:32,
        Belong:64,
        Bin_BelongName/binary,
        EndTime:32,
        BossInfo_Len:16, Bin_BossInfo/binary
    >>,
    {ok, pt:pack(28301, Data)};

write (28302,[
    MyGuildRank,
    MyGuildPowerTen,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_1(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        MyGuildRank:32,
        MyGuildPowerTen:64,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28302, Data)};

write (28303,[
    SanctuaryId,
    Code
]) ->
    Data = <<
        SanctuaryId:8,
        Code:32
    >>,
    {ok, pt:pack(28303, Data)};



write (28305,[
    SanctuaryId,
    BossId,
    Remind
]) ->
    Data = <<
        SanctuaryId:8,
        BossId:32,
        Remind:8
    >>,
    {ok, pt:pack(28305, Data)};

write (28306,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(28306, Data)};

write (28307,[
    SanctuaryId,
    BossId
]) ->
    Data = <<
        SanctuaryId:8,
        BossId:32
    >>,
    {ok, pt:pack(28307, Data)};

write (28308,[
    DieTimes,
    Time,
    DieTime,
    SafeTime
]) ->
    Data = <<
        DieTimes:16,
        Time:32,
        DieTime:32,
        SafeTime:32
    >>,
    {ok, pt:pack(28308, Data)};

write (28309,[
    SanctuaryId,
    BossId,
    RebornTime
]) ->
    Data = <<
        SanctuaryId:8,
        BossId:32,
        RebornTime:32
    >>,
    {ok, pt:pack(28309, Data)};

write (28310,[
    MyRank,
    MyPower,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_2(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        MyRank:32,
        MyPower:64,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28310, Data)};

write (28311,[
    SanctuaryId,
    BossId,
    KillLog
]) ->
    BinList_KillLog = [
        item_to_bin_3(KillLog_Item) || KillLog_Item <- KillLog
    ], 

    KillLog_Len = length(KillLog), 
    Bin_KillLog = list_to_binary(BinList_KillLog),

    Data = <<
        SanctuaryId:8,
        BossId:32,
        KillLog_Len:16, Bin_KillLog/binary
    >>,
    {ok, pt:pack(28311, Data)};

write (28312,[
    SanctuaryId,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_4(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        SanctuaryId:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(28312, Data)};

write (28313,[
    SanctuaryId,
    BossId
]) ->
    Data = <<
        SanctuaryId:8,
        BossId:32
    >>,
    {ok, pt:pack(28313, Data)};

write (28314,[
    GuildRank,
    SanctuaryId,
    PersonRank,
    DesinationId
]) ->
    Data = <<
        GuildRank:32,
        SanctuaryId:8,
        PersonRank:32,
        DesinationId:32
    >>,
    {ok, pt:pack(28314, Data)};

write (28315,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(28315, Data)};

write (28316,[
    Code
]) ->
    Data = <<
        Code:8
    >>,
    {ok, pt:pack(28316, Data)};

write (28317,[
    Point
]) ->
    Data = <<
        Point:32
    >>,
    {ok, pt:pack(28317, Data)};

write (28318,[
    Fatigue
]) ->
    Data = <<
        Fatigue:32
    >>,
    {ok, pt:pack(28318, Data)};

write (28319,[
    Fatigue
]) ->
    Data = <<
        Fatigue:32
    >>,
    {ok, pt:pack(28319, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BossId,
    RebornTime,
    IsRemind
}) ->
    Data = <<
        BossId:32,
        RebornTime:32,
        IsRemind:8
    >>,
    Data.
item_to_bin_1 ({
    GuildName,
    GuildChairmanName,
    Rank,
    MenberNum,
    AllNum,
    AvgPower
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_GuildChairmanName = pt:write_string(GuildChairmanName), 

    Data = <<
        Bin_GuildName/binary,
        Bin_GuildChairmanName/binary,
        Rank:32,
        MenberNum:32,
        AllNum:32,
        AvgPower:64
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    Rank,
    Picture,
    PictureVer,
    Career,
    RoleName,
    Power,
    Desination
}) ->
    Bin_Picture = pt:write_string(Picture), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Rank:32,
        Bin_Picture/binary,
        PictureVer:32,
        Career:8,
        Bin_RoleName/binary,
        Power:64,
        Desination:32
    >>,
    Data.
item_to_bin_3 ({
    Time,
    Name,
    IsShow,
    ReducePoint
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Time:32,
        Bin_Name/binary,
        IsShow:8,
        ReducePoint:32
    >>,
    Data.
item_to_bin_4 ({
    Rank,
    RoleName,
    Power,
    Desination
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:32,
        Bin_RoleName/binary,
        Power:64,
        Desination:32
    >>,
    Data.
