-module(pt_185).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18501, _) ->
    {ok, []};
read(18502, Bin0) ->
    <<Scene:32, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(18503, _) ->
    {ok, []};
read(18504, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(18505, _) ->
    {ok, []};
read(18506, _) ->
    {ok, []};
read(18507, _) ->
    {ok, []};
read(18508, Bin0) ->
    <<Scene:32, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(18509, Bin0) ->
    <<Notify:8, _Bin1/binary>> = Bin0, 
    {ok, [Notify]};
read(18510, _) ->
    {ok, []};
read(18511, _) ->
    {ok, []};
read(18512, _) ->
    {ok, []};
read(18513, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (18500,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18500, Data)};

write (18501,[
    ServerId,
    ServerNum,
    GuildId,
    GuildName,
    RobTimes,
    Time
]) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        ServerId:32,
        ServerNum:16,
        GuildId:64,
        Bin_GuildName/binary,
        RobTimes:8,
        Time:16
    >>,
    {ok, pt:pack(18501, Data)};

write (18502,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18502, Data)};

write (18503,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18503, Data)};

write (18504,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(18504, Data)};

write (18505,[
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(18505, Data)};

write (18506,[
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
    {ok, pt:pack(18506, Data)};

write (18507,[
    SelfGuild,
    EscortRes,
    EscortType,
    AddScore
]) ->
    BinList_SelfGuild = [
        item_to_bin_2(SelfGuild_Item) || SelfGuild_Item <- SelfGuild
    ], 

    SelfGuild_Len = length(SelfGuild), 
    Bin_SelfGuild = list_to_binary(BinList_SelfGuild),

    Data = <<
        SelfGuild_Len:16, Bin_SelfGuild/binary,
        EscortRes:8,
        EscortType:8,
        AddScore:16
    >>,
    {ok, pt:pack(18507, Data)};

write (18508,[
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
    {ok, pt:pack(18508, Data)};

write (18509,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(18509, Data)};

write (18510,[
    EscortType,
    EscortRes
]) ->
    Data = <<
        EscortType:8,
        EscortRes:8
    >>,
    {ok, pt:pack(18510, Data)};

write (18511,[
    GuildScore,
    GuildRank
]) ->
    Data = <<
        GuildScore:16,
        GuildRank:16
    >>,
    {ok, pt:pack(18511, Data)};

write (18512,[
    StartTime,
    EndTime
]) ->
    Data = <<
        StartTime:32,
        EndTime:32
    >>,
    {ok, pt:pack(18512, Data)};

write (18513,[
    RobScore,
    RobTimes,
    Time
]) ->
    Data = <<
        RobScore:16,
        RobTimes:8,
        Time:16
    >>,
    {ok, pt:pack(18513, Data)};

write (18514,[
    RewardType,
    Reward,
    Score,
    KillScore
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        RewardType:8,
        Bin_Reward/binary,
        Score:16,
        KillScore:16
    >>,
    {ok, pt:pack(18514, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerNum,
    ServerId,
    GuildName,
    GuildId,
    Score,
    Rank
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        ServerNum:16,
        ServerId:32,
        Bin_GuildName/binary,
        GuildId:64,
        Score:16,
        Rank:16
    >>,
    Data.
item_to_bin_1 ({
    ServerNum,
    ServerId,
    GuildName,
    GuildId,
    EscortType,
    Scene
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        ServerNum:16,
        ServerId:32,
        Bin_GuildName/binary,
        GuildId:64,
        EscortType:16,
        Scene:32
    >>,
    Data.
item_to_bin_2 ({
    Position,
    Name,
    RoleId,
    Score,
    Rank
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Position:16,
        Bin_Name/binary,
        RoleId:64,
        Score:16,
        Rank:16
    >>,
    Data.
item_to_bin_3 ({
    ServerNum,
    ServerId,
    GuildName,
    GuildId,
    EscortType,
    MonAutoId,
    X,
    Y,
    Scene,
    Hp,
    HpMax
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        ServerNum:16,
        ServerId:32,
        Bin_GuildName/binary,
        GuildId:64,
        EscortType:16,
        MonAutoId:64,
        X:32,
        Y:32,
        Scene:32,
        Hp:64,
        HpMax:64
    >>,
    Data.
