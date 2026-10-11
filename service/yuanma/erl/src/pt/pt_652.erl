-module(pt_652).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(65201, _) ->
    {ok, []};
read(65202, _) ->
    {ok, []};
read(65206, _) ->
    {ok, []};
read(65208, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (65201,[
    BelongList,
    TerritoryScore,
    HaveTerritory
]) ->
    BinList_BelongList = [
        item_to_bin_0(BelongList_Item) || BelongList_Item <- BelongList
    ], 

    BelongList_Len = length(BelongList), 
    Bin_BelongList = list_to_binary(BinList_BelongList),

    Data = <<
        BelongList_Len:16, Bin_BelongList/binary,
        TerritoryScore:16,
        HaveTerritory:8
    >>,
    {ok, pt:pack(65201, Data)};

write (65202,[
    Code,
    Dunid,
    TotalWave,
    FirstWaveTime,
    Wave,
    Num,
    EndTime
]) ->
    Data = <<
        Code:32,
        Dunid:32,
        TotalWave:16,
        FirstWaveTime:32,
        Wave:16,
        Num:16,
        EndTime:32
    >>,
    {ok, pt:pack(65202, Data)};

write (65203,[
    SelfRank,
    SelfDamage,
    SelfName,
    Distance
]) ->
    Bin_SelfName = pt:write_string(SelfName), 

    Data = <<
        SelfRank:8,
        SelfDamage:64,
        Bin_SelfName/binary,
        Distance:64
    >>,
    {ok, pt:pack(65203, Data)};

write (65204,[
    Rank,
    Wave,
    Num,
    Time
]) ->
    BinList_Rank = [
        item_to_bin_1(Rank_Item) || Rank_Item <- Rank
    ], 

    Rank_Len = length(Rank), 
    Bin_Rank = list_to_binary(BinList_Rank),

    Data = <<
        Rank_Len:16, Bin_Rank/binary,
        Wave:16,
        Num:16,
        Time:32
    >>,
    {ok, pt:pack(65204, Data)};

write (65205,[
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Bin_Reward/binary
    >>,
    {ok, pt:pack(65205, Data)};

write (65206,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65206, Data)};

write (65207,[
    JoinNum,
    Goods
]) ->
    BinList_Goods = [
        item_to_bin_2(Goods_Item) || Goods_Item <- Goods
    ], 

    Goods_Len = length(Goods), 
    Bin_Goods = list_to_binary(BinList_Goods),

    Data = <<
        JoinNum:16,
        Goods_Len:16, Bin_Goods/binary
    >>,
    {ok, pt:pack(65207, Data)};

write (65208,[
    Dunid,
    EndTime
]) ->
    Data = <<
        Dunid:32,
        EndTime:32
    >>,
    {ok, pt:pack(65208, Data)};

write (65209,[
    MonId,
    X,
    Y
]) ->
    Data = <<
        MonId:32,
        X:16,
        Y:16
    >>,
    {ok, pt:pack(65209, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Dunid,
    Score,
    GuildId,
    GuildName
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Dunid:32,
        Score:16,
        GuildId:64,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_1 ({
    RoleName,
    Damage
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        Damage:64
    >>,
    Data.
item_to_bin_2 ({
    GoodsId,
    Num,
    GoldType,
    Worth
}) ->
    Data = <<
        GoodsId:32,
        Num:16,
        GoldType:8,
        Worth:16
    >>,
    Data.
