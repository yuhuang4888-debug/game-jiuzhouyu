-module(pt_221).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22101, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<Start:32, Bin2/binary>> = Bin1, 
    <<Len:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Start, Len]};
read(22102, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<Start:32, Bin2/binary>> = Bin1, 
    <<Len:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Start, Len]};
read(22103, _) ->
    {ok, []};
read(22104, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(22105, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (22100,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(22100, Data)};

write (22101,[
    RankType,
    Start,
    Len,
    RoleRank,
    SelVal,
    SelSecVal,
    Sum,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankType:32,
        Start:32,
        Len:32,
        RoleRank:32,
        SelVal:64,
        SelSecVal:32,
        Sum:32,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22101, Data)};

write (22102,[
    RankType,
    Start,
    Len,
    RoleRank,
    Sum,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_1(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankType:32,
        Start:32,
        Len:32,
        RoleRank:32,
        Sum:32,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22102, Data)};

write (22103,[
    Errcode,
    PraiseNum
]) ->
    Data = <<
        Errcode:32,
        PraiseNum:8
    >>,
    {ok, pt:pack(22103, Data)};

write (22104,[
    Errcode,
    PraiseNum
]) ->
    Data = <<
        Errcode:32,
        PraiseNum:32
    >>,
    {ok, pt:pack(22104, Data)};

write (22105,[
    PlayerId,
    Figure,
    Combat
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        PlayerId:64,
        Bin_Figure/binary,
        Combat:64
    >>,
    {ok, pt:pack(22105, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PlayerId,
    PraiseNum,
    Figure,
    SelCombat,
    FirstValue,
    SecondValue,
    ThirdValue,
    Rank
}) ->
    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        PlayerId:64,
        PraiseNum:32,
        Bin_Figure/binary,
        SelCombat:64,
        FirstValue:64,
        SecondValue:32,
        ThirdValue:32,
        Rank:32
    >>,
    Data.
item_to_bin_1 ({
    GuildId,
    GuildName,
    ChairmanId,
    ChairmanName,
    PraiseNum,
    GuildLv,
    MembersNum,
    Figure,
    SelCombat,
    FirstValue,
    Rank
}) ->
    Bin_GuildName = pt:write_string(GuildName), 

    Bin_ChairmanName = pt:write_string(ChairmanName), 

    Bin_Figure = pt:write_figure(Figure), 

    Data = <<
        GuildId:64,
        Bin_GuildName/binary,
        ChairmanId:64,
        Bin_ChairmanName/binary,
        PraiseNum:32,
        GuildLv:32,
        MembersNum:32,
        Bin_Figure/binary,
        SelCombat:32,
        FirstValue:32,
        Rank:32
    >>,
    Data.
