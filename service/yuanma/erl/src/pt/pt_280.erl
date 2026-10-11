-module(pt_280).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28001, _) ->
    {ok, []};
read(28002, _) ->
    {ok, []};
read(28003, Bin0) ->
    <<SelfRank:32, Bin1/binary>> = Bin0, 
    <<RivalId:64, Bin2/binary>> = Bin1, 
    <<RivalRank:32, Bin3/binary>> = Bin2, 
    <<ChallengeType:8, _Bin4/binary>> = Bin3, 
    {ok, [SelfRank, RivalId, RivalRank, ChallengeType]};
read(28004, _) ->
    {ok, []};
read(28005, Bin0) ->
    <<Num:16, _Bin1/binary>> = Bin0, 
    {ok, [Num]};
read(28006, _) ->
    {ok, []};
read(28007, _) ->
    {ok, []};
read(28008, _) ->
    {ok, []};
read(28009, _) ->
    {ok, []};
read(28010, _) ->
    {ok, []};
read(28011, _) ->
    {ok, []};
read(28012, _) ->
    {ok, []};
read(28013, _) ->
    {ok, []};
read(28015, _) ->
    {ok, []};
read(28016, _) ->
    {ok, []};
read(28017, Bin0) ->
    <<BreakId:32, _Bin1/binary>> = Bin0, 
    {ok, [BreakId]};
read(28018, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (28000,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(28000, Data)};

write (28001,[
    Rank,
    HistoryRank,
    RewardRank,
    Combat,
    Hp,
    Num,
    NumRefresh,
    Honour,
    IsReward,
    PetId,
    BreakIdList
]) ->
    BinList_BreakIdList = [
        item_to_bin_0(BreakIdList_Item) || BreakIdList_Item <- BreakIdList
    ], 

    BreakIdList_Len = length(BreakIdList), 
    Bin_BreakIdList = list_to_binary(BinList_BreakIdList),

    Data = <<
        Rank:32,
        HistoryRank:32,
        RewardRank:32,
        Combat:64,
        Hp:32,
        Num:16,
        NumRefresh:32,
        Honour:32,
        IsReward:8,
        PetId:32,
        BreakIdList_Len:16, Bin_BreakIdList/binary
    >>,
    {ok, pt:pack(28001, Data)};

write (28002,[
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
    {ok, pt:pack(28002, Data)};

write (28003,[
    RoleList,
    Result,
    RewardList,
    BreakRewardList
]) ->
    BinList_RoleList = [
        item_to_bin_2(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Bin_BreakRewardList = pt:write_object_list(BreakRewardList), 

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary,
        Result:8,
        RewardList_Len:16, Bin_RewardList/binary,
        Bin_BreakRewardList/binary
    >>,
    {ok, pt:pack(28003, Data)};

write (28004,[
    Errcode,
    LeftNum,
    NumRefresh,
    CanBuyNum
]) ->
    Data = <<
        Errcode:32,
        LeftNum:16,
        NumRefresh:32,
        CanBuyNum:16
    >>,
    {ok, pt:pack(28004, Data)};

write (28005,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(28005, Data)};

write (28006,[
    Errcode,
    Num
]) ->
    Data = <<
        Errcode:32,
        Num:16
    >>,
    {ok, pt:pack(28006, Data)};

write (28007,[
    Errcode,
    Combat
]) ->
    Data = <<
        Errcode:32,
        Combat:64
    >>,
    {ok, pt:pack(28007, Data)};

write (28008,[
    Errcode,
    IsReward,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_4(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Errcode:32,
        IsReward:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(28008, Data)};

write (28009,[
    Errcode,
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_5(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        Errcode:32,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(28009, Data)};

write (28010,[
    Errcode,
    Honour
]) ->
    Data = <<
        Errcode:32,
        Honour:32
    >>,
    {ok, pt:pack(28010, Data)};

write (28011,[
    Errcode,
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_6(InfoList_Item) || InfoList_Item <- InfoList
    ], 

    InfoList_Len = length(InfoList), 
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        Errcode:32,
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(28011, Data)};

write (28012,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(28012, Data)};

write (28013,[
    SelfRobotId,
    SelfRoleId,
    RivalRobotId,
    RivalRoleId
]) ->
    Data = <<
        SelfRobotId:64,
        SelfRoleId:64,
        RivalRobotId:64,
        RivalRoleId:64
    >>,
    {ok, pt:pack(28013, Data)};

write (28014,[
    Stage,
    Time
]) ->
    Data = <<
        Stage:8,
        Time:32
    >>,
    {ok, pt:pack(28014, Data)};

write (28015,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(28015, Data)};

write (28016,[
    RoleId,
    Picture,
    PictureVer,
    Name,
    Career,
    Sex,
    Turn,
    VipLv,
    Lv,
    CombatPower,
    Result,
    State,
    RankRange,
    Time
]) ->
    Bin_Picture = pt:write_string(Picture), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Picture/binary,
        PictureVer:32,
        Bin_Name/binary,
        Career:8,
        Sex:8,
        Turn:8,
        VipLv:8,
        Lv:16,
        CombatPower:64,
        Result:8,
        State:8,
        RankRange:32,
        Time:32
    >>,
    {ok, pt:pack(28016, Data)};

write (28017,[
    Errcode,
    BreakId,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Errcode:32,
        BreakId:32,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(28017, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    BreakId
) ->
    Data = <<
        BreakId:32
    >>,
    Data.
item_to_bin_1 ({
    Rank,
    RoleId,
    Combat,
    Hp,
    PetId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Rank:32,
        RoleId:64,
        Combat:64,
        Hp:32,
        PetId:32,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    Figure,
    BeforeRank,
    Rank,
    Combat
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        BeforeRank:16,
        Rank:16,
        Combat:64
    >>,
    Data.
item_to_bin_3 ({
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
item_to_bin_4 ({
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
item_to_bin_5 ({
    RoleId,
    Picture,
    PictureVer,
    Name,
    Career,
    Sex,
    Turn,
    VipLv,
    Lv,
    CombatPower,
    Result,
    State,
    RankRange,
    Time
}) ->
    Bin_Picture = pt:write_string(Picture), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Picture/binary,
        PictureVer:32,
        Bin_Name/binary,
        Career:8,
        Sex:8,
        Turn:8,
        VipLv:8,
        Lv:16,
        CombatPower:64,
        Result:8,
        State:8,
        RankRange:32,
        Time:32
    >>,
    Data.
item_to_bin_6 ({
    Rank,
    RoleId,
    Combat,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Rank:32,
        RoleId:64,
        Combat:64,
        Bin_Figure/binary
    >>,
    Data.
