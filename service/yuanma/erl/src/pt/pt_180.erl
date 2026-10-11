-module(pt_180).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18001, Bin0) ->
    <<AnimaId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, Bin2/binary>> = Bin1, 
    <<EquipPos:8, _Bin3/binary>> = Bin2, 
    {ok, [AnimaId, GoodsId, EquipPos]};
read(18002, Bin0) ->
    <<AnimaId:8, Bin1/binary>> = Bin0, 
    <<EquipPos:8, _Bin2/binary>> = Bin1, 
    {ok, [AnimaId, EquipPos]};
read(_Cmd, _R) -> {error, no_match}.

write (18001,[
    Errcode,
    AnimaId,
    GoodsId,
    EquipPos,
    GtypeId
]) ->
    Data = <<
        Errcode:32,
        AnimaId:8,
        GoodsId:64,
        EquipPos:8,
        GtypeId:32
    >>,
    {ok, pt:pack(18001, Data)};

write (18002,[
    Errcode,
    AnimaId,
    GoodsId,
    EquipPos,
    GtypeId
]) ->
    Data = <<
        Errcode:32,
        AnimaId:8,
        GoodsId:64,
        EquipPos:8,
        GtypeId:32
    >>,
    {ok, pt:pack(18002, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


