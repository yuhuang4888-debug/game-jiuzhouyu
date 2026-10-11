-module(pt_201).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(20101, _) ->
    {ok, []};
read(20102, Bin0) ->
    <<GroupId:8, _Bin1/binary>> = Bin0, 
    {ok, [GroupId]};
read(_Cmd, _R) -> {error, no_match}.

write (20101,[
    GroupId,
    NextChoiceTime,
    PartnerList
]) ->
    BinList_PartnerList = [
        item_to_bin_0(PartnerList_Item) || PartnerList_Item <- PartnerList
    ], 

    PartnerList_Len = length(PartnerList), 
    Bin_PartnerList = list_to_binary(BinList_PartnerList),

    Data = <<
        GroupId:8,
        NextChoiceTime:32,
        PartnerList_Len:16, Bin_PartnerList/binary
    >>,
    {ok, pt:pack(20101, Data)};

write (20102,[
    ErrorCode,
    GroupId,
    NextChoiceTime
]) ->
    Data = <<
        ErrorCode:32,
        GroupId:8,
        NextChoiceTime:32
    >>,
    {ok, pt:pack(20102, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AutoId,
    PartnerId,
    Pos,
    Lv,
    Hp,
    HpLim
}) ->
    Data = <<
        AutoId:32,
        PartnerId:32,
        Pos:8,
        Lv:16,
        Hp:64,
        HpLim:64
    >>,
    Data.
