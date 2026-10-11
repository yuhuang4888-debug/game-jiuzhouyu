-module(pt_102).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(10200, _) ->
    {ok, []};
read(10201, _) ->
    {ok, []};
read(10202, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(10203, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Type:8, _Args1/binary>> = RestBin0, 
        <<Subtype:8, _Args2/binary>> = _Args1, 
        <<IsOpen:8, _Args3/binary>> = _Args2, 
        {{Type, Subtype, IsOpen},_Args3}
        end,
    {SettingList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [SettingList]};
read(10204, Bin0) ->
    <<ClientVer:64, _Bin1/binary>> = Bin0, 
    {ok, [ClientVer]};
read(10208, _) ->
    {ok, []};
read(10209, Bin0) ->
    <<SubscribeType:8, _Bin1/binary>> = Bin0, 
    {ok, [SubscribeType]};
read(10210, _) ->
    {ok, []};
read(10211, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (10200,[
    OpenDay,
    ServerInfo,
    List
]) ->
    BinList_ServerInfo = [
        item_to_bin_0(ServerInfo_Item) || ServerInfo_Item <- ServerInfo
    ], 

    ServerInfo_Len = length(ServerInfo), 
    Bin_ServerInfo = list_to_binary(BinList_ServerInfo),

    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        OpenDay:32,
        ServerInfo_Len:16, Bin_ServerInfo/binary,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(10200, Data)};

write (10201,[
    OpenTime,
    MergeTime,
    MergeStartTime,
    MergeCount,
    ServerTime
]) ->
    Data = <<
        OpenTime:32,
        MergeTime:32,
        MergeStartTime:32,
        MergeCount:32,
        ServerTime:64
    >>,
    {ok, pt:pack(10201, Data)};

write (10202,[
    Type,
    SettingList
]) ->
    BinList_SettingList = [
        item_to_bin_4(SettingList_Item) || SettingList_Item <- SettingList
    ], 

    SettingList_Len = length(SettingList), 
    Bin_SettingList = list_to_binary(BinList_SettingList),

    Data = <<
        Type:8,
        SettingList_Len:16, Bin_SettingList/binary
    >>,
    {ok, pt:pack(10202, Data)};

write (10203,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(10203, Data)};

write (10204,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(10204, Data)};

write (10205,[
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(10205, Data)};

write (10206,[
    Pt,
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Pt:16,
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(10206, Data)};

write (10207,[
    Type
]) ->
    Data = <<
        Type:8
    >>,
    {ok, pt:pack(10207, Data)};

write (10208,[
    SubscribeType
]) ->
    Data = <<
        SubscribeType:8
    >>,
    {ok, pt:pack(10208, Data)};



write (10210,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(10210, Data)};

write (10211,[
    Uid
]) ->
    Data = <<
        Uid:32
    >>,
    {ok, pt:pack(10211, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerId,
    ServerNum,
    ServerName,
    WorldLv
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerId:16,
        ServerNum:16,
        Bin_ServerName/binary,
        WorldLv:16
    >>,
    Data.
item_to_bin_1 ({
    ModuleId,
    Mod,
    AvgLv,
    ServerIds,
    NextServerIds
}) ->
    BinList_ServerIds = [
        item_to_bin_2(ServerIds_Item) || ServerIds_Item <- ServerIds
    ], 

    ServerIds_Len = length(ServerIds), 
    Bin_ServerIds = list_to_binary(BinList_ServerIds),

    BinList_NextServerIds = [
        item_to_bin_3(NextServerIds_Item) || NextServerIds_Item <- NextServerIds
    ], 

    NextServerIds_Len = length(NextServerIds), 
    Bin_NextServerIds = list_to_binary(BinList_NextServerIds),

    Data = <<
        ModuleId:16,
        Mod:8,
        AvgLv:16,
        ServerIds_Len:16, Bin_ServerIds/binary,
        NextServerIds_Len:16, Bin_NextServerIds/binary
    >>,
    Data.
item_to_bin_2 (
    ServerId
) ->
    Data = <<
        ServerId:16
    >>,
    Data.
item_to_bin_3 (
    ServerId
) ->
    Data = <<
        ServerId:16
    >>,
    Data.
item_to_bin_4 ({
    Subtype,
    IsOpen
}) ->
    Data = <<
        Subtype:16,
        IsOpen:8
    >>,
    Data.
