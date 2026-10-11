-module(pt_186).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18600, _) ->
    {ok, []};
read(18601, _) ->
    {ok, []};
read(18602, Bin0) ->
    <<RoleLv:16, Bin1/binary>> = Bin0, 
    <<Power:64, Bin2/binary>> = Bin1, 
    <<Auto:8, _Bin3/binary>> = Bin2, 
    {ok, [RoleLv, Power, Auto]};
read(18603, _) ->
    {ok, []};
read(18604, _) ->
    {ok, []};
read(18605, Bin0) ->
    <<Agree:8, Bin1/binary>> = Bin0, 
    <<RoleId:64, _Bin2/binary>> = Bin1, 
    {ok, [Agree, RoleId]};
read(18606, Bin0) ->
    <<Level:16, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<RoleId:64, _Args1/binary>> = RestBin0, 
        {RoleId,_Args1}
        end,
    {RoleList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [Level, RoleList]};
read(18607, _) ->
    {ok, []};
read(18608, Bin0) ->
    <<Camp:32, _Bin1/binary>> = Bin0, 
    {ok, [Camp]};
read(18609, _) ->
    {ok, []};
read(18610, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(18611, _) ->
    {ok, []};
read(18613, Bin0) ->
    <<Scene:32, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(18614, _) ->
    {ok, []};
read(18615, _) ->
    {ok, []};
read(18616, Bin0) ->
    <<ServerId:32, Bin1/binary>> = Bin0, 
    <<RoleId:64, Bin2/binary>> = Bin1, 
    <<Times:8, _Bin3/binary>> = Bin2, 
    {ok, [ServerId, RoleId, Times]};
read(18617, _) ->
    {ok, []};
read(18618, _) ->
    {ok, []};
read(18619, Bin0) ->
    <<Camp:32, _Bin1/binary>> = Bin0, 
    {ok, [Camp]};
read(18620, _) ->
    {ok, []};
read(18621, _) ->
    {ok, []};
read(18622, _) ->
    {ok, []};
read(18624, _) ->
    {ok, []};
read(18625, _) ->
    {ok, []};
read(18626, _) ->
    {ok, []};
read(18650, _) ->
    {ok, []};
read(18651, _) ->
    {ok, []};
read(18652, Bin0) ->
    <<PrivId:16, Bin1/binary>> = Bin0, 
    <<Option:8, _Bin2/binary>> = Bin1, 
    {ok, [PrivId, Option]};
read(18653, _) ->
    {ok, []};
read(18654, Bin0) ->
    <<PageSize:16, Bin1/binary>> = Bin0, 
    <<PageNum:16, _Bin2/binary>> = Bin1, 
    {ok, [PageSize, PageNum]};
read(18655, _) ->
    {ok, []};
read(18656, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (18600,[
    Camp,
    ServerId,
    ServerNum,
    GuildId,
    GuildName,
    KingName,
    Fight,
    Count,
    SelfLevel,
    RewardStatus
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_KingName = pt:write_string(KingName), 

    Data = <<
        Camp:32,
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary,
        Bin_KingName/binary,
        Fight:64,
        Count:64,
        SelfLevel:16,
        RewardStatus:8
    >>,
    {ok, pt:pack(18600, Data)};

write (18601,[
    LimitNum,
    Num,
    HasJoin,
    JobList
]) ->
    BinList_JobList = [
        item_to_bin_0(JobList_Item) || JobList_Item <- JobList
    ], 

    JobList_Len = length(JobList), 
    Bin_JobList = list_to_binary(BinList_JobList),

    Data = <<
        LimitNum:16,
        Num:16,
        HasJoin:8,
        JobList_Len:16, Bin_JobList/binary
    >>,
    {ok, pt:pack(18601, Data)};

write (18602,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18602, Data)};

write (18603,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18603, Data)};

write (18604,[
    List
]) ->
    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(18604, Data)};

write (18605,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18605, Data)};

write (18606,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18606, Data)};

write (18607,[
    ActType,
    HasFight,
    StartTime,
    EndTime,
    CanEnter
]) ->
    Data = <<
        ActType:8,
        HasFight:8,
        StartTime:32,
        EndTime:32,
        CanEnter:8
    >>,
    {ok, pt:pack(18607, Data)};

write (18608,[
    Camp,
    GuildList
]) ->
    BinList_GuildList = [
        item_to_bin_2(GuildList_Item) || GuildList_Item <- GuildList
    ], 

    GuildList_Len = length(GuildList), 
    Bin_GuildList = list_to_binary(BinList_GuildList),

    Data = <<
        Camp:32,
        GuildList_Len:16, Bin_GuildList/binary
    >>,
    {ok, pt:pack(18608, Data)};

write (18609,[
    List
]) ->
    BinList_List = [
        item_to_bin_3(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(18609, Data)};

write (18610,[
    Type,
    Code,
    Time
]) ->
    Data = <<
        Type:8,
        Code:32,
        Time:32
    >>,
    {ok, pt:pack(18610, Data)};

write (18611,[
    ScoreRank
]) ->
    BinList_ScoreRank = [
        item_to_bin_4(ScoreRank_Item) || ScoreRank_Item <- ScoreRank
    ], 

    ScoreRank_Len = length(ScoreRank), 
    Bin_ScoreRank = list_to_binary(BinList_ScoreRank),

    Data = <<
        ScoreRank_Len:16, Bin_ScoreRank/binary
    >>,
    {ok, pt:pack(18611, Data)};

write (18612,[
    Status,
    GuildRank,
    SelfRank,
    RankReward,
    Reward
]) ->
    Bin_RankReward = pt:write_object_list(RankReward), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Status:8,
        GuildRank:16,
        SelfRank:16,
        Bin_RankReward/binary,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(18612, Data)};

write (18613,[
    Type,
    Code
]) ->
    Data = <<
        Type:8,
        Code:32
    >>,
    {ok, pt:pack(18613, Data)};

write (18614,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18614, Data)};

write (18615,[
    Camp,
    ServerId,
    ServerNum,
    GuildId,
    GuildName,
    Times,
    StartTime,
    EndTime,
    WinRewardStatus
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_WinRewardStatus = [
        item_to_bin_6(WinRewardStatus_Item) || WinRewardStatus_Item <- WinRewardStatus
    ], 

    WinRewardStatus_Len = length(WinRewardStatus), 
    Bin_WinRewardStatus = list_to_binary(BinList_WinRewardStatus),

    Data = <<
        Camp:32,
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary,
        Times:16,
        StartTime:32,
        EndTime:32,
        WinRewardStatus_Len:16, Bin_WinRewardStatus/binary
    >>,
    {ok, pt:pack(18615, Data)};

write (18616,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18616, Data)};

write (18617,[
    Att,
    Def
]) ->
    BinList_Att = [
        item_to_bin_7(Att_Item) || Att_Item <- Att
    ], 

    Att_Len = length(Att), 
    Bin_Att = list_to_binary(BinList_Att),

    BinList_Def = [
        item_to_bin_8(Def_Item) || Def_Item <- Def
    ], 

    Def_Len = length(Def), 
    Bin_Def = list_to_binary(BinList_Def),

    Data = <<
        Att_Len:16, Bin_Att/binary,
        Def_Len:16, Bin_Def/binary
    >>,
    {ok, pt:pack(18617, Data)};

write (18618,[
    List
]) ->
    BinList_List = [
        item_to_bin_9(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(18618, Data)};

write (18619,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18619, Data)};

write (18620,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18620, Data)};

write (18621,[
    Reward,
    Code
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Bin_Reward/binary,
        Code:32
    >>,
    {ok, pt:pack(18621, Data)};

write (18622,[
    RoleLv,
    Power,
    Auto
]) ->
    Data = <<
        RoleLv:16,
        Power:64,
        Auto:8
    >>,
    {ok, pt:pack(18622, Data)};

write (18623,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18623, Data)};

write (18624,[
    TimeList
]) ->
    BinList_TimeList = [
        item_to_bin_10(TimeList_Item) || TimeList_Item <- TimeList
    ], 

    TimeList_Len = length(TimeList), 
    Bin_TimeList = list_to_binary(BinList_TimeList),

    Data = <<
        TimeList_Len:16, Bin_TimeList/binary
    >>,
    {ok, pt:pack(18624, Data)};

write (18625,[
    EndTime
]) ->
    Data = <<
        EndTime:32
    >>,
    {ok, pt:pack(18625, Data)};

write (18626,[
    Code
]) ->
    Data = <<
        Code:8
    >>,
    {ok, pt:pack(18626, Data)};

write (18650,[
    Camp,
    GuildNum,
    Count,
    Fight,
    KingId
]) ->
    Data = <<
        Camp:32,
        GuildNum:32,
        Count:64,
        Fight:64,
        KingId:64
    >>,
    {ok, pt:pack(18650, Data)};

write (18651,[
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
    {ok, pt:pack(18651, Data)};

write (18652,[
    Code,
    PrivId,
    Status,
    EndTime
]) ->
    Data = <<
        Code:32,
        PrivId:16,
        Status:8,
        EndTime:64
    >>,
    {ok, pt:pack(18652, Data)};

write (18653,[
    Lv,
    Exploit
]) ->
    Data = <<
        Lv:16,
        Exploit:32
    >>,
    {ok, pt:pack(18653, Data)};

write (18654,[
    PageTotal,
    PageSize,
    PageNum,
    Member
]) ->
    BinList_Member = [
        item_to_bin_13(Member_Item) || Member_Item <- Member
    ], 

    Member_Len = length(Member), 
    Bin_Member = list_to_binary(BinList_Member),

    Data = <<
        PageTotal:16,
        PageSize:16,
        PageNum:16,
        Member_Len:16, Bin_Member/binary
    >>,
    {ok, pt:pack(18654, Data)};

write (18655,[
    GuildInfo
]) ->
    BinList_GuildInfo = [
        item_to_bin_14(GuildInfo_Item) || GuildInfo_Item <- GuildInfo
    ], 

    GuildInfo_Len = length(GuildInfo), 
    Bin_GuildInfo = list_to_binary(BinList_GuildInfo),

    Data = <<
        GuildInfo_Len:16, Bin_GuildInfo/binary
    >>,
    {ok, pt:pack(18655, Data)};

write (18656,[
    FourLevel
]) ->
    Data = <<
        FourLevel:16
    >>,
    {ok, pt:pack(18656, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SelfLevel,
    ServerId,
    ServerNum,
    RoleId,
    RoleName,
    RoleLv,
    Picture,
    PictureVer,
    Power
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        SelfLevel:16,
        ServerId:32,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        RoleLv:16,
        Bin_Picture/binary,
        PictureVer:16,
        Power:64
    >>,
    Data.
item_to_bin_1 ({
    Picture,
    PictureVer,
    RoleLv,
    RoleId,
    RoleName,
    Power
}) ->
    Bin_Picture = pt:write_string(Picture), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_Picture/binary,
        PictureVer:16,
        RoleLv:16,
        RoleId:64,
        Bin_RoleName/binary,
        Power:64
    >>,
    Data.
item_to_bin_2 ({
    Rank,
    ServerId,
    ServerNum,
    GuildId,
    GuildName,
    GuildPower,
    RoleName,
    RoleId
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary,
        GuildPower:64,
        Bin_RoleName/binary,
        RoleId:64
    >>,
    Data.
item_to_bin_3 ({
    MonId,
    Hp,
    HpMax,
    AttLimit,
    NextMon
}) ->
    Data = <<
        MonId:32,
        Hp:64,
        HpMax:64,
        AttLimit:8,
        NextMon:32
    >>,
    Data.
item_to_bin_4 ({
    GuildId,
    GuildName,
    IsAtt,
    GuildRank,
    GuildScore,
    Member
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    BinList_Member = [
        item_to_bin_5(Member_Item) || Member_Item <- Member
    ], 

    Member_Len = length(Member), 
    Bin_Member = list_to_binary(BinList_Member),

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        IsAtt:8,
        GuildRank:8,
        GuildScore:16,
        Member_Len:16, Bin_Member/binary
    >>,
    Data.
item_to_bin_5 ({
    Rank,
    RoleId,
    RoleName,
    KillScore,
    Score
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Rank:16,
        RoleId:64,
        Bin_RoleName/binary,
        KillScore:16,
        Score:16
    >>,
    Data.
item_to_bin_6 ({
    Times,
    Status
}) ->
    Data = <<
        Times:8,
        Status:8
    >>,
    Data.
item_to_bin_7 ({
    ServerId,
    ServerNum,
    GuildId,
    GuildName
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_8 ({
    ServerId,
    ServerNum,
    GuildId,
    GuildName
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_9 ({
    Camp,
    ServerId,
    ServerNum,
    GuildId,
    GuildName,
    Power,
    RoleId,
    RoleName
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Camp:32,
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary,
        Power:64,
        RoleId:64,
        Bin_RoleName/binary
    >>,
    Data.
item_to_bin_10 ({
    ActType,
    StartTime,
    EndTime
}) ->
    Data = <<
        ActType:8,
        StartTime:32,
        EndTime:32
    >>,
    Data.
item_to_bin_11 ({
    PrivId,
    ResidueNum,
    Status,
    EndTime,
    NeedJob
}) ->
    BinList_NeedJob = [
        item_to_bin_12(NeedJob_Item) || NeedJob_Item <- NeedJob
    ], 

    NeedJob_Len = length(NeedJob), 
    Bin_NeedJob = list_to_binary(BinList_NeedJob),

    Data = <<
        PrivId:16,
        ResidueNum:16,
        Status:8,
        EndTime:64,
        NeedJob_Len:16, Bin_NeedJob/binary
    >>,
    Data.
item_to_bin_12 (
    JobId
) ->
    Data = <<
        JobId:16
    >>,
    Data.
item_to_bin_13 ({
    Vip,
    RoleId,
    RoleName,
    Lv,
    JobId,
    Exploit,
    Fight,
    GuildId,
    GuildName
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Vip:16,
        RoleId:64,
        Bin_RoleName/binary,
        Lv:32,
        JobId:16,
        Exploit:32,
        Fight:64,
        GuildId:32,
        Bin_GuildName/binary
    >>,
    Data.
item_to_bin_14 ({
    ServerNum,
    GuildId,
    GuildName,
    LeaderId,
    LeaderName,
    Fight,
    MemberNum
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_LeaderName = pt:write_string(LeaderName), 

    Data = <<
        ServerNum:32,
        GuildId:32,
        Bin_GuildName/binary,
        LeaderId:64,
        Bin_LeaderName/binary,
        Fight:64,
        MemberNum:32
    >>,
    Data.
