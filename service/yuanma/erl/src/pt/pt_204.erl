-module(pt_204).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(20401, _) ->
    {ok, []};
read(20402, Bin0) ->
    <<CastleId:16, _Bin1/binary>> = Bin0, 
    {ok, [CastleId]};
read(20403, Bin0) ->
    <<CastleId:16, _Bin1/binary>> = Bin0, 
    {ok, [CastleId]};
read(20404, _) ->
    {ok, []};
read(20405, _) ->
    {ok, []};
read(20406, Bin0) ->
    <<Stage:8, _Bin1/binary>> = Bin0, 
    {ok, [Stage]};
read(20407, _) ->
    {ok, []};
read(20408, Bin0) ->
    <<GoalId:16, _Bin1/binary>> = Bin0, 
    {ok, [GoalId]};
read(20409, _) ->
    {ok, []};
read(20410, _) ->
    {ok, []};
read(20411, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (20400,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(20400, Data)};

write (20401,[
    MyValue,
    MyServerValue,
    CastleList
]) ->
    BinList_CastleList = [
        item_to_bin_0(CastleList_Item) || CastleList_Item <- CastleList
    ], 

    CastleList_Len = length(CastleList), 
    Bin_CastleList = list_to_binary(BinList_CastleList),

    Data = <<
        MyValue:32,
        MyServerValue:32,
        CastleList_Len:16, Bin_CastleList/binary
    >>,
    {ok, pt:pack(20401, Data)};

write (20402,[
    CastleId,
    BaseServerNum,
    NeedValue,
    ServerNum,
    ServerName,
    ServerList,
    RoleList,
    RoleNum,
    ProvideNum
]) ->
    Bin_ServerName = pt:write_string(ServerName), 

    BinList_ServerList = [
        item_to_bin_3(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    BinList_RoleList = [
        item_to_bin_4(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        CastleId:16,
        BaseServerNum:32,
        NeedValue:32,
        ServerNum:32,
        Bin_ServerName/binary,
        ServerList_Len:16, Bin_ServerList/binary,
        RoleList_Len:16, Bin_RoleList/binary,
        RoleNum:16,
        ProvideNum:16
    >>,
    {ok, pt:pack(20402, Data)};

write (20403,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(20403, Data)};

write (20404,[
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_5(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(20404, Data)};

write (20405,[
    Value,
    AllValue,
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_6(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        Value:32,
        AllValue:32,
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(20405, Data)};

write (20406,[
    Stage,
    Code
]) ->
    Data = <<
        Stage:8,
        Code:32
    >>,
    {ok, pt:pack(20406, Data)};

write (20407,[
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_7(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(20407, Data)};

write (20408,[
    GoalId,
    Code
]) ->
    Data = <<
        GoalId:16,
        Code:32
    >>,
    {ok, pt:pack(20408, Data)};

write (20409,[
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_8(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(20409, Data)};

write (20410,[
    CastleId
]) ->
    Data = <<
        CastleId:32
    >>,
    {ok, pt:pack(20410, Data)};

write (20411,[
    Status,
    ServerList
]) ->
    BinList_ServerList = [
        item_to_bin_9(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    Data = <<
        Status:8,
        ServerList_Len:16, Bin_ServerList/binary
    >>,
    {ok, pt:pack(20411, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    CastleId,
    BaseServerNum,
    NeedValue,
    ServerNum,
    ServerName,
    ServerList,
    RoleList,
    RoleNum,
    ProvideNum
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    BinList_ServerList = [
        item_to_bin_1(ServerList_Item) || ServerList_Item <- ServerList
    ], 

    ServerList_Len = length(ServerList), 
    Bin_ServerList = list_to_binary(BinList_ServerList),

    BinList_RoleList = [
        item_to_bin_2(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        CastleId:16,
        BaseServerNum:32,
        NeedValue:32,
        ServerNum:32,
        Bin_ServerName/binary,
        ServerList_Len:16, Bin_ServerList/binary,
        RoleList_Len:16, Bin_RoleList/binary,
        RoleNum:16,
        ProvideNum:16
    >>,
    Data.
item_to_bin_1 ({
    ServerNum,
    ServerName,
    Value
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerNum:32,
        Bin_ServerName/binary,
        Value:32
    >>,
    Data.
item_to_bin_2 ({
    ServerNum2,
    RoleName,
    Value2,
    IsOccupy
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerNum2:32,
        Bin_RoleName/binary,
        Value2:32,
        IsOccupy:8
    >>,
    Data.
item_to_bin_3 ({
    ServerNum,
    ServerName,
    Value
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerNum:32,
        Bin_ServerName/binary,
        Value:32
    >>,
    Data.
item_to_bin_4 ({
    ServerNum2,
    RoleName,
    Value2,
    IsOccupy
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerNum2:32,
        Bin_RoleName/binary,
        Value2:32,
        IsOccupy:8
    >>,
    Data.
item_to_bin_5 ({
    Mod,
    SubMod,
    Value
}) ->
    Data = <<
        Mod:16,
        SubMod:16,
        Value:32
    >>,
    Data.
item_to_bin_6 ({
    Stage,
    Status
}) ->
    Data = <<
        Stage:8,
        Status:8
    >>,
    Data.
item_to_bin_7 ({
    GoalId,
    Value,
    Status
}) ->
    Data = <<
        GoalId:16,
        Value:32,
        Status:8
    >>,
    Data.
item_to_bin_8 ({
    ServerNum,
    RoleId,
    RoleName,
    Value
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerNum:32,
        RoleId:64,
        Bin_RoleName/binary,
        Value:32
    >>,
    Data.
item_to_bin_9 ({
    ServerNum,
    ServerName,
    Lv
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Data = <<
        ServerNum:32,
        Bin_ServerName/binary,
        Lv:16
    >>,
    Data.
