-module(pt_110).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(11001, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    {Province, Bin2} = pt:read_string(Bin1), 
    {City, Bin3} = pt:read_string(Bin2), 
    <<ReceiveId:64, Bin4/binary>> = Bin3, 
    {Msg, Bin5} = pt:read_string(Bin4), 
    {Args, Bin6} = pt:read_string(Bin5), 
    <<TkTime:32, Bin7/binary>> = Bin6, 
    {Ticket, _Bin8} = pt:read_string(Bin7), 
    {ok, [Channel, Province, City, ReceiveId, Msg, Args, TkTime, Ticket]};
read(11003, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    <<ReceiveId:64, Bin2/binary>> = Bin1, 
    <<VoiceMsgTime:32, Bin3/binary>> = Bin2, 
    <<TkTime:32, Bin4/binary>> = Bin3, 
    {Ticket, Bin5} = pt:read_string(Bin4), 
    {DataSend, Bin6} = pt:read_voice_bin(Bin5), 
    {VoiceText, Bin7} = pt:read_string(Bin6), 
    <<AutoId:64, Bin8/binary>> = Bin7, 
    <<IsEnd:8, _Bin9/binary>> = Bin8, 
    {ok, [Channel, ReceiveId, VoiceMsgTime, TkTime, Ticket, DataSend, VoiceText, AutoId, IsEnd]};
read(11004, Bin0) ->
    <<AutoId:64, Bin1/binary>> = Bin0, 
    <<PlayerId:64, Bin2/binary>> = Bin1, 
    <<TkTime:32, Bin3/binary>> = Bin2, 
    {Ticket, _Bin4} = pt:read_string(Bin3), 
    {ok, [AutoId, PlayerId, TkTime, Ticket]};
read(11005, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    <<ReceiveId:64, Bin2/binary>> = Bin1, 
    <<AutoId:64, Bin3/binary>> = Bin2, 
    {VoiceText, _Bin4} = pt:read_string(Bin3), 
    {ok, [Channel, ReceiveId, AutoId, VoiceText]};
read(11006, Bin0) ->
    <<AutoId:64, Bin1/binary>> = Bin0, 
    <<PlayerId:64, _Bin2/binary>> = Bin1, 
    {ok, [AutoId, PlayerId]};
read(11007, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    <<PreceiveId:64, Bin2/binary>> = Bin1, 
    <<IsEnd:8, Bin3/binary>> = Bin2, 
    <<TkTime:32, Bin4/binary>> = Bin3, 
    {Ticket, Bin5} = pt:read_string(Bin4), 
    {TinyPicture, Bin6} = pt:read_string(Bin5), 
    {RealPicture, _Bin7} = pt:read_string(Bin6), 
    {ok, [Channel, PreceiveId, IsEnd, TkTime, Ticket, TinyPicture, RealPicture]};
read(11008, Bin0) ->
    <<AutoId:64, Bin1/binary>> = Bin0, 
    <<TkTime:32, Bin2/binary>> = Bin1, 
    {Ticket, _Bin3} = pt:read_string(Bin2), 
    {ok, [AutoId, TkTime, Ticket]};
read(11010, Bin0) ->
    <<Channel:8, _Bin1/binary>> = Bin0, 
    {ok, [Channel]};
read(11011, _) ->
    {ok, []};
read(11016, Bin0) ->
    <<ModuleId:16, Bin1/binary>> = Bin0, 
    <<Type:16, _Bin2/binary>> = Bin1, 
    {ok, [ModuleId, Type]};
read(11022, Bin0) ->
    <<BossType:8, Bin1/binary>> = Bin0, 
    <<KillId:64, Bin2/binary>> = Bin1, 
    {KillName, _Bin3} = pt:read_string(Bin2), 
    {ok, [BossType, KillId, KillName]};
read(11023, _) ->
    {ok, []};
read(11024, _) ->
    {ok, []};
read(11025, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {IdList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [Channel, IdList]};
read(11026, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [Channel, GoodsId]};
read(11027, Bin0) ->
    <<Channel:8, Bin1/binary>> = Bin0, 
    <<RoleId:64, _Bin2/binary>> = Bin1, 
    {ok, [Channel, RoleId]};
read(11028, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(11040, Bin0) ->
    <<Uid:64, Bin1/binary>> = Bin0, 
    <<LimitTime:8, _Bin2/binary>> = Bin1, 
    {ok, [Uid, LimitTime]};
read(11041, Bin0) ->
    <<Uid:64, _Bin1/binary>> = Bin0, 
    {ok, [Uid]};
read(11043, Bin0) ->
    <<Uid:64, _Bin1/binary>> = Bin0, 
    {ok, [Uid]};
read(11044, Bin0) ->
    <<TargetId:64, _Bin1/binary>> = Bin0, 
    {ok, [TargetId]};
read(11045, Bin0) ->
    <<TargetId:64, Bin1/binary>> = Bin0, 
    {TargetData, _Bin2} = pt:read_string(Bin1), 
    {ok, [TargetId, TargetData]};
read(11047, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<TargetId:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, TargetId]};
read(11048, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<TargetId:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, TargetId]};
read(11050, _) ->
    {ok, []};
read(11064, _) ->
    {ok, []};
read(11065, Bin0) ->
    {PackageCode, _Bin1} = pt:read_string(Bin0), 
    {ok, [PackageCode]};
read(_Cmd, _R) -> {error, no_match}.

write (11000,[
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(11000, Data)};

write (11001,[
    Channel,
    ServerNum,
    CServerMsg,
    SerId,
    SerName,
    Province,
    City,
    PlayerId,
    Figure,
    Msg,
    Args,
    Result,
    Time
]) ->
    Bin_CServerMsg = pt:write_string(CServerMsg), 

    Bin_SerName = pt:write_string(SerName), 

    Bin_Province = pt:write_string(Province), 

    Bin_City = pt:write_string(City), 

    Bin_Figure = pt:write_figure(Figure), 

    Bin_Msg = pt:write_string(Msg), 

    Bin_Args = pt:write_string(Args), 

    Data = <<
        Channel:8,
        ServerNum:16,
        Bin_CServerMsg/binary,
        SerId:16,
        Bin_SerName/binary,
        Bin_Province/binary,
        Bin_City/binary,
        PlayerId:64,
        Bin_Figure/binary,
        Bin_Msg/binary,
        Bin_Args/binary,
        Result:8,
        Time:32
    >>,
    {ok, pt:pack(11001, Data)};

write (11002,[
    Channel,
    ServerNum,
    SerId,
    SerName,
    PlayerList,
    Msg,
    Args,
    Result,
    Time
]) ->
    Bin_SerName = pt:write_string(SerName), 

    BinList_PlayerList = [
        item_to_bin_0(PlayerList_Item) || PlayerList_Item <- PlayerList
    ], 

    PlayerList_Len = length(PlayerList), 
    Bin_PlayerList = list_to_binary(BinList_PlayerList),

    Bin_Msg = pt:write_string(Msg), 

    Bin_Args = pt:write_string(Args), 

    Data = <<
        Channel:8,
        ServerNum:16,
        SerId:16,
        Bin_SerName/binary,
        PlayerList_Len:16, Bin_PlayerList/binary,
        Bin_Msg/binary,
        Bin_Args/binary,
        Result:8,
        Time:32
    >>,
    {ok, pt:pack(11002, Data)};

write (11003,[
    Channel,
    ServerNum,
    SerId,
    SerName,
    PlayerList,
    ClientVer,
    AutoId,
    ReceiveId,
    VoiceText,
    VoiceMsgTime,
    Time
]) ->
    Bin_SerName = pt:write_string(SerName), 

    BinList_PlayerList = [
        item_to_bin_1(PlayerList_Item) || PlayerList_Item <- PlayerList
    ], 

    PlayerList_Len = length(PlayerList), 
    Bin_PlayerList = list_to_binary(BinList_PlayerList),

    Bin_VoiceText = pt:write_string(VoiceText), 

    Data = <<
        Channel:8,
        ServerNum:16,
        SerId:16,
        Bin_SerName/binary,
        PlayerList_Len:16, Bin_PlayerList/binary,
        ClientVer:64,
        AutoId:64,
        ReceiveId:32,
        Bin_VoiceText/binary,
        VoiceMsgTime:16,
        Time:32
    >>,
    {ok, pt:pack(11003, Data)};

write (11004,[
    ErrorCode,
    AutoId,
    DataSend
]) ->
    Bin_DataSend = pt:write_voice_bin(DataSend), 

    Data = <<
        ErrorCode:32,
        AutoId:64,
        Bin_DataSend/binary
    >>,
    {ok, pt:pack(11004, Data)};

write (11005,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:8
    >>,
    {ok, pt:pack(11005, Data)};

write (11006,[
    ErrorCode,
    AutoId,
    VoiceText
]) ->
    Bin_VoiceText = pt:write_string(VoiceText), 

    Data = <<
        ErrorCode:8,
        AutoId:64,
        Bin_VoiceText/binary
    >>,
    {ok, pt:pack(11006, Data)};

write (11007,[
    Channel,
    PlayerId,
    Figure,
    AutoId,
    ReceiveId,
    TinyPicture
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Bin_TinyPicture = pt:write_string(TinyPicture), 

    Data = <<
        Channel:8,
        PlayerId:64,
        Bin_Figure/binary,
        AutoId:64,
        ReceiveId:64,
        Bin_TinyPicture/binary
    >>,
    {ok, pt:pack(11007, Data)};

write (11008,[
    AutoId,
    Picture
]) ->
    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        AutoId:64,
        Bin_Picture/binary
    >>,
    {ok, pt:pack(11008, Data)};

write (11009,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:8
    >>,
    {ok, pt:pack(11009, Data)};

write (11010,[
    CacheList
]) ->
    BinList_CacheList = [
        item_to_bin_2(CacheList_Item) || CacheList_Item <- CacheList
    ], 

    CacheList_Len = length(CacheList), 
    Bin_CacheList = list_to_binary(BinList_CacheList),

    Data = <<
        CacheList_Len:16, Bin_CacheList/binary
    >>,
    {ok, pt:pack(11010, Data)};

write (11011,[
    Count
]) ->
    Data = <<
        Count:32
    >>,
    {ok, pt:pack(11011, Data)};

write (11012,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(11012, Data)};

write (11013,[
    Channel,
    AutoId,
    VoiceText
]) ->
    Bin_VoiceText = pt:write_string(VoiceText), 

    Data = <<
        Channel:8,
        AutoId:64,
        Bin_VoiceText/binary
    >>,
    {ok, pt:pack(11013, Data)};

write (11014,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(11014, Data)};

write (11015,[
    ModuleId,
    Id,
    Content
]) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        ModuleId:16,
        Id:16,
        Bin_Content/binary
    >>,
    {ok, pt:pack(11015, Data)};

write (11016,[
    ModuleId,
    Type,
    Num
]) ->
    Data = <<
        ModuleId:16,
        Type:16,
        Num:16
    >>,
    {ok, pt:pack(11016, Data)};

write (11017,[
    Type,
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        Type:8,
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(11017, Data)};

write (11018,[
    SerId,
    PlayerId,
    Figure,
    ModuleId,
    Id,
    Content
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Bin_Content = pt:write_string(Content), 

    Data = <<
        SerId:16,
        PlayerId:64,
        Bin_Figure/binary,
        ModuleId:16,
        Id:16,
        Bin_Content/binary
    >>,
    {ok, pt:pack(11018, Data)};

write (11019,[
    ModuleId,
    Id,
    ContentList
]) ->
    BinList_ContentList = [
        item_to_bin_4(ContentList_Item) || ContentList_Item <- ContentList
    ], 

    ContentList_Len = length(ContentList), 
    Bin_ContentList = list_to_binary(BinList_ContentList),

    Data = <<
        ModuleId:16,
        Id:16,
        ContentList_Len:16, Bin_ContentList/binary
    >>,
    {ok, pt:pack(11019, Data)};

write (11020,[
    Content
]) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        Bin_Content/binary
    >>,
    {ok, pt:pack(11020, Data)};

write (11021,[
    Channel,
    Gm,
    Time,
    Msg
]) ->
    Bin_Msg = pt:write_string(Msg), 

    Data = <<
        Channel:8,
        Gm:8,
        Time:16,
        Bin_Msg/binary
    >>,
    {ok, pt:pack(11021, Data)};



write (11023,[
    IsOpen
]) ->
    Data = <<
        IsOpen:8
    >>,
    {ok, pt:pack(11023, Data)};

write (11024,[
    IsOpen
]) ->
    Data = <<
        IsOpen:8
    >>,
    {ok, pt:pack(11024, Data)};

write (11025,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(11025, Data)};

write (11026,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(11026, Data)};

write (11027,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(11027, Data)};

write (11028,[
    ErrorCode,
    RoleId,
    Figure,
    CombatPower,
    OnlineFlag,
    Intimacy
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        ErrorCode:32,
        RoleId:64,
        Bin_Figure/binary,
        CombatPower:64,
        OnlineFlag:8,
        Intimacy:32
    >>,
    {ok, pt:pack(11028, Data)};

write (11029,[
    Channel,
    ServerNum,
    SerId,
    SerName,
    Province,
    City,
    HornType,
    PlayerId,
    Figure,
    Msg,
    Args,
    Result,
    Time
]) ->
    Bin_SerName = pt:write_string(SerName), 

    Bin_Province = pt:write_string(Province), 

    Bin_City = pt:write_string(City), 

    Bin_Figure = pt:write_figure(Figure), 

    Bin_Msg = pt:write_string(Msg), 

    Bin_Args = pt:write_string(Args), 

    Data = <<
        Channel:8,
        ServerNum:16,
        SerId:16,
        Bin_SerName/binary,
        Bin_Province/binary,
        Bin_City/binary,
        HornType:8,
        PlayerId:64,
        Bin_Figure/binary,
        Bin_Msg/binary,
        Bin_Args/binary,
        Result:8,
        Time:32
    >>,
    {ok, pt:pack(11029, Data)};

write (11040,[
    Result
]) ->
    Data = <<
        Result:8
    >>,
    {ok, pt:pack(11040, Data)};

write (11041,[
    Result
]) ->
    Data = <<
        Result:8
    >>,
    {ok, pt:pack(11041, Data)};

write (11042,[
    Result
]) ->
    Data = <<
        Result:8
    >>,
    {ok, pt:pack(11042, Data)};

write (11043,[
    Result
]) ->
    Data = <<
        Result:8
    >>,
    {ok, pt:pack(11043, Data)};

write (11044,[
    Result
]) ->
    Data = <<
        Result:8
    >>,
    {ok, pt:pack(11044, Data)};

write (11045,[
    Result
]) ->
    Data = <<
        Result:32
    >>,
    {ok, pt:pack(11045, Data)};

write (11046,[
    List
]) ->
    BinList_List = [
        item_to_bin_5(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(11046, Data)};

write (11047,[
    Result,
    Type
]) ->
    Data = <<
        Result:32,
        Type:8
    >>,
    {ok, pt:pack(11047, Data)};

write (11048,[
    Result
]) ->
    Data = <<
        Result:32
    >>,
    {ok, pt:pack(11048, Data)};

write (11050,[
    NoticeList
]) ->
    BinList_NoticeList = [
        item_to_bin_6(NoticeList_Item) || NoticeList_Item <- NoticeList
    ], 

    NoticeList_Len = length(NoticeList), 
    Bin_NoticeList = list_to_binary(BinList_NoticeList),

    Data = <<
        NoticeList_Len:16, Bin_NoticeList/binary
    >>,
    {ok, pt:pack(11050, Data)};

write (11060,[
    Type,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_7(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Type:8,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(11060, Data)};

write (11061,[
    ObjectList
]) ->
    Bin_ObjectList = pt:write_object_list(ObjectList), 

    Data = <<
        Bin_ObjectList/binary
    >>,
    {ok, pt:pack(11061, Data)};

write (11062,[
    LanguageId,
    ArgsList
]) ->
    BinList_ArgsList = [
        item_to_bin_8(ArgsList_Item) || ArgsList_Item <- ArgsList
    ], 

    ArgsList_Len = length(ArgsList), 
    Bin_ArgsList = list_to_binary(BinList_ArgsList),

    Data = <<
        LanguageId:32,
        ArgsList_Len:16, Bin_ArgsList/binary
    >>,
    {ok, pt:pack(11062, Data)};

write (11063,[
    Effect
]) ->
    Bin_Effect = pt:write_string(Effect), 

    Data = <<
        Bin_Effect/binary
    >>,
    {ok, pt:pack(11063, Data)};

write (11064,[
    Type
]) ->
    Data = <<
        Type:8
    >>,
    {ok, pt:pack(11064, Data)};

write (11065,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(11065, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PlayerId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        PlayerId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_1 ({
    PlayerId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        PlayerId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_2 ({
    Channel,
    PlayerList,
    Msg,
    Args,
    Result,
    Time,
    IsRead,
    VoiceId,
    VoiceTime
}) ->
    BinList_PlayerList = [
        item_to_bin_3(PlayerList_Item) || PlayerList_Item <- PlayerList
    ], 

    PlayerList_Len = length(PlayerList), 
    Bin_PlayerList = list_to_binary(BinList_PlayerList),

    Bin_Msg = pt:write_string(Msg), 

    Bin_Args = pt:write_string(Args), 

    Data = <<
        Channel:8,
        PlayerList_Len:16, Bin_PlayerList/binary,
        Bin_Msg/binary,
        Bin_Args/binary,
        Result:8,
        Time:32,
        IsRead:8,
        VoiceId:64,
        VoiceTime:16
    >>,
    Data.
item_to_bin_3 ({
    ServerNum,
    CServerMsg,
    SerId,
    SerName,
    PlayerId,
    Figure
}) ->
    Bin_CServerMsg = pt:write_string(CServerMsg), 

    Bin_SerName = pt:write_string(SerName), 

    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        ServerNum:16,
        Bin_CServerMsg/binary,
        SerId:16,
        Bin_SerName/binary,
        PlayerId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_4 (
    Content
) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        Bin_Content/binary
    >>,
    Data.
item_to_bin_5 (
    RoleId
) ->
    Data = <<
        RoleId:64
    >>,
    Data.
item_to_bin_6 ({
    Source,
    Type,
    Color,
    Content,
    Url,
    SendCount,
    SendGap,
    StartTime,
    EndTime,
    State
}) ->
    Bin_Source = pt:write_string(Source), 

    Bin_Color = pt:write_string(Color), 

    Bin_Content = pt:write_string(Content), 

    Bin_Url = pt:write_string(Url), 

    Data = <<
        Bin_Source/binary,
        Type:8,
        Bin_Color/binary,
        Bin_Content/binary,
        Bin_Url/binary,
        SendCount:32,
        SendGap:16,
        StartTime:32,
        EndTime:32,
        State:8
    >>,
    Data.
item_to_bin_7 ({
    GoodsTypeId,
    Num
}) ->
    Data = <<
        GoodsTypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_8 (
    Args
) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Bin_Args/binary
    >>,
    Data.
