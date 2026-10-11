-module(pt_404).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40401, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<TargetCfgId:32, Bin3/binary>> = Bin2, 
    <<TargetId:64, _Bin4/binary>> = Bin3, 
    {ok, [Type, SubType, TargetCfgId, TargetId]};
read(40402, Bin0) ->
    <<AssistId:64, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [AssistId, Type]};
read(40403, Bin0) ->
    <<AssistId:64, _Bin1/binary>> = Bin0, 
    {ok, [AssistId]};
read(40404, _) ->
    {ok, []};
read(40405, _) ->
    {ok, []};
read(40408, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (40401,[
    ErrorCode,
    AssistId,
    Type,
    SubType,
    TargetCfgId,
    TargetId
]) ->
    Data = <<
        ErrorCode:32,
        AssistId:64,
        Type:8,
        SubType:16,
        TargetCfgId:32,
        TargetId:64
    >>,
    {ok, pt:pack(40401, Data)};

write (40402,[
    ErrorCode,
    AssistId,
    Type
]) ->
    Data = <<
        ErrorCode:32,
        AssistId:64,
        Type:8
    >>,
    {ok, pt:pack(40402, Data)};

write (40403,[
    ErrorCode,
    CancelType,
    AssistId,
    AskId
]) ->
    Data = <<
        ErrorCode:32,
        CancelType:8,
        AssistId:64,
        AskId:64
    >>,
    {ok, pt:pack(40403, Data)};

write (40404,[
    AssistCount
]) ->
    Data = <<
        AssistCount:8
    >>,
    {ok, pt:pack(40404, Data)};

write (40405,[
    AssistList
]) ->
    BinList_AssistList = [
        item_to_bin_0(AssistList_Item) || AssistList_Item <- AssistList
    ], 

    AssistList_Len = length(AssistList), 
    Bin_AssistList = list_to_binary(BinList_AssistList),

    Data = <<
        AssistList_Len:16, Bin_AssistList/binary
    >>,
    {ok, pt:pack(40405, Data)};

write (40406,[
    AssistId,
    Type,
    SubType,
    TargetCfgId,
    TargetId,
    RoleId,
    Name,
    Level,
    Career,
    Sex,
    Pic,
    PicVer,
    IsAssist,
    Extra
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Pic = pt:write_string(Pic), 

    BinList_Extra = [
        item_to_bin_2(Extra_Item) || Extra_Item <- Extra
    ], 

    Extra_Len = length(Extra), 
    Bin_Extra = list_to_binary(BinList_Extra),

    Data = <<
        AssistId:64,
        Type:8,
        SubType:16,
        TargetCfgId:32,
        TargetId:64,
        RoleId:64,
        Bin_Name/binary,
        Level:16,
        Career:8,
        Sex:8,
        Bin_Pic/binary,
        PicVer:32,
        IsAssist:8,
        Extra_Len:16, Bin_Extra/binary
    >>,
    {ok, pt:pack(40406, Data)};

write (40407,[
    AssistId
]) ->
    Data = <<
        AssistId:64
    >>,
    {ok, pt:pack(40407, Data)};

write (40408,[
    AssistId,
    Type,
    SubType,
    TargetCfgId,
    TargetId,
    RoleId,
    Name,
    Level,
    Career,
    Sex,
    Pic,
    PicVer
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Pic = pt:write_string(Pic), 

    Data = <<
        AssistId:64,
        Type:8,
        SubType:16,
        TargetCfgId:32,
        TargetId:64,
        RoleId:64,
        Bin_Name/binary,
        Level:16,
        Career:8,
        Sex:8,
        Bin_Pic/binary,
        PicVer:32
    >>,
    {ok, pt:pack(40408, Data)};

write (40409,[
    AssistId
]) ->
    Data = <<
        AssistId:64
    >>,
    {ok, pt:pack(40409, Data)};

write (40410,[
    AssistId,
    RoleId,
    Name
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        AssistId:64,
        RoleId:64,
        Bin_Name/binary
    >>,
    {ok, pt:pack(40410, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AssistId,
    Type,
    SubType,
    TargetCfgId,
    TargetId,
    RoleId,
    Name,
    Level,
    Career,
    Sex,
    Pic,
    PicVer,
    IsAssist,
    Extra
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Pic = pt:write_string(Pic), 

    BinList_Extra = [
        item_to_bin_1(Extra_Item) || Extra_Item <- Extra
    ], 

    Extra_Len = length(Extra), 
    Bin_Extra = list_to_binary(BinList_Extra),

    Data = <<
        AssistId:64,
        Type:8,
        SubType:16,
        TargetCfgId:32,
        TargetId:64,
        RoleId:64,
        Bin_Name/binary,
        Level:16,
        Career:8,
        Sex:8,
        Bin_Pic/binary,
        PicVer:32,
        IsAssist:8,
        Extra_Len:16, Bin_Extra/binary
    >>,
    Data.
item_to_bin_1 ({
    SerId,
    SerNum,
    RoberId,
    RoberName,
    RoberPower,
    RoberReward,
    BackReward
}) ->
    Bin_RoberName = pt:write_string(RoberName), 

    Bin_RoberReward = pt:write_object_list(RoberReward), 

    Bin_BackReward = pt:write_object_list(BackReward), 

    Data = <<
        SerId:32,
        SerNum:16,
        RoberId:64,
        Bin_RoberName/binary,
        RoberPower:32,
        Bin_RoberReward/binary,
        Bin_BackReward/binary
    >>,
    Data.
item_to_bin_2 ({
    SerId,
    SerNum,
    RoberId,
    RoberName,
    RoberPower,
    RoberReward,
    BackReward
}) ->
    Bin_RoberName = pt:write_string(RoberName), 

    Bin_RoberReward = pt:write_object_list(RoberReward), 

    Bin_BackReward = pt:write_object_list(BackReward), 

    Data = <<
        SerId:32,
        SerNum:16,
        RoberId:64,
        Bin_RoberName/binary,
        RoberPower:32,
        Bin_RoberReward/binary,
        Bin_BackReward/binary
    >>,
    Data.
