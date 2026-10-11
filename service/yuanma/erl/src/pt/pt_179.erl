-module(pt_179).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17901, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Id:16, _Args0_1/binary>> = RestBin0, 

        FunArray1 = fun(<<RestBin1/binary>>) -> 
        <<Rid:16, _Args1_1/binary>> = RestBin1, 
        {Rid,_Args1_1}
        end,
        {Rids, _Args0_2} = pt:read_array(FunArray1, _Args0_1),
        {{Id, Rids},_Args0_2}
        end,
    {Pool, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [Pool]};
read(17902, _) ->
    {ok, []};
read(17903, _) ->
    {ok, []};
read(17904, _) ->
    {ok, []};
read(17905, _) ->
    {ok, []};
read(17906, Bin0) ->
    <<TaskId:16, _Bin1/binary>> = Bin0, 
    {ok, [TaskId]};
read(17907, _) ->
    {ok, []};
read(17908, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (17900,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17900, Data)};

write (17901,[
    Pool
]) ->
    BinList_Pool = [
        item_to_bin_0(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    Data = <<
        Pool_Len:16, Bin_Pool/binary
    >>,
    {ok, pt:pack(17901, Data)};

write (17902,[
    Person
]) ->
    BinList_Person = [
        item_to_bin_2(Person_Item) || Person_Item <- Person
    ], 

    Person_Len = length(Person), 
    Bin_Person = list_to_binary(BinList_Person),

    Data = <<
        Person_Len:16, Bin_Person/binary
    >>,
    {ok, pt:pack(17902, Data)};

write (17903,[
    Type,
    PoolId,
    DrawTimes
]) ->
    Data = <<
        Type:8,
        PoolId:16,
        DrawTimes:16
    >>,
    {ok, pt:pack(17903, Data)};

write (17904,[
    TaskState
]) ->
    BinList_TaskState = [
        item_to_bin_3(TaskState_Item) || TaskState_Item <- TaskState
    ], 

    TaskState_Len = length(TaskState), 
    Bin_TaskState = list_to_binary(BinList_TaskState),

    Data = <<
        TaskState_Len:16, Bin_TaskState/binary
    >>,
    {ok, pt:pack(17904, Data)};

write (17905,[
    Record
]) ->
    BinList_Record = [
        item_to_bin_4(Record_Item) || Record_Item <- Record
    ], 

    Record_Len = length(Record), 
    Bin_Record = list_to_binary(BinList_Record),

    Data = <<
        Record_Len:16, Bin_Record/binary
    >>,
    {ok, pt:pack(17905, Data)};

write (17906,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(17906, Data)};

write (17907,[
    Code,
    DrawTimes
]) ->
    Data = <<
        Code:8,
        DrawTimes:16
    >>,
    {ok, pt:pack(17907, Data)};

write (17908,[
    Pool
]) ->
    BinList_Pool = [
        item_to_bin_5(Pool_Item) || Pool_Item <- Pool
    ], 

    Pool_Len = length(Pool), 
    Bin_Pool = list_to_binary(BinList_Pool),

    Data = <<
        Pool_Len:16, Bin_Pool/binary
    >>,
    {ok, pt:pack(17908, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Rids
}) ->
    BinList_Rids = [
        item_to_bin_1(Rids_Item) || Rids_Item <- Rids
    ], 

    Rids_Len = length(Rids), 
    Bin_Rids = list_to_binary(BinList_Rids),

    Data = <<
        Id:16,
        Rids_Len:16, Bin_Rids/binary
    >>,
    Data.
item_to_bin_1 (
    Rid
) ->
    Data = <<
        Rid:16
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    RoleName,
    Type,
    PoolId,
    Utime,
    Picture,
    PictureVer,
    Career
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Type:8,
        PoolId:16,
        Utime:32,
        Bin_Picture/binary,
        PictureVer:32,
        Career:16
    >>,
    Data.
item_to_bin_3 ({
    TaskId,
    State
}) ->
    Data = <<
        TaskId:16,
        State:8
    >>,
    Data.
item_to_bin_4 ({
    Serverid,
    ServerNum,
    RoleId,
    RoleName,
    Type,
    PoolId,
    Utime,
    Picture,
    PictureVer,
    Career,
    Turn
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        Serverid:32,
        ServerNum:16,
        RoleId:64,
        Bin_RoleName/binary,
        Type:8,
        PoolId:16,
        Utime:32,
        Bin_Picture/binary,
        PictureVer:32,
        Career:16,
        Turn:16
    >>,
    Data.
item_to_bin_5 ({
    Id,
    Rids
}) ->
    BinList_Rids = [
        item_to_bin_6(Rids_Item) || Rids_Item <- Rids
    ], 

    Rids_Len = length(Rids), 
    Bin_Rids = list_to_binary(BinList_Rids),

    Data = <<
        Id:16,
        Rids_Len:16, Bin_Rids/binary
    >>,
    Data.
item_to_bin_6 (
    Rid
) ->
    Data = <<
        Rid:16
    >>,
    Data.
