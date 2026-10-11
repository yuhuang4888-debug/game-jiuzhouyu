-module(pt_508).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(50801, _) ->
    {ok, []};
read(50802, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    <<Rank1:8, Bin2/binary>> = Bin1, 
    <<Rank2:8, _Bin3/binary>> = Bin2, 
    {ok, [DunId, Rank1, Rank2]};
read(50805, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (50801,[
    DunList
]) ->
    BinList_DunList = [
        item_to_bin_0(DunList_Item) || DunList_Item <- DunList
    ], 

    DunList_Len = length(DunList), 
    Bin_DunList = list_to_binary(BinList_DunList),

    Data = <<
        DunList_Len:16, Bin_DunList/binary
    >>,
    {ok, pt:pack(50801, Data)};

write (50802,[
    DunId,
    SelfRank,
    SelfPassTime,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_2(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        DunId:32,
        SelfRank:8,
        SelfPassTime:16,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(50802, Data)};

write (50805,[
    ResultType,
    DunId,
    GoTime,
    DunRewards,
    RoleBossList
]) ->
    BinList_DunRewards = [
        item_to_bin_4(DunRewards_Item) || DunRewards_Item <- DunRewards
    ], 

    DunRewards_Len = length(DunRewards), 
    Bin_DunRewards = list_to_binary(BinList_DunRewards),

    BinList_RoleBossList = [
        item_to_bin_5(RoleBossList_Item) || RoleBossList_Item <- RoleBossList
    ], 

    RoleBossList_Len = length(RoleBossList), 
    Bin_RoleBossList = list_to_binary(BinList_RoleBossList),

    Data = <<
        ResultType:8,
        DunId:32,
        GoTime:32,
        DunRewards_Len:16, Bin_DunRewards/binary,
        RoleBossList_Len:16, Bin_RoleBossList/binary
    >>,
    {ok, pt:pack(50805, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    DunId,
    DunScore,
    SingleSucc,
    TeamSucc,
    HelpTimes,
    BossReward
}) ->
    BinList_BossReward = [
        item_to_bin_1(BossReward_Item) || BossReward_Item <- BossReward
    ], 

    BossReward_Len = length(BossReward), 
    Bin_BossReward = list_to_binary(BinList_BossReward),

    Data = <<
        DunId:32,
        DunScore:16,
        SingleSucc:8,
        TeamSucc:8,
        HelpTimes:16,
        BossReward_Len:16, Bin_BossReward/binary
    >>,
    Data.
item_to_bin_1 ({
    BossId,
    RewardSt
}) ->
    Data = <<
        BossId:32,
        RewardSt:8
    >>,
    Data.
item_to_bin_2 ({
    PassTime,
    Time,
    Rank,
    RoleList
}) ->
    BinList_RoleList = [
        item_to_bin_3(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        PassTime:16,
        Time:32,
        Rank:8,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    Data.
item_to_bin_3 ({
    RoleId,
    RoleName,
    ServerId,
    ServerNum
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        ServerId:16,
        ServerNum:16
    >>,
    Data.
item_to_bin_4 ({
    Type,
    Times,
    DunRewardsList
}) ->
    Bin_DunRewardsList = pt:write_object_list(DunRewardsList), 

    Data = <<
        Type:8,
        Times:16,
        Bin_DunRewardsList/binary
    >>,
    Data.
item_to_bin_5 ({
    BossId,
    RewardSt,
    RewardList
}) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        BossId:32,
        RewardSt:8,
        Bin_RewardList/binary
    >>,
    Data.
