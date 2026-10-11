-module(pt_145).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14501, Bin0) ->
    <<ToId:64, _Bin1/binary>> = Bin0, 
    {ok, [ToId]};
read(14502, Bin0) ->
    {Picture, Bin1} = pt:read_string(Bin0), 
    <<Sex:8, Bin2/binary>> = Bin1, 
    <<SexSecrecy:8, Bin3/binary>> = Bin2, 
    <<Birthday:32, Bin4/binary>> = Bin3, 
    <<BirthdaySecrecy:8, Bin5/binary>> = Bin4, 
    {Signature, _Bin6} = pt:read_string(Bin5), 
    {ok, [Picture, Sex, SexSecrecy, Birthday, BirthdaySecrecy, Signature]};
read(_Cmd, _R) -> {error, no_match}.

write (14500,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(14500, Data)};

write (14501,[
    Id,
    Name,
    Career,
    GuildId,
    GuildName,
    Lv,
    Picture,
    PictureVer,
    Sex,
    SexSecrecy,
    Birthday,
    BirthdaySecrecy,
    Signature,
    VisitList,
    UpdateList,
    LastLoginIp
]) ->
    Bin_Name = pt:write_string(Name), 

    Bin_GuildName = pt:write_string(GuildName), 

    Bin_Picture = pt:write_string(Picture), 

    Bin_Signature = pt:write_string(Signature), 

    BinList_VisitList = [
        item_to_bin_0(VisitList_Item) || VisitList_Item <- VisitList
    ], 

    VisitList_Len = length(VisitList), 
    Bin_VisitList = list_to_binary(BinList_VisitList),

    BinList_UpdateList = [
        item_to_bin_1(UpdateList_Item) || UpdateList_Item <- UpdateList
    ], 

    UpdateList_Len = length(UpdateList), 
    Bin_UpdateList = list_to_binary(BinList_UpdateList),

    Bin_LastLoginIp = pt:write_string(LastLoginIp), 

    Data = <<
        Id:64,
        Bin_Name/binary,
        Career:32,
        GuildId:64,
        Bin_GuildName/binary,
        Lv:32,
        Bin_Picture/binary,
        PictureVer:32,
        Sex:8,
        SexSecrecy:8,
        Birthday:32,
        BirthdaySecrecy:8,
        Bin_Signature/binary,
        VisitList_Len:16, Bin_VisitList/binary,
        UpdateList_Len:16, Bin_UpdateList/binary,
        Bin_LastLoginIp/binary
    >>,
    {ok, pt:pack(14501, Data)};

write (14502,[
    Id,
    Result
]) ->
    Data = <<
        Id:64,
        Result:32
    >>,
    {ok, pt:pack(14502, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    VisitId,
    VisitName,
    VisitTime
}) ->
    Bin_VisitName = pt:write_string(VisitName), 

    Data = <<
        VisitId:64,
        Bin_VisitName/binary,
        VisitTime:32
    >>,
    Data.
item_to_bin_1 ({
    UpdateId,
    UpdateName,
    UpdateTime
}) ->
    Bin_UpdateName = pt:write_string(UpdateName), 

    Data = <<
        UpdateId:64,
        Bin_UpdateName/binary,
        UpdateTime:32
    >>,
    Data.
