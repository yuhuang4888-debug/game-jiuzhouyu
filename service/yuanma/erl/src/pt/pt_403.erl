-module(pt_403).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40301, _) ->
    {ok, []};
read(40302, Bin0) ->
    <<AutoId:64, _Bin1/binary>> = Bin0, 
    {ok, [AutoId]};
read(_Cmd, _R) -> {error, no_match}.

write (40300,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40300, Data)};

write (40301,[
    Num,
    MaxNum,
    SendList,
    Log,
    Info
]) ->
    BinList_SendList = [
        item_to_bin_0(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    BinList_Log = [
        item_to_bin_1(Log_Item) || Log_Item <- Log
    ], 

    Log_Len = length(Log), 
    Bin_Log = list_to_binary(BinList_Log),

    BinList_Info = [
        item_to_bin_2(Info_Item) || Info_Item <- Info
    ], 

    Info_Len = length(Info), 
    Bin_Info = list_to_binary(BinList_Info),

    Data = <<
        Num:16,
        MaxNum:16,
        SendList_Len:16, Bin_SendList/binary,
        Log_Len:16, Bin_Log/binary,
        Info_Len:16, Bin_Info/binary
    >>,
    {ok, pt:pack(40301, Data)};

write (40302,[
    Code,
    SendList
]) ->
    BinList_SendList = [
        item_to_bin_3(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        Code:32,
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(40302, Data)};

write (40303,[
    SendList,
    Log
]) ->
    BinList_SendList = [
        item_to_bin_4(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    BinList_Log = [
        item_to_bin_5(Log_Item) || Log_Item <- Log
    ], 

    Log_Len = length(Log), 
    Bin_Log = list_to_binary(BinList_Log),

    Data = <<
        SendList_Len:16, Bin_SendList/binary,
        Log_Len:16, Bin_Log/binary
    >>,
    {ok, pt:pack(40303, Data)};

write (40304,[
    AutoId
]) ->
    Data = <<
        AutoId:64
    >>,
    {ok, pt:pack(40304, Data)};

write (40305,[
    Info
]) ->
    BinList_Info = [
        item_to_bin_6(Info_Item) || Info_Item <- Info
    ], 

    Info_Len = length(Info), 
    Bin_Info = list_to_binary(BinList_Info),

    Data = <<
        Info_Len:16, Bin_Info/binary
    >>,
    {ok, pt:pack(40305, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AutoId,
    RoleName,
    RoleId,
    TaskId,
    Status,
    Reward,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        AutoId:64,
        Bin_RoleName/binary,
        RoleId:64,
        TaskId:32,
        Status:8,
        Bin_Reward/binary,
        Time:32
    >>,
    Data.
item_to_bin_1 ({
    RoleName,
    RoleId,
    TaskId,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        RoleId:64,
        TaskId:32,
        Time:32
    >>,
    Data.
item_to_bin_2 ({
    TaskId,
    SendNum
}) ->
    Data = <<
        TaskId:32,
        SendNum:8
    >>,
    Data.
item_to_bin_3 ({
    AutoId,
    Reward
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        AutoId:64,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_4 ({
    AutoId,
    RoleName,
    RoleId,
    TaskId,
    Status,
    Reward,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        AutoId:64,
        Bin_RoleName/binary,
        RoleId:64,
        TaskId:32,
        Status:8,
        Bin_Reward/binary,
        Time:32
    >>,
    Data.
item_to_bin_5 ({
    RoleName,
    RoleId,
    TaskId,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Bin_RoleName/binary,
        RoleId:64,
        TaskId:32,
        Time:32
    >>,
    Data.
item_to_bin_6 ({
    TaskId,
    SendNum
}) ->
    Data = <<
        TaskId:32,
        SendNum:8
    >>,
    Data.
