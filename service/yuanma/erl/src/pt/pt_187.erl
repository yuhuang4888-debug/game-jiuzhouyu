-module(pt_187).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18701, _) ->
    {ok, []};
read(18702, Bin0) ->
    <<SeaId:8, _Bin1/binary>> = Bin0, 
    {ok, [SeaId]};
read(18703, _) ->
    {ok, []};
read(18704, Bin0) ->
    <<SeaId:8, _Bin1/binary>> = Bin0, 
    {ok, [SeaId]};
read(18705, Bin0) ->
    <<SeaId:8, _Bin1/binary>> = Bin0, 
    {ok, [SeaId]};
read(18706, _) ->
    {ok, []};
read(18707, Bin0) ->
    <<UpLv:8, _Bin1/binary>> = Bin0, 
    {ok, [UpLv]};
read(18708, _) ->
    {ok, []};
read(18709, _) ->
    {ok, []};
read(18711, _) ->
    {ok, []};
read(18712, _) ->
    {ok, []};
read(18713, Bin0) ->
    <<TaskId:8, _Bin1/binary>> = Bin0, 
    {ok, [TaskId]};
read(18715, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (18700,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18700, Data)};

write (18701,[
    SeaList
]) ->
    BinList_SeaList = [
        item_to_bin_0(SeaList_Item) || SeaList_Item <- SeaList
    ], 

    SeaList_Len = length(SeaList), 
    Bin_SeaList = list_to_binary(BinList_SeaList),

    Data = <<
        SeaList_Len:16, Bin_SeaList/binary
    >>,
    {ok, pt:pack(18701, Data)};



write (18703,[
    SeaId,
    BrickNum,
    CarryCount,
    DefendCount,
    BossList
]) ->
    BinList_BossList = [
        item_to_bin_1(BossList_Item) || BossList_Item <- BossList
    ], 

    BossList_Len = length(BossList), 
    Bin_BossList = list_to_binary(BinList_BossList),

    Data = <<
        SeaId:32,
        BrickNum:32,
        CarryCount:16,
        DefendCount:16,
        BossList_Len:16, Bin_BossList/binary
    >>,
    {ok, pt:pack(18703, Data)};

write (18704,[
    SeaId,
    MyNum,
    MyRank,
    MyPower,
    MyPos,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_2(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        SeaId:32,
        MyNum:32,
        MyRank:32,
        MyPower:64,
        MyPos:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(18704, Data)};

write (18705,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18705, Data)};

write (18706,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18706, Data)};

write (18707,[
    Lv,
    Code
]) ->
    Data = <<
        Lv:8,
        Code:8
    >>,
    {ok, pt:pack(18707, Data)};





write (18710,[
    CarryCount,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        CarryCount:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(18710, Data)};

write (18711,[
    MyNum,
    MySea,
    MyRank,
    MyPower,
    MyPos,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_3(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        MyNum:32,
        MySea:8,
        MyRank:32,
        MyPower:64,
        MyPos:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(18711, Data)};

write (18712,[
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_4(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(18712, Data)};

write (18713,[
    Code,
    TaskId,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Code:32,
        TaskId:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(18713, Data)};

write (18714,[
    Code
]) ->
    Data = <<
        Code:8
    >>,
    {ok, pt:pack(18714, Data)};

write (18715,[
    SeaList
]) ->
    BinList_SeaList = [
        item_to_bin_5(SeaList_Item) || SeaList_Item <- SeaList
    ], 

    SeaList_Len = length(SeaList), 
    Bin_SeaList = list_to_binary(BinList_SeaList),

    Data = <<
        SeaList_Len:16, Bin_SeaList/binary
    >>,
    {ok, pt:pack(18715, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SeaId,
    StatueTime,
    BossTime,
    BrickNum,
    BrickColor
}) ->
    Data = <<
        SeaId:8,
        StatueTime:32,
        BossTime:32,
        BrickNum:32,
        BrickColor:8
    >>,
    Data.
item_to_bin_1 ({
    Id,
    Lv,
    Name,
    RebornTime
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Id:32,
        Lv:16,
        Bin_Name/binary,
        RebornTime:32
    >>,
    Data.
item_to_bin_2 ({
    Pos,
    ServerNum,
    RoleName,
    Power,
    Num
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Pos:8,
        ServerNum:32,
        Bin_RoleName/binary,
        Power:64,
        Num:32
    >>,
    Data.
item_to_bin_3 ({
    SeaId,
    Pos,
    ServerNum,
    RoleName,
    Power,
    Num
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        SeaId:8,
        Pos:8,
        ServerNum:32,
        Bin_RoleName/binary,
        Power:64,
        Num:32
    >>,
    Data.
item_to_bin_4 ({
    TaskId,
    Count,
    Status
}) ->
    Data = <<
        TaskId:8,
        Count:16,
        Status:8
    >>,
    Data.
item_to_bin_5 ({
    SeaId,
    GuildId,
    GuildName
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        SeaId:8,
        GuildId:64,
        Bin_GuildName/binary
    >>,
    Data.
