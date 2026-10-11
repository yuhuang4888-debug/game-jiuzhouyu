-module(pt_440).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(44000, _) ->
    {ok, []};
read(44001, Bin0) ->
    <<GodId:32, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(44002, Bin0) ->
    <<GodId:32, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(44003, Bin0) ->
    <<GodId:32, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(44004, Bin0) ->
    <<GodId:32, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(44005, Bin0) ->
    <<GodId:32, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(44006, Bin0) ->
    <<Pos:8, Bin1/binary>> = Bin0, 
    <<GodId:32, _Bin2/binary>> = Bin1, 
    {ok, [Pos, GodId]};
read(44010, _) ->
    {ok, []};
read(44011, _) ->
    {ok, []};
read(44012, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, Id]};
read(44013, Bin0) ->
    <<Id:32, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, Pos]};
read(44014, Bin0) ->
    <<RuleId:32, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [RuleId, GoodsId]};
read(44015, Bin0) ->
    <<GodId:32, _Bin1/binary>> = Bin0, 
    {ok, [GodId]};
read(44016, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<RuleId:32, _Args1/binary>> = RestBin0, 
        <<Count:8, _Args2/binary>> = _Args1, 
        {{RuleId, Count},_Args2}
        end,
    {ComposeList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [ComposeList]};
read(44017, Bin0) ->
    <<GodType:8, _Bin1/binary>> = Bin0, 
    {ok, [GodType]};
read(44018, Bin0) ->
    <<GodType:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsTypeId:32, _Args1/binary>> = RestBin0, 
        <<GoodsNum:16, _Args2/binary>> = _Args1, 
        {{GoodsTypeId, GoodsNum},_Args2}
        end,
    {GoodsList, Bin2} = pt:read_array(FunArray0, Bin1),

    <<IsDivide:8, _Bin3/binary>> = Bin2, 
    {ok, [GodType, GoodsList, IsDivide]};
read(_Cmd, _R) -> {error, no_match}.

write (44000,[
    GodList
]) ->
    BinList_GodList = [
        item_to_bin_0(GodList_Item) || GodList_Item <- GodList
    ], 

    GodList_Len = length(GodList), 
    Bin_GodList = list_to_binary(BinList_GodList),

    Data = <<
        GodList_Len:16, Bin_GodList/binary
    >>,
    {ok, pt:pack(44000, Data)};

write (44001,[
    IsBattle,
    GodId,
    Lv,
    Exp,
    Grade,
    Star,
    Power,
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_2(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        IsBattle:8,
        GodId:32,
        Lv:16,
        Exp:32,
        Grade:16,
        Star:32,
        Power:64,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(44001, Data)};

write (44002,[
    Errcode,
    Power,
    GodId
]) ->
    Data = <<
        Errcode:32,
        Power:64,
        GodId:32
    >>,
    {ok, pt:pack(44002, Data)};

write (44003,[
    Errcode,
    GodId,
    Lv,
    Exp,
    Power
]) ->
    Data = <<
        Errcode:32,
        GodId:32,
        Lv:16,
        Exp:32,
        Power:64
    >>,
    {ok, pt:pack(44003, Data)};

write (44004,[
    Errcode,
    GodId,
    Grade,
    Power
]) ->
    Data = <<
        Errcode:32,
        GodId:32,
        Grade:16,
        Power:64
    >>,
    {ok, pt:pack(44004, Data)};

write (44005,[
    Errcode,
    GodId,
    Star,
    Power
]) ->
    Data = <<
        Errcode:32,
        GodId:32,
        Star:32,
        Power:64
    >>,
    {ok, pt:pack(44005, Data)};

write (44006,[
    Errcode,
    GodId
]) ->
    Data = <<
        Errcode:32,
        GodId:32
    >>,
    {ok, pt:pack(44006, Data)};

write (44010,[
    SwitchCd,
    EndTime
]) ->
    Data = <<
        SwitchCd:32,
        EndTime:32
    >>,
    {ok, pt:pack(44010, Data)};

write (44011,[
    Errcode,
    GodId
]) ->
    Data = <<
        Errcode:32,
        GodId:32
    >>,
    {ok, pt:pack(44011, Data)};

write (44012,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(44012, Data)};

write (44013,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(44013, Data)};

write (44014,[
    Code,
    RuleId,
    GoodsId
]) ->
    Data = <<
        Code:32,
        RuleId:32,
        GoodsId:64
    >>,
    {ok, pt:pack(44014, Data)};

write (44015,[
    GoodId,
    Power
]) ->
    Data = <<
        GoodId:32,
        Power:64
    >>,
    {ok, pt:pack(44015, Data)};

write (44016,[
    Code,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_3(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Code:32,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(44016, Data)};

write (44017,[
    GodType,
    CurrentLv,
    CurrentExp
]) ->
    Data = <<
        GodType:8,
        CurrentLv:16,
        CurrentExp:32
    >>,
    {ok, pt:pack(44017, Data)};

write (44018,[
    Code,
    Args,
    GodType,
    CurrentLv,
    CurrentExp,
    IsDivide
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary,
        GodType:8,
        CurrentLv:16,
        CurrentExp:32,
        IsDivide:8
    >>,
    {ok, pt:pack(44018, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    IsBattle,
    GodId,
    Lv,
    Exp,
    Grade,
    Star,
    Power,
    EquipList
}) ->
    BinList_EquipList = [
        item_to_bin_1(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        IsBattle:8,
        GodId:32,
        Lv:16,
        Exp:32,
        Grade:16,
        Star:32,
        Power:64,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    GoodsId
}) ->
    Data = <<
        Pos:8,
        GoodsId:64
    >>,
    Data.
item_to_bin_2 ({
    Pos,
    GoodsId
}) ->
    Data = <<
        Pos:8,
        GoodsId:64
    >>,
    Data.
item_to_bin_3 ({
    GoodsType,
    GoodsTypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:8,
        GoodsTypeId:64,
        GoodsNum:8
    >>,
    Data.
