-module(pt_224).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22401, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, SubType]};
read(22402, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, SubType]};
read(22403, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, SubType]};
read(22405, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, SubType]};
read(_Cmd, _R) -> {error, no_match}.

write (22400,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(22400, Data)};

write (22401,[
    RankType,
    SelRank,
    SelVal,
    Sum,
    MaxLen,
    RankLimit,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankType:32,
        SelRank:32,
        SelVal:32,
        Sum:32,
        MaxLen:16,
        RankLimit:32,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22401, Data)};

write (22402,[
    RankType,
    Sum,
    MaxLen,
    Discount,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_2(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankType:32,
        Sum:32,
        MaxLen:16,
        Discount:16,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22402, Data)};

write (22403,[
    Type,
    SubType,
    SelRank,
    SelVal,
    SelZone,
    Sum,
    MaxLen,
    RankLimit,
    RankList,
    FigureList
]) ->
    BinList_RankList = [
        item_to_bin_5(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    BinList_FigureList = [
        item_to_bin_6(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        Type:32,
        SubType:16,
        SelRank:32,
        SelVal:32,
        SelZone:8,
        Sum:32,
        MaxLen:16,
        RankLimit:32,
        RankList_Len:16, Bin_RankList/binary,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    {ok, pt:pack(22403, Data)};

write (22405,[
    Code,
    Type,
    SubType,
    RankType,
    SelRank,
    SelVal,
    Sum,
    MaxLen,
    RankLimit,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_7(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        Code:32,
        Type:16,
        SubType:16,
        RankType:32,
        SelRank:32,
        SelVal:32,
        Sum:32,
        MaxLen:16,
        RankLimit:32,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22405, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PlayerId,
    Name,
    Sex,
    Career,
    Vip,
    GuildName,
    Picture,
    PictureVer,
    Turn,
    DressList,
    FirstValue,
    Rank
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_GuildName = pt:write_string(GuildName), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_DressList = [
        item_to_bin_1(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Data = <<
        PlayerId:64,
        Bin_Name/binary,
        Sex:8,
        Career:8,
        Vip:32,
        Bin_GuildName/binary,
        Bin_Picture/binary,
        PictureVer:32,
        Turn:8,
        DressList_Len:16, Bin_DressList/binary,
        FirstValue:32,
        Rank:32
    >>,
    Data.
item_to_bin_1 ({
    Type,
    DressId
}) ->
    Data = <<
        Type:8,
        DressId:32
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    Name,
    Sex,
    Career,
    Vip,
    Picture,
    PictureVer,
    Turn,
    DressList,
    SecId,
    SecName,
    SecSex,
    SecCareer,
    SecVip,
    SecPicture,
    SecPictureVer,
    SecTurn,
    SecDressList,
    FirstValue,
    SecondValue,
    RewardTimes,
    Rank
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    BinList_DressList = [
        item_to_bin_3(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Bin_SecName = pt:write_string(SecName), 

    Bin_SecPicture = pt:write_string(SecPicture), 

    BinList_SecDressList = [
        item_to_bin_4(SecDressList_Item) || SecDressList_Item <- SecDressList
    ], 

    SecDressList_Len = length(SecDressList), 
    Bin_SecDressList = list_to_binary(BinList_SecDressList),

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Sex:8,
        Career:8,
        Vip:32,
        Bin_Picture/binary,
        PictureVer:32,
        Turn:8,
        DressList_Len:16, Bin_DressList/binary,
        SecId:64,
        Bin_SecName/binary,
        SecSex:8,
        SecCareer:8,
        SecVip:32,
        Bin_SecPicture/binary,
        SecPictureVer:32,
        SecTurn:8,
        SecDressList_Len:16, Bin_SecDressList/binary,
        FirstValue:32,
        SecondValue:32,
        RewardTimes:16,
        Rank:32
    >>,
    Data.
item_to_bin_3 ({
    Type,
    DressId
}) ->
    Data = <<
        Type:8,
        DressId:32
    >>,
    Data.
item_to_bin_4 ({
    Type,
    DressId
}) ->
    Data = <<
        Type:8,
        DressId:32
    >>,
    Data.
item_to_bin_5 ({
    RoleId,
    ServerId,
    Zone,
    ServerNum,
    Name,
    FirstValue,
    Rank
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        ServerId:16,
        Zone:8,
        ServerNum:16,
        Bin_Name/binary,
        FirstValue:32,
        Rank:32
    >>,
    Data.
item_to_bin_6 ({
    RoleId,
    Figure
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        RoleId:64,
        Bin_Figure/binary
    >>,
    Data.
item_to_bin_7 ({
    RoleId,
    Name,
    FirstValue,
    Rank
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        FirstValue:32,
        Rank:32
    >>,
    Data.
