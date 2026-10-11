-module(pt_139).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13901, _) ->
    {ok, []};
read(13902, Bin0) ->
    <<WeaponId:32, _Bin1/binary>> = Bin0, 
    {ok, [WeaponId]};
read(13903, Bin0) ->
    <<WeaponId:32, _Bin1/binary>> = Bin0, 
    {ok, [WeaponId]};
read(13904, Bin0) ->
    <<WeaponId:32, _Bin1/binary>> = Bin0, 
    {ok, [WeaponId]};
read(13905, Bin0) ->
    <<WeaponId:32, _Bin1/binary>> = Bin0, 
    {ok, [WeaponId]};
read(_Cmd, _R) -> {error, no_match}.

write (13901,[
    WeaponList,
    LoopList
]) ->
    BinList_WeaponList = [
        item_to_bin_0(WeaponList_Item) || WeaponList_Item <- WeaponList
    ], 

    WeaponList_Len = length(WeaponList), 
    Bin_WeaponList = list_to_binary(BinList_WeaponList),

    BinList_LoopList = [
        item_to_bin_1(LoopList_Item) || LoopList_Item <- LoopList
    ], 

    LoopList_Len = length(LoopList), 
    Bin_LoopList = list_to_binary(BinList_LoopList),

    Data = <<
        WeaponList_Len:16, Bin_WeaponList/binary,
        LoopList_Len:16, Bin_LoopList/binary
    >>,
    {ok, pt:pack(13901, Data)};

write (13902,[
    Code,
    WeaponId,
    Lv,
    State
]) ->
    Data = <<
        Code:32,
        WeaponId:32,
        Lv:16,
        State:8
    >>,
    {ok, pt:pack(13902, Data)};

write (13903,[
    Code,
    No,
    ScoreAdd,
    WeaponId
]) ->
    Data = <<
        Code:32,
        No:8,
        ScoreAdd:16,
        WeaponId:32
    >>,
    {ok, pt:pack(13903, Data)};

write (13904,[
    Code,
    No,
    ScoreAdd,
    WeaponId,
    Lv,
    Score,
    State,
    LoopTimes,
    Utime
]) ->
    Data = <<
        Code:32,
        No:8,
        ScoreAdd:16,
        WeaponId:32,
        Lv:16,
        Score:32,
        State:8,
        LoopTimes:8,
        Utime:32
    >>,
    {ok, pt:pack(13904, Data)};

write (13905,[
    Code,
    WeaponId,
    State
]) ->
    Data = <<
        Code:32,
        WeaponId:32,
        State:8
    >>,
    {ok, pt:pack(13905, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    WeaponId,
    Lv,
    Score,
    State
}) ->
    Data = <<
        WeaponId:32,
        Lv:16,
        Score:32,
        State:8
    >>,
    Data.
item_to_bin_1 ({
    WeaponId,
    LoopTimes,
    Utime
}) ->
    Data = <<
        WeaponId:32,
        LoopTimes:8,
        Utime:32
    >>,
    Data.
