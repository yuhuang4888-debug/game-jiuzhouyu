-module(pt_218).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(21801, _) ->
    {ok, []};
read(21802, _) ->
    {ok, []};
read(21803, _) ->
    {ok, []};
read(21804, _) ->
    {ok, []};
read(21805, _) ->
    {ok, []};
read(21806, Bin0) ->
    <<Stage:8, _Bin1/binary>> = Bin0, 
    {ok, [Stage]};
read(21807, _) ->
    {ok, []};
read(21808, _) ->
    {ok, []};
read(21811, _) ->
    {ok, []};
read(21812, _) ->
    {ok, []};
read(21813, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (21800,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(21800, Data)};

write (21801,[
    Mod,
    Status,
    EndTime,
    ServerList
]) ->
    BinList_ServerList = [
        item_to_bin_0(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        Mod:8,
        Status:8,
        EndTime:32,
        ServerList_Len:16, Bin_ServerList/binary
    >>,
    {ok, pt:pack(21801, Data)};

write (21802,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(21802, Data)};



write (21804,[
    AllExp
]) ->
    Data = <<
        AllExp:64
    >>,
    {ok, pt:pack(21804, Data)};

write (21805,[
    Point,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Point:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(21805, Data)};

write (21806,[
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Bin_Reward/binary
    >>,
    {ok, pt:pack(21806, Data)};

write (21807,[
    Point,
    SingleRank,
    GroupRank,
    Anger,
    AngerEnd,
    BuffList
]) ->
    BinList_BuffList = [
        item_to_bin_2(BuffList_Item) || BuffList_Item <- BuffList
    ], 

    BuffList_Len = length(BuffList), 
    Bin_BuffList = list_to_binary(BinList_BuffList),

    Data = <<
        Point:16,
        SingleRank:16,
        GroupRank:8,
        Anger:8,
        AngerEnd:32,
        BuffList_Len:16, Bin_BuffList/binary
    >>,
    {ok, pt:pack(21807, Data)};

write (21808,[
    GroupList
]) ->
    BinList_GroupList = [
        item_to_bin_3(GroupList_Item) || GroupList_Item <- GroupList
    ], 

    GroupList_Len = length(GroupList), 
    Bin_GroupList = list_to_binary(BinList_GroupList),

    Data = <<
        GroupList_Len:16, Bin_GroupList/binary
    >>,
    {ok, pt:pack(21808, Data)};

write (21809,[
    RoleName,
    RoleId,
    Lv,
    Power,
    PictureVer,
    Picture,
    Anger,
    ServerId,
    Career,
    Turn
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        Bin_RoleName/binary,
        RoleId:64,
        Lv:16,
        Power:64,
        PictureVer:32,
        Bin_Picture/binary,
        Anger:32,
        ServerId:32,
        Career:8,
        Turn:8
    >>,
    {ok, pt:pack(21809, Data)};

write (21810,[
    Res,
    GroupList,
    MyGroupId,
    MyRank
]) ->
    BinList_GroupList = [
        item_to_bin_5(GroupList_Item) || GroupList_Item <- GroupList
    ], 

    GroupList_Len = length(GroupList), 
    Bin_GroupList = list_to_binary(BinList_GroupList),

    Data = <<
        Res:8,
        GroupList_Len:16, Bin_GroupList/binary,
        MyGroupId:8,
        MyRank:8
    >>,
    {ok, pt:pack(21810, Data)};

write (21811,[
    Status,
    EndTime
]) ->
    Data = <<
        Status:8,
        EndTime:32
    >>,
    {ok, pt:pack(21811, Data)};



write (21813,[
    MonList
]) ->
    BinList_MonList = [
        item_to_bin_6(MonList_Item) || MonList_Item <- MonList
    ], 

    MonList_Len = length(MonList), 
    Bin_MonList = list_to_binary(BinList_MonList),

    Data = <<
        MonList_Len:16, Bin_MonList/binary
    >>,
    {ok, pt:pack(21813, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    ServerName,
    Lv
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:32,
        ServerNum:32,
        Bin_ServerName/binary,
        Lv:32
    >>,
    Data.
item_to_bin_1 ({
    Stage,
    Status
}) ->
    Data = <<
        Stage:16,
        Status:8
    >>,
    Data.
item_to_bin_2 ({
    AttrId,
    Value
}) ->
    Data = <<
        AttrId:16,
        Value:32
    >>,
    Data.
item_to_bin_3 ({
    GroupId,
    TowerNum,
    Point,
    Rank,
    RoleList
}) ->
    BinList_RoleList = [
        item_to_bin_4(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        GroupId:8,
        TowerNum:8,
        Point:32,
        Rank:8,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    Data.
item_to_bin_4 ({
    RoleId,
    Rank,
    ServerId,
    ServerNum,
    Name,
    Point,
    Kill,
    Assists
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Rank:8,
        ServerId:32,
        ServerNum:32,
        Bin_Name/binary,
        Point:32,
        Kill:16,
        Assists:16
    >>,
    Data.
item_to_bin_5 ({
    GroupId,
    TowerNum,
    Point
}) ->
    Data = <<
        GroupId:8,
        TowerNum:8,
        Point:32
    >>,
    Data.
item_to_bin_6 ({
    MonAuto,
    MonCfgId,
    Hp,
    HpAll,
    GroupId
}) ->
    Data = <<
        MonAuto:32,
        MonCfgId:32,
        Hp:32,
        HpAll:32,
        GroupId:8
    >>,
    Data.
