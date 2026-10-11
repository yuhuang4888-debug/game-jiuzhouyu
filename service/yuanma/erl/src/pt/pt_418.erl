-module(pt_418).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41801, _) ->
    {ok, []};
read(41802, _) ->
    {ok, []};
read(41803, _) ->
    {ok, []};
read(41804, _) ->
    {ok, []};
read(41805, _) ->
    {ok, []};
read(41806, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<GiftId:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, GiftId]};
read(41807, _) ->
    {ok, []};
read(41808, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<RoleId:64, _Args1/binary>> = RestBin0, 
        {RoleId,_Args1}
        end,
    {AskList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [AskList]};
read(41811, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Req:8, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Req]};
read(41812, _) ->
    {ok, []};
read(41813, _) ->
    {ok, []};
read(41814, Bin0) ->
    <<Num:16, _Bin1/binary>> = Bin0, 
    {ok, [Num]};
read(41816, _) ->
    {ok, []};
read(41817, _) ->
    {ok, []};
read(41819, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (41800,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(41800, Data)};

write (41801,[
    Status,
    StartTime,
    Duration
]) ->
    Data = <<
        Status:8,
        StartTime:64,
        Duration:32
    >>,
    {ok, pt:pack(41801, Data)};

write (41802,[
    Rcode
]) ->
    Data = <<
        Rcode:32
    >>,
    {ok, pt:pack(41802, Data)};

write (41803,[
    Rcode
]) ->
    Data = <<
        Rcode:32
    >>,
    {ok, pt:pack(41803, Data)};

write (41804,[
    Rank,
    AccExp,
    CharmV,
    GiftTimes
]) ->
    Data = <<
        Rank:32,
        AccExp:32,
        CharmV:32,
        GiftTimes:32
    >>,
    {ok, pt:pack(41804, Data)};

write (41805,[
    SelfCharmv,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        SelfCharmv:32,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(41805, Data)};

write (41806,[
    Rcode
]) ->
    Data = <<
        Rcode:32
    >>,
    {ok, pt:pack(41806, Data)};

write (41807,[
    ValidList
]) ->
    BinList_ValidList = [
        item_to_bin_1(ValidList_Item) || ValidList_Item <- ValidList
    ], 

    ValidList_Len = length(ValidList), 
    Bin_ValidList = list_to_binary(BinList_ValidList),

    Data = <<
        ValidList_Len:16, Bin_ValidList/binary
    >>,
    {ok, pt:pack(41807, Data)};

write (41808,[
    Rcode
]) ->
    Data = <<
        Rcode:32
    >>,
    {ok, pt:pack(41808, Data)};

write (41809,[
    RoleId,
    Name
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary
    >>,
    {ok, pt:pack(41809, Data)};

write (41810,[
    RoleId,
    Name,
    Res
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Res:32
    >>,
    {ok, pt:pack(41810, Data)};

write (41811,[
    Rcode,
    RoleId,
    Req
]) ->
    Data = <<
        Rcode:32,
        RoleId:64,
        Req:8
    >>,
    {ok, pt:pack(41811, Data)};

write (41812,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(41812, Data)};

write (41813,[
    PresList
]) ->
    BinList_PresList = [
        item_to_bin_2(PresList_Item) || PresList_Item <- PresList
    ], 

    PresList_Len = length(PresList), 
    Bin_PresList = list_to_binary(BinList_PresList),

    Data = <<
        PresList_Len:16, Bin_PresList/binary
    >>,
    {ok, pt:pack(41813, Data)};

write (41814,[
    Rcode,
    GiftTimes
]) ->
    Data = <<
        Rcode:8,
        GiftTimes:32
    >>,
    {ok, pt:pack(41814, Data)};

write (41815,[
    RoleId,
    OppRoleid,
    Name,
    GiftId
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        OppRoleid:64,
        Bin_Name/binary,
        GiftId:8
    >>,
    {ok, pt:pack(41815, Data)};

write (41816,[
    Rcode,
    EngageExp
]) ->
    Data = <<
        Rcode:32,
        EngageExp:32
    >>,
    {ok, pt:pack(41816, Data)};

write (41817,[
    Rank,
    AccExp,
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_3(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Rank:16,
        AccExp:32,
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(41817, Data)};

write (41818,[
    Name,
    EndTime
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Bin_Name/binary,
        EndTime:32
    >>,
    {ok, pt:pack(41818, Data)};

write (41819,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_4(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(41819, Data)};

write (41820,[
    X,
    Y
]) ->
    Data = <<
        X:16,
        Y:16
    >>,
    {ok, pt:pack(41820, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Rank,
    RoleId,
    Picture,
    ServerId,
    Name,
    GuildId,
    GuildName,
    CharmV,
    Career,
    Sex,
    Turn
}) ->
    Bin_Picture = pt:write_string(Picture), 

    Bin_Name = pt:write_string(Name), 

    Bin_GuildName = pt:write_string(GuildName), 

    Data = <<
        Rank:32,
        RoleId:64,
        Bin_Picture/binary,
        ServerId:32,
        Bin_Name/binary,
        GuildId:32,
        Bin_GuildName/binary,
        CharmV:32,
        Career:8,
        Sex:8,
        Turn:8
    >>,
    Data.
item_to_bin_1 ({
    RoleId,
    CharmV,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        CharmV:32,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    RoleName,
    Times,
    Opera
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Times:16,
        Opera:8
    >>,
    Data.
item_to_bin_3 ({
    Type,
    GoodsId,
    Num
}) ->
    Data = <<
        Type:8,
        GoodsId:32,
        Num:32
    >>,
    Data.
item_to_bin_4 ({
    RoleId,
    ServerId,
    Name,
    Career,
    Sex,
    Turn,
    Picture,
    CharmV
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        ServerId:32,
        Bin_Name/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        CharmV:32
    >>,
    Data.
