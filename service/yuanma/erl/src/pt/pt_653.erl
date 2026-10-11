-module(pt_653).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(65300, _) ->
    {ok, []};
read(65301, _) ->
    {ok, []};
read(65302, _) ->
    {ok, []};
read(65303, _) ->
    {ok, []};
read(65304, _) ->
    {ok, []};
read(65305, Bin0) ->
    <<RivalId:64, Bin1/binary>> = Bin0, 
    <<Combat:64, Bin2/binary>> = Bin1, 
    <<ChallengeType:8, _Bin3/binary>> = Bin2, 
    {ok, [RivalId, Combat, ChallengeType]};
read(65306, _) ->
    {ok, []};
read(65307, Bin0) ->
    <<Stage:16, _Bin1/binary>> = Bin0, 
    {ok, [Stage]};
read(65308, Bin0) ->
    <<Num:16, _Bin1/binary>> = Bin0, 
    {ok, [Num]};
read(65310, _) ->
    {ok, []};
read(65311, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (65300,[
    State,
    LeftTime
]) ->
    Data = <<
        State:8,
        LeftTime:32
    >>,
    {ok, pt:pack(65300, Data)};

write (65301,[
    Rank,
    Combat,
    Score,
    StageReward
]) ->
    BinList_StageReward = [
        item_to_bin_0(StageReward_Item) || StageReward_Item <- StageReward
    ], 

    StageReward_Len = length(StageReward), 
    Bin_StageReward = list_to_binary(BinList_StageReward),

    Data = <<
        Rank:32,
        Combat:64,
        Score:16,
        StageReward_Len:16, Bin_StageReward/binary
    >>,
    {ok, pt:pack(65301, Data)};

write (65302,[
    Errcode,
    LeftNum,
    NumRefresh,
    BuyNum,
    CanBuyNum
]) ->
    Data = <<
        Errcode:32,
        LeftNum:16,
        NumRefresh:32,
        BuyNum:16,
        CanBuyNum:16
    >>,
    {ok, pt:pack(65302, Data)};

write (65303,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_1(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(65303, Data)};

write (65304,[
    SelfRobotId,
    RivalRobotId
]) ->
    Data = <<
        SelfRobotId:64,
        RivalRobotId:64
    >>,
    {ok, pt:pack(65304, Data)};

write (65305,[
    Result,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_2(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Result:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(65305, Data)};

write (65306,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(65306, Data)};

write (65307,[
    Stage,
    Errcode
]) ->
    Data = <<
        Stage:32,
        Errcode:32
    >>,
    {ok, pt:pack(65307, Data)};

write (65308,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(65308, Data)};

write (65309,[
    Stage,
    Time
]) ->
    Data = <<
        Stage:8,
        Time:32
    >>,
    {ok, pt:pack(65309, Data)};

write (65310,[
    Errcode,
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_3(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        Errcode:32,
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(65310, Data)};

write (65311,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(65311, Data)};

write (65399,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(65399, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    State,
    Stage
}) ->
    Data = <<
        State:8,
        Stage:32
    >>,
    Data.
item_to_bin_1 ({
    RoleId,
    Score,
    Honor,
    Combat,
    Hp,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Score:16,
        Honor:16,
        Combat:64,
        Hp:32,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_2 ({
    Type,
    TypeId,
    Num
}) ->
    Data = <<
        Type:8,
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_3 ({
    Rank,
    RoleId,
    RoleName,
    Score,
    ServerId
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        RoleId:64,
        Bin_RoleName/binary,
        Score:32,
        ServerId:32
    >>,
    Data.
