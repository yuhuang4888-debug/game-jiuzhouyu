-module(pt_611).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(61101, _) ->
    {ok, []};
read(61102, Bin0) ->
    <<DunId:32, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Id:32, _Args1/binary>> = RestBin0, 
        {Id,_Args1}
        end,
    {Pet, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [DunId, Pet]};
read(61103, _) ->
    {ok, []};
read(61104, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61105, Bin0) ->
    <<Level:8, _Bin1/binary>> = Bin0, 
    {ok, [Level]};
read(61106, Bin0) ->
    <<Level:8, _Bin1/binary>> = Bin0, 
    {ok, [Level]};
read(61107, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(61108, Bin0) ->
    <<Level:8, Bin1/binary>> = Bin0, 
    <<Score:8, _Bin2/binary>> = Bin1, 
    {ok, [Level, Score]};
read(61109, Bin0) ->
    <<Level:8, _Bin1/binary>> = Bin0, 
    {ok, [Level]};
read(61110, _) ->
    {ok, []};
read(61111, _) ->
    {ok, []};
read(61112, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<DunId:32, _Args1/binary>> = RestBin0, 
        <<RewardType:8, _Args2/binary>> = _Args1, 
        {{DunId, RewardType},_Args2}
        end,
    {RewardArgsList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [RewardArgsList]};
read(61113, Bin0) ->
    <<DunType:8, _Bin1/binary>> = Bin0, 
    {ok, [DunType]};
read(61114, _) ->
    {ok, []};
read(61115, _) ->
    {ok, []};
read(61116, Bin0) ->
    <<Level:32, _Bin1/binary>> = Bin0, 
    {ok, [Level]};
read(61117, _) ->
    {ok, []};
read(61118, Bin0) ->
    <<Round:8, _Bin1/binary>> = Bin0, 
    {ok, [Round]};
read(61119, _) ->
    {ok, []};
read(61120, Bin0) ->
    <<OperType:8, _Bin1/binary>> = Bin0, 
    {ok, [OperType]};
read(61121, Bin0) ->
    <<DunType:8, _Bin1/binary>> = Bin0, 
    {ok, [DunType]};
read(_Cmd, _R) -> {error, no_match}.

write (61101,[
    SkillList
]) ->
    BinList_SkillList = [
        item_to_bin_0(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(61101, Data)};



write (61103,[
    DunId,
    YesterdayDunId,
    DemonList,
    HaveSweep
]) ->
    BinList_DemonList = [
        item_to_bin_1(DemonList_Item) || DemonList_Item <- DemonList
    ], 

    DemonList_Len = length(DemonList), 
    Bin_DemonList = list_to_binary(BinList_DemonList),

    Data = <<
        DunId:32,
        YesterdayDunId:32,
        DemonList_Len:16, Bin_DemonList/binary,
        HaveSweep:8
    >>,
    {ok, pt:pack(61103, Data)};



write (61105,[
    Level,
    SweepCount,
    DunList
]) ->
    BinList_DunList = [
        item_to_bin_2(DunList_Item) || DunList_Item <- DunList
    ], 

    DunList_Len = length(DunList), 
    Bin_DunList = list_to_binary(BinList_DunList),

    Data = <<
        Level:8,
        SweepCount:16,
        DunList_Len:16, Bin_DunList/binary
    >>,
    {ok, pt:pack(61105, Data)};

write (61106,[
    Level,
    StageReward
]) ->
    BinList_StageReward = [
        item_to_bin_3(StageReward_Item) || StageReward_Item <- StageReward
    ], 

    StageReward_Len = length(StageReward), 
    Bin_StageReward = list_to_binary(BinList_StageReward),

    Data = <<
        Level:8,
        StageReward_Len:16, Bin_StageReward/binary
    >>,
    {ok, pt:pack(61106, Data)};

write (61107,[
    DunId,
    RoleId,
    RoleName
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        DunId:32,
        RoleId:64,
        Bin_RoleName/binary
    >>,
    {ok, pt:pack(61107, Data)};

write (61108,[
    Code,
    RewardLists
]) ->
    Bin_RewardLists = pt:write_object_list(RewardLists), 

    Data = <<
        Code:32,
        Bin_RewardLists/binary
    >>,
    {ok, pt:pack(61108, Data)};

write (61109,[
    Code,
    RewardLists,
    MulRewardLists,
    Mul
]) ->
    Bin_RewardLists = pt:write_object_list(RewardLists), 

    Bin_MulRewardLists = pt:write_object_list(MulRewardLists), 

    Data = <<
        Code:32,
        Bin_RewardLists/binary,
        Bin_MulRewardLists/binary,
        Mul:8
    >>,
    {ok, pt:pack(61109, Data)};

write (61110,[
    MonLists
]) ->
    BinList_MonLists = [
        item_to_bin_4(MonLists_Item) || MonLists_Item <- MonLists
    ], 

    MonLists_Len = length(MonLists), 
    Bin_MonLists = list_to_binary(BinList_MonLists),

    Data = <<
        MonLists_Len:16, Bin_MonLists/binary
    >>,
    {ok, pt:pack(61110, Data)};



write (61112,[
    Code,
    RewardArgsList,
    RewardList
]) ->
    BinList_RewardArgsList = [
        item_to_bin_5(RewardArgsList_Item) || RewardArgsList_Item <- RewardArgsList
    ], 

    RewardArgsList_Len = length(RewardArgsList), 
    Bin_RewardArgsList = list_to_binary(BinList_RewardArgsList),

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        RewardArgsList_Len:16, Bin_RewardArgsList/binary,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61112, Data)};

write (61113,[
    DunType,
    DunList
]) ->
    BinList_DunList = [
        item_to_bin_6(DunList_Item) || DunList_Item <- DunList
    ], 

    DunList_Len = length(DunList), 
    Bin_DunList = list_to_binary(BinList_DunList),

    Data = <<
        DunType:8,
        DunList_Len:16, Bin_DunList/binary
    >>,
    {ok, pt:pack(61113, Data)};

write (61114,[
    Code,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Code:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(61114, Data)};

write (61115,[
    DailyStatus,
    UnlockLevel
]) ->
    Data = <<
        DailyStatus:8,
        UnlockLevel:32
    >>,
    {ok, pt:pack(61115, Data)};

write (61116,[
    Code,
    Level
]) ->
    Data = <<
        Code:32,
        Level:32
    >>,
    {ok, pt:pack(61116, Data)};

write (61117,[
    Round,
    OverTime,
    RewardMode,
    PassList
]) ->
    BinList_PassList = [
        item_to_bin_7(PassList_Item) || PassList_Item <- PassList
    ], 

    PassList_Len = length(PassList), 
    Bin_PassList = list_to_binary(BinList_PassList),

    Data = <<
        Round:8,
        OverTime:32,
        RewardMode:8,
        PassList_Len:16, Bin_PassList/binary
    >>,
    {ok, pt:pack(61117, Data)};

write (61118,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(61118, Data)};

write (61119,[
    NextTime
]) ->
    Data = <<
        NextTime:64
    >>,
    {ok, pt:pack(61119, Data)};

write (61120,[
    Code,
    OperType,
    SweepList
]) ->
    BinList_SweepList = [
        item_to_bin_8(SweepList_Item) || SweepList_Item <- SweepList
    ], 

    SweepList_Len = length(SweepList), 
    Bin_SweepList = list_to_binary(BinList_SweepList),

    Data = <<
        Code:32,
        OperType:8,
        SweepList_Len:16, Bin_SweepList/binary
    >>,
    {ok, pt:pack(61120, Data)};

write (61121,[
    CountList
]) ->
    BinList_CountList = [
        item_to_bin_12(CountList_Item) || CountList_Item <- CountList
    ], 

    CountList_Len = length(CountList), 
    Bin_CountList = list_to_binary(BinList_CountList),

    Data = <<
        CountList_Len:16, Bin_CountList/binary
    >>,
    {ok, pt:pack(61121, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SkillId,
    SkillLv
}) ->
    Data = <<
        SkillId:32,
        SkillLv:16
    >>,
    Data.
item_to_bin_1 (
    DemonId
) ->
    Data = <<
        DemonId:32
    >>,
    Data.
item_to_bin_2 ({
    DunId,
    Score
}) ->
    Data = <<
        DunId:32,
        Score:8
    >>,
    Data.
item_to_bin_3 ({
    Score,
    Status
}) ->
    Data = <<
        Score:16,
        Status:8
    >>,
    Data.
item_to_bin_4 ({
    MonId,
    CurNum,
    AllNum
}) ->
    Data = <<
        MonId:32,
        CurNum:16,
        AllNum:16
    >>,
    Data.
item_to_bin_5 ({
    DunId,
    RewardType
}) ->
    Data = <<
        DunId:32,
        RewardType:8
    >>,
    Data.
item_to_bin_6 ({
    DunId,
    RewardType,
    RewardStatus
}) ->
    Data = <<
        DunId:32,
        RewardType:8,
        RewardStatus:8
    >>,
    Data.
item_to_bin_7 (
    DunId
) ->
    Data = <<
        DunId:32
    >>,
    Data.
item_to_bin_8 ({
    RewardList,
    OtherReward
}) ->
    BinList_RewardList = [
        item_to_bin_9(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_OtherReward = [
        item_to_bin_10(OtherReward_Item) || OtherReward_Item <- OtherReward
    ], 

    OtherReward_Len = length(OtherReward), 
    Bin_OtherReward = list_to_binary(BinList_OtherReward),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary,
        OtherReward_Len:16, Bin_OtherReward/binary
    >>,
    Data.
item_to_bin_9 ({
    Style,
    TypeId,
    Count,
    GoodsId
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:32,
        GoodsId:64
    >>,
    Data.
item_to_bin_10 ({
    RewardType,
    OtherRewardList
}) ->
    BinList_OtherRewardList = [
        item_to_bin_11(OtherRewardList_Item) || OtherRewardList_Item <- OtherRewardList
    ], 

    OtherRewardList_Len = length(OtherRewardList), 
    Bin_OtherRewardList = list_to_binary(BinList_OtherRewardList),

    Data = <<
        RewardType:8,
        OtherRewardList_Len:16, Bin_OtherRewardList/binary
    >>,
    Data.
item_to_bin_11 ({
    Style1,
    TypeId1,
    Count1,
    GoodsId1
}) ->
    Data = <<
        Style1:8,
        TypeId1:32,
        Count1:32,
        GoodsId1:64
    >>,
    Data.
item_to_bin_12 ({
    DunType,
    SweepCount,
    ChallengeCount
}) ->
    Data = <<
        DunType:8,
        SweepCount:16,
        ChallengeCount:16
    >>,
    Data.
