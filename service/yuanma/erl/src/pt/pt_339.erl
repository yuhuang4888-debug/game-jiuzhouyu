-module(pt_339).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(33901, _) ->
    {ok, []};
read(33902, Bin0) ->
    <<RedEnvelopesId:64, _Bin1/binary>> = Bin0, 
    {ok, [RedEnvelopesId]};
read(33903, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Extra:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, Extra]};
read(33904, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<SplitNum:16, _Bin2/binary>> = Bin1, 
    {ok, [Id, SplitNum]};
read(33905, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<GtypeId:32, Bin2/binary>> = Bin1, 
    <<SplitNum:16, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, GtypeId, SplitNum]};
read(33906, Bin0) ->
    <<Money:32, Bin1/binary>> = Bin0, 
    <<SplitNum:16, Bin2/binary>> = Bin1, 
    {Msg, _Bin3} = pt:read_string(Bin2), 
    {ok, [Money, SplitNum, Msg]};
read(_Cmd, _R) -> {error, no_match}.

write (33900,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33900, Data)};

write (33901,[
    RedEnvelopesList,
    RecordList
]) ->
    BinList_RedEnvelopesList = [
        item_to_bin_0(RedEnvelopesList_Item) || RedEnvelopesList_Item <- RedEnvelopesList
    ], 

    RedEnvelopesList_Len = length(RedEnvelopesList), 
    Bin_RedEnvelopesList = list_to_binary(BinList_RedEnvelopesList),

    BinList_RecordList = [
        item_to_bin_1(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        RedEnvelopesList_Len:16, Bin_RedEnvelopesList/binary,
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(33901, Data)};

write (33902,[
    RedEnvelopesId,
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Picture,
    PictureVer,
    Status,
    ReceiveMoney,
    TotalNum,
    RecipientsNum,
    Money,
    Type,
    Extra,
    RecipientList
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_RecipientList = [
        item_to_bin_2(RecipientList_Item) || RecipientList_Item <- RecipientList
    ], 

    RecipientList_Len = length(RecipientList), 
    Bin_RecipientList = list_to_binary(BinList_RecipientList),

    Data = <<
        RedEnvelopesId:64,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32,
        Status:8,
        ReceiveMoney:32,
        TotalNum:16,
        RecipientsNum:16,
        Money:32,
        Type:8,
        Extra:32,
        RecipientList_Len:16, Bin_RecipientList/binary
    >>,
    {ok, pt:pack(33902, Data)};

write (33903,[
    TimesLimit,
    RemainTimes,
    TotalTimes,
    SplitNum
]) ->
    Data = <<
        TimesLimit:8,
        RemainTimes:8,
        TotalTimes:8,
        SplitNum:16
    >>,
    {ok, pt:pack(33903, Data)};

write (33904,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33904, Data)};

write (33905,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(33905, Data)};

write (33906,[
    Errcode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Errcode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(33906, Data)};

write (33907,[
    RedEnvelopesList
]) ->
    BinList_RedEnvelopesList = [
        item_to_bin_3(RedEnvelopesList_Item) || RedEnvelopesList_Item <- RedEnvelopesList
    ], 

    RedEnvelopesList_Len = length(RedEnvelopesList), 
    Bin_RedEnvelopesList = list_to_binary(BinList_RedEnvelopesList),

    Data = <<
        RedEnvelopesList_Len:16, Bin_RedEnvelopesList/binary
    >>,
    {ok, pt:pack(33907, Data)};

write (33908,[
    Id
]) ->
    Data = <<
        Id:64
    >>,
    {ok, pt:pack(33908, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Picture,
    PictureVer,
    Type,
    Extra,
    Status,
    ReceiveStatus,
    TotalNum,
    RecipientsNum,
    Msg,
    Stime
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Bin_Msg = pt:write_string(Msg), 

    Data = <<
        Id:64,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32,
        Type:8,
        Extra:32,
        Status:8,
        ReceiveStatus:8,
        TotalNum:16,
        RecipientsNum:16,
        Bin_Msg/binary,
        Stime:32
    >>,
    Data.
item_to_bin_1 ({
    Id,
    RoleName,
    CfgId,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Id:32,
        Bin_RoleName/binary,
        CfgId:32,
        Time:32
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Picture,
    PictureVer,
    ReceiveMoney,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32,
        ReceiveMoney:32,
        Time:32
    >>,
    Data.
item_to_bin_3 ({
    Id,
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Picture,
    PictureVer,
    Type,
    Extra,
    Status,
    ReceiveStatus,
    TotalNum,
    RecipientsNum,
    Msg,
    Stime
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_Picture = pt:write_string(Picture), 

    Bin_Msg = pt:write_string(Msg), 

    Data = <<
        Id:64,
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        PictureVer:32,
        Type:8,
        Extra:32,
        Status:8,
        ReceiveStatus:8,
        TotalNum:16,
        RecipientsNum:16,
        Bin_Msg/binary,
        Stime:32
    >>,
    Data.
