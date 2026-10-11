-module(pt_442).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(44201, Bin0) ->
    <<Type:16, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(44202, Bin0) ->
    <<PicId:32, _Bin1/binary>> = Bin0, 
    {ok, [PicId]};
read(44203, Bin0) ->
    <<PicId:32, _Bin1/binary>> = Bin0, 
    {ok, [PicId]};
read(44204, Bin0) ->
    <<GroupId:32, _Bin1/binary>> = Bin0, 
    {ok, [GroupId]};
read(44205, _) ->
    {ok, []};
read(44207, Bin0) ->
    <<PicId:32, _Bin1/binary>> = Bin0, 
    {ok, [PicId]};
read(_Cmd, _R) -> {error, no_match}.

write (44201,[
    Type,
    GroupList,
    PicList,
    PicCombat
]) ->
    BinList_GroupList = [
        item_to_bin_0(GroupList_Item) || GroupList_Item <- GroupList
    ], 

    GroupList_Len = length(GroupList), 
    Bin_GroupList = list_to_binary(BinList_GroupList),

    BinList_PicList = [
        item_to_bin_1(PicList_Item) || PicList_Item <- PicList
    ], 

    PicList_Len = length(PicList), 
    Bin_PicList = list_to_binary(BinList_PicList),

    Data = <<
        Type:16,
        GroupList_Len:16, Bin_GroupList/binary,
        PicList_Len:16, Bin_PicList/binary,
        PicCombat:64
    >>,
    {ok, pt:pack(44201, Data)};

write (44202,[
    Errcode,
    PicId,
    CurPower,
    NextPower
]) ->
    Data = <<
        Errcode:32,
        PicId:32,
        CurPower:64,
        NextPower:64
    >>,
    {ok, pt:pack(44202, Data)};

write (44203,[
    Errcode,
    PicId,
    Lv,
    CurPower,
    NextPower
]) ->
    Data = <<
        Errcode:32,
        PicId:32,
        Lv:16,
        CurPower:64,
        NextPower:64
    >>,
    {ok, pt:pack(44203, Data)};

write (44204,[
    Errcode,
    GroupId,
    Lv
]) ->
    Data = <<
        Errcode:32,
        GroupId:32,
        Lv:16
    >>,
    {ok, pt:pack(44204, Data)};

write (44205,[
    PicList
]) ->
    BinList_PicList = [
        item_to_bin_2(PicList_Item) || PicList_Item <- PicList
    ], 

    PicList_Len = length(PicList), 
    Bin_PicList = list_to_binary(BinList_PicList),

    Data = <<
        PicList_Len:16, Bin_PicList/binary
    >>,
    {ok, pt:pack(44205, Data)};

write (44207,[
    PicId,
    NextPower
]) ->
    Data = <<
        PicId:32,
        NextPower:64
    >>,
    {ok, pt:pack(44207, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GroupId,
    Lv
}) ->
    Data = <<
        GroupId:32,
        Lv:16
    >>,
    Data.
item_to_bin_1 ({
    PicId,
    Lv,
    CurPower,
    NextPower
}) ->
    Data = <<
        PicId:32,
        Lv:16,
        CurPower:64,
        NextPower:64
    >>,
    Data.
item_to_bin_2 (
    PicId
) ->
    Data = <<
        PicId:32
    >>,
    Data.
