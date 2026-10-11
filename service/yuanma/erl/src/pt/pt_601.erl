-module(pt_601).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60101, _) ->
    {ok, []};
read(60102, _) ->
    {ok, []};
read(60103, _) ->
    {ok, []};
read(60104, _) ->
    {ok, []};
read(60105, _) ->
    {ok, []};
read(60106, _) ->
    {ok, []};
read(60107, _) ->
    {ok, []};
read(60108, Bin0) ->
    <<ServerId:16, _Bin1/binary>> = Bin0, 
    {ok, [ServerId]};
read(60109, Bin0) ->
    <<ServerId:16, _Bin1/binary>> = Bin0, 
    {ok, [ServerId]};
read(60110, _) ->
    {ok, []};
read(60111, _) ->
    {ok, []};
read(60112, _) ->
    {ok, []};
read(60113, _) ->
    {ok, []};
read(60114, Bin0) ->
    <<Id:16, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(60115, Bin0) ->
    <<Id:16, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(60116, _) ->
    {ok, []};
read(60117, _) ->
    {ok, []};
read(60123, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (60100,[
    Errcode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Errcode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(60100, Data)};

write (60101,[
    IsOpen,
    Status,
    Round,
    Etime,
    SeasonStime,
    SeasonEtime
]) ->
    Data = <<
        IsOpen:8,
        Status:8,
        Round:8,
        Etime:32,
        SeasonStime:32,
        SeasonEtime:32
    >>,
    {ok, pt:pack(60101, Data)};

write (60102,[
    Ranking,
    Score,
    IsSignUp,
    MinPower,
    AppointId,
    DominatorId,
    DominatorGname,
    DominatorName
]) ->
    Bin_DominatorGname = pt:write_string(DominatorGname), 

    Bin_DominatorName = pt:write_string(DominatorName), 

    Data = <<
        Ranking:16,
        Score:32,
        IsSignUp:8,
        MinPower:32,
        AppointId:16,
        DominatorId:64,
        Bin_DominatorGname/binary,
        Bin_DominatorName/binary
    >>,
    {ok, pt:pack(60102, Data)};

write (60103,[
    Ranking,
    Score,
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Ranking:16,
        Score:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60103, Data)};

write (60104,[
    IsContestant,
    Ranking,
    Score,
    List
]) ->
    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        IsContestant:8,
        Ranking:16,
        Score:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60104, Data)};

write (60105,[
    Ranking,
    Score
]) ->
    Data = <<
        Ranking:16,
        Score:32
    >>,
    {ok, pt:pack(60105, Data)};

write (60106,[
    IsSignUp,
    Ranking,
    RoleName,
    GuildName,
    HCombatPower,
    RoleList
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_GuildName = pt:write_string(GuildName), 

    BinList_RoleList = [
        item_to_bin_2(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        IsSignUp:8,
        Ranking:8,
        Bin_RoleName/binary,
        Bin_GuildName/binary,
        HCombatPower:32,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(60106, Data)};

write (60107,[
    Score,
    Ranking,
    DominatorId,
    DominatorGname,
    DominatorName,
    AppointId,
    ServerList
]) ->
    Bin_DominatorGname = pt:write_string(DominatorGname), 

    Bin_DominatorName = pt:write_string(DominatorName), 

    BinList_ServerList = [
        item_to_bin_3(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        Score:32,
        Ranking:16,
        DominatorId:64,
        Bin_DominatorGname/binary,
        Bin_DominatorName/binary,
        AppointId:16,
        ServerList_Len:16, Bin_ServerList/binary
    >>,
    {ok, pt:pack(60107, Data)};

write (60108,[
    AppointScore,
    ObtainScore,
    LoseScore
]) ->
    Data = <<
        AppointScore:32,
        ObtainScore:32,
        LoseScore:32
    >>,
    {ok, pt:pack(60108, Data)};

write (60109,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60109, Data)};

write (60110,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60110, Data)};

write (60111,[
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_5(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(60111, Data)};

write (60112,[
    List
]) ->
    BinList_List = [
        item_to_bin_7(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60112, Data)};

write (60113,[
    AttId,
    AttSerName,
    DefId,
    DefSerName,
    IsContestant,
    List
]) ->
    Bin_AttSerName = pt:write_string(AttSerName), 

    Bin_DefSerName = pt:write_string(DefSerName), 

    BinList_List = [
        item_to_bin_8(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        AttId:16,
        Bin_AttSerName/binary,
        DefId:16,
        Bin_DefSerName/binary,
        IsContestant:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60113, Data)};

write (60114,[
    Id,
    Hp,
    AttNum,
    DefNum,
    IsEnd
]) ->
    Data = <<
        Id:16,
        Hp:32,
        AttNum:16,
        DefNum:16,
        IsEnd:8
    >>,
    {ok, pt:pack(60114, Data)};

write (60115,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60115, Data)};

write (60116,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60116, Data)};

write (60117,[
    Type,
    Tag,
    Etime,
    Stage,
    NextWave,
    List
]) ->
    BinList_List = [
        item_to_bin_9(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Type:8,
        Tag:8,
        Etime:32,
        Stage:8,
        NextWave:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60117, Data)};

write (60118,[
    NextWave
]) ->
    Data = <<
        NextWave:32
    >>,
    {ok, pt:pack(60118, Data)};

write (60119,[
    Stage,
    List
]) ->
    BinList_List = [
        item_to_bin_10(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Stage:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60119, Data)};

write (60120,[
    List
]) ->
    BinList_List = [
        item_to_bin_11(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60120, Data)};

write (60121,[
    Type
]) ->
    Data = <<
        Type:8
    >>,
    {ok, pt:pack(60121, Data)};

write (60122,[
    WinnerId,
    List
]) ->
    BinList_List = [
        item_to_bin_12(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        WinnerId:16,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(60122, Data)};

write (60123,[
    ServerList
]) ->
    BinList_ServerList = [
        item_to_bin_14(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        ServerList_Len:16, Bin_ServerList/binary
    >>,
    {ok, pt:pack(60123, Data)};

write (60124,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(60124, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Round,
    AttId,
    AttSerName,
    DefId,
    DefSerName,
    WinType
}) ->
    Bin_AttSerName = pt:write_string(AttSerName), 

    Bin_DefSerName = pt:write_string(DefSerName), 

    Data = <<
        Round:8,
        AttId:16,
        Bin_AttSerName/binary,
        DefId:16,
        Bin_DefSerName/binary,
        WinType:8
    >>,
    Data.
item_to_bin_1 ({
    Round,
    AttId,
    AttSerName,
    DefId,
    DefSerName,
    WinType
}) ->
    Bin_AttSerName = pt:write_string(AttSerName), 

    Bin_DefSerName = pt:write_string(DefSerName), 

    Data = <<
        Round:8,
        AttId:16,
        Bin_AttSerName/binary,
        DefId:16,
        Bin_DefSerName/binary,
        WinType:8
    >>,
    Data.
item_to_bin_2 ({
    Ranking,
    RoleName,
    GuildName,
    HCombatPower
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Ranking:8,
        Bin_RoleName/binary,
        Bin_GuildName/binary,
        HCombatPower:32
    >>,
    Data.
item_to_bin_3 ({
    ServerId,
    ServerName,
    Score,
    Ranking,
    CanBeAppointTime,
    BeAppointRecord
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    BinList_BeAppointRecord = [
        item_to_bin_4(BeAppointRecord_Item) || BeAppointRecord_Item <- BeAppointRecord
    ], 

    BeAppointRecord_Len = length(BeAppointRecord), 
    Bin_BeAppointRecord = list_to_binary(BinList_BeAppointRecord),

    Data = <<
        ServerId:16,
        Bin_ServerName/binary,
        Score:32,
        Ranking:16,
        CanBeAppointTime:32,
        BeAppointRecord_Len:16, Bin_BeAppointRecord/binary
    >>,
    Data.
item_to_bin_4 ({
    ServerName,
    CostScore,
    Time
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        Bin_ServerName/binary,
        CostScore:32,
        Time:32
    >>,
    Data.
item_to_bin_5 ({
    ServerId,
    ServerName,
    Score,
    Ranking,
    Reward
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    BinList_Reward = [
        item_to_bin_6(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        ServerId:16,
        Bin_ServerName/binary,
        Score:32,
        Ranking:16,
        Reward_Len:16, Bin_Reward/binary
    >>,
    Data.
item_to_bin_6 ({
    ObjectType,
    TypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_7 ({
    Round,
    AttId,
    AttSerName,
    DefId,
    DefSerName,
    WinType
}) ->
    Bin_AttSerName = pt:write_string(AttSerName), 

    Bin_DefSerName = pt:write_string(DefSerName), 

    Data = <<
        Round:8,
        AttId:16,
        Bin_AttSerName/binary,
        DefId:16,
        Bin_DefSerName/binary,
        WinType:8
    >>,
    Data.
item_to_bin_8 ({
    Id,
    Index
}) ->
    Data = <<
        Id:16,
        Index:8
    >>,
    Data.
item_to_bin_9 ({
    Id,
    Mid,
    Hp
}) ->
    Data = <<
        Id:8,
        Mid:32,
        Hp:32
    >>,
    Data.
item_to_bin_10 ({
    Id,
    Mid,
    Hp
}) ->
    Data = <<
        Id:8,
        Mid:32,
        Hp:32
    >>,
    Data.
item_to_bin_11 ({
    Id,
    Mid,
    Hp
}) ->
    Data = <<
        Id:8,
        Mid:32,
        Hp:32
    >>,
    Data.
item_to_bin_12 ({
    Ranking,
    ServerId,
    RoleId,
    RoleName,
    KillNum,
    Combo,
    Reward
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    BinList_Reward = [
        item_to_bin_13(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Ranking:16,
        ServerId:16,
        RoleId:64,
        Bin_RoleName/binary,
        KillNum:16,
        Combo:16,
        Reward_Len:16, Bin_Reward/binary
    >>,
    Data.
item_to_bin_13 ({
    ObjectType,
    TypeId,
    Num
}) ->
    Data = <<
        ObjectType:8,
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_14 ({
    ServerName,
    DominatorGname,
    DominatorName,
    Score,
    Ranking
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_DominatorGname = pt:write_string(DominatorGname), 

    Bin_DominatorName = pt:write_string(DominatorName), 

    Data = <<
        Bin_ServerName/binary,
        Bin_DominatorGname/binary,
        Bin_DominatorName/binary,
        Score:32,
        Ranking:16
    >>,
    Data.
