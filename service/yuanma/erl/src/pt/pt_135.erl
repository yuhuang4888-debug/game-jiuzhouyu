-module(pt_135).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13500, _) ->
    {ok, []};
read(13501, _) ->
    {ok, []};
read(13502, _) ->
    {ok, []};
read(13503, _) ->
    {ok, []};
read(13504, _) ->
    {ok, []};
read(13505, _) ->
    {ok, []};
read(13506, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(13510, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (13500,[
    State,
    LeftTime,
    Mod,
    GroupId,
    ServerList,
    AvgLv
]) ->
    BinList_ServerList = [
        item_to_bin_0(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        State:8,
        LeftTime:32,
        Mod:32,
        GroupId:32,
        ServerList_Len:16, Bin_ServerList/binary,
        AvgLv:64
    >>,
    {ok, pt:pack(13500, Data)};

write (13501,[
    FirstServerNum,
    FirstPlayer,
    GetList
]) ->
    Bin_FirstPlayer = pt:write_string(FirstPlayer), 

    BinList_GetList = [
        item_to_bin_1(GetList_Item) || GetList_Item <- GetList
    ], 

    GetList_Len = length(GetList), 
    Bin_GetList = list_to_binary(BinList_GetList),

    Data = <<
        FirstServerNum:16,
        Bin_FirstPlayer/binary,
        GetList_Len:16, Bin_GetList/binary
    >>,
    {ok, pt:pack(13501, Data)};

write (13502,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(13502, Data)};

write (13503,[
    CurFloor,
    MaxFloor,
    LeftTime,
    KillNum,
    Score,
    FirstServerNum,
    FirstPlayer
]) ->
    Bin_FirstPlayer = pt:write_string(FirstPlayer), 

    Data = <<
        CurFloor:8,
        MaxFloor:8,
        LeftTime:32,
        KillNum:16,
        Score:32,
        FirstServerNum:16,
        Bin_FirstPlayer/binary
    >>,
    {ok, pt:pack(13503, Data)};

write (13504,[
    Index,
    ServerNum,
    RoleId,
    RoleName,
    LeftTime
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Index:8,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        LeftTime:32
    >>,
    {ok, pt:pack(13504, Data)};

write (13505,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(13505, Data)};

write (13506,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(13506, Data)};

write (13507,[
    MaxFloor,
    Reward,
    FirstServerNum,
    FirstPlayer,
    GetList
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Bin_FirstPlayer = pt:write_string(FirstPlayer), 

    BinList_GetList = [
        item_to_bin_2(GetList_Item) || GetList_Item <- GetList
    ], 

    GetList_Len = length(GetList), 
    Bin_GetList = list_to_binary(BinList_GetList),

    Data = <<
        MaxFloor:8,
        Bin_Reward/binary,
        FirstServerNum:16,
        Bin_FirstPlayer/binary,
        GetList_Len:16, Bin_GetList/binary
    >>,
    {ok, pt:pack(13507, Data)};

write (13508,[
    Score,
    TotalScore
]) ->
    Data = <<
        Score:32,
        TotalScore:32
    >>,
    {ok, pt:pack(13508, Data)};

write (13509,[
    RoleId,
    Figure,
    Dkill
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary,
        Dkill:16
    >>,
    {ok, pt:pack(13509, Data)};

write (13510,[
    Figure
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        Bin_Figure/binary
    >>,
    {ok, pt:pack(13510, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    ServerName,
    WorldLv
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:64,
        ServerNum:64,
        Bin_ServerName/binary,
        WorldLv:64
    >>,
    Data.
item_to_bin_1 ({
    Index,
    ServerNum,
    RoleName
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Index:8,
        ServerNum:16,
        Bin_RoleName/binary
    >>,
    Data.
item_to_bin_2 ({
    Index,
    ServerNum,
    RoleName
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Index:8,
        ServerNum:16,
        Bin_RoleName/binary
    >>,
    Data.
