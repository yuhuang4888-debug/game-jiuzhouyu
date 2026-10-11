-module(pt_602).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60201, _) ->
    {ok, []};
read(60202, _) ->
    {ok, []};
read(60203, _) ->
    {ok, []};
read(60204, _) ->
    {ok, []};
read(60205, _) ->
    {ok, []};
read(60207, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (60201,[
    Status,
    Etime
]) ->
    Data = <<
        Status:8,
        Etime:32
    >>,
    {ok, pt:pack(60201, Data)};

write (60202,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60202, Data)};

write (60203,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60203, Data)};

write (60204,[
    Etime,
    Group,
    Score,
    Ranking,
    RankList,
    NeedScore,
    StageReward
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Bin_StageReward = pt:write_object_list(StageReward), 

    Data = <<
        Etime:32,
        Group:8,
        Score:16,
        Ranking:8,
        RankList_Len:16, Bin_RankList/binary,
        NeedScore:16,
        Bin_StageReward/binary
    >>,
    {ok, pt:pack(60204, Data)};

write (60205,[
    Score,
    Ranking,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_1(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Score:16,
        Ranking:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(60205, Data)};

write (60206,[
    Score,
    Ranking,
    GroupRanking,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_2(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Score:16,
        Ranking:8,
        GroupRanking:8,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(60206, Data)};

write (60207,[
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(60207, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Group,
    Num,
    Score
}) ->
    Data = <<
        Group:8,
        Num:8,
        Score:32
    >>,
    Data.
item_to_bin_1 ({
    Ranking,
    Group,
    Name,
    Lv,
    Score,
    CombatPower
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Ranking:8,
        Group:8,
        Bin_Name/binary,
        Lv:16,
        Score:16,
        CombatPower:32
    >>,
    Data.
item_to_bin_2 ({
    Type,
    ObjectType,
    TypeId,
    Num
}) ->
    Data = <<
        Type:8,
        ObjectType:8,
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_3 ({
    MinRanking,
    MaxRanking,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        MinRanking:8,
        MaxRanking:8,
        Bin_Reward/binary
    >>,
    Data.
