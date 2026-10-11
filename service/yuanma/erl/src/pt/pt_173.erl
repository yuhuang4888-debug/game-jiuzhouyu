-module(pt_173).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17301, _) ->
    {ok, []};
read(17303, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Id:32, Bin2/binary>> = Bin1, 
    <<Replace:8, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, Id, Replace]};
read(17304, Bin0) ->
    <<Id:32, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, Pos]};
read(17305, Bin0) ->
    <<Id:32, Bin1/binary>> = Bin0, 
    <<FightState:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, FightState]};
read(17306, _) ->
    {ok, []};
read(17307, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<IsDouble:8, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId1:64, _Args1/binary>> = RestBin0, 
        {GoodsId1,_Args1}
        end,
    {GoodsList, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [GoodsId, IsDouble, GoodsList]};
read(17308, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<IsDouble:8, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId1:64, _Args1/binary>> = RestBin0, 
        {GoodsId1,_Args1}
        end,
    {GoodsList, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [GoodsId, IsDouble, GoodsList]};
read(17309, Bin0) ->
    <<ModuleId:16, Bin1/binary>> = Bin0, 
    <<SubModuleId:8, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<AttrId:16, _Args1/binary>> = RestBin0, 
        <<AttrValue:32, _Args2/binary>> = _Args1, 
        {{AttrId, AttrValue},_Args2}
        end,
    {Attr, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [ModuleId, SubModuleId, Attr]};
read(17310, Bin0) ->
    <<RuleId:32, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {SpecifyGlist, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [RuleId, SpecifyGlist]};
read(17311, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<CostGoodsId:64, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, Type, CostGoodsId]};
read(17312, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {Goods, Bin1} = pt:read_array(FunArray0, Bin0),

    <<Replace:8, Bin2/binary>> = Bin1, 
    <<Id:32, _Bin3/binary>> = Bin2, 
    {ok, [Goods, Replace, Id]};
read(_Cmd, _R) -> {error, no_match}.

write (17300,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(17300, Data)};

write (17301,[
    FightCount,
    EudemonsList
]) ->
    BinList_EudemonsList = [
        item_to_bin_0(EudemonsList_Item) || EudemonsList_Item <- EudemonsList
    ], 

    EudemonsList_Len = length(EudemonsList), 
    Bin_EudemonsList = list_to_binary(BinList_EudemonsList),

    Data = <<
        FightCount:8,
        EudemonsList_Len:16, Bin_EudemonsList/binary
    >>,
    {ok, pt:pack(17301, Data)};

write (17302,[
    Id,
    State,
    Score,
    EquipList,
    EquipAttr
]) ->
    BinList_EquipList = [
        item_to_bin_3(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    BinList_EquipAttr = [
        item_to_bin_4(EquipAttr_Item) || EquipAttr_Item <- EquipAttr
    ], 

    EquipAttr_Len = length(EquipAttr), 
    Bin_EquipAttr = list_to_binary(BinList_EquipAttr),

    Data = <<
        Id:32,
        State:8,
        Score:32,
        EquipList_Len:16, Bin_EquipList/binary,
        EquipAttr_Len:16, Bin_EquipAttr/binary
    >>,
    {ok, pt:pack(17302, Data)};

write (17303,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(17303, Data)};

write (17304,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(17304, Data)};

write (17305,[
    Id,
    State
]) ->
    Data = <<
        Id:32,
        State:8
    >>,
    {ok, pt:pack(17305, Data)};

write (17306,[
    FightCount
]) ->
    Data = <<
        FightCount:8
    >>,
    {ok, pt:pack(17306, Data)};

write (17307,[
    GoodsId,
    Stren,
    Exp
]) ->
    Data = <<
        GoodsId:64,
        Stren:16,
        Exp:32
    >>,
    {ok, pt:pack(17307, Data)};

write (17308,[
    GoodsId,
    Stren,
    Exp
]) ->
    Data = <<
        GoodsId:64,
        Stren:16,
        Exp:32
    >>,
    {ok, pt:pack(17308, Data)};

write (17309,[
    ModuleId,
    SubModuleId,
    CombatPower
]) ->
    Data = <<
        ModuleId:16,
        SubModuleId:8,
        CombatPower:32
    >>,
    {ok, pt:pack(17309, Data)};

write (17310,[
    Code,
    RuleId,
    SendList
]) ->
    BinList_SendList = [
        item_to_bin_5(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        Code:32,
        RuleId:32,
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(17310, Data)};

write (17311,[
    GoodsId,
    Stren,
    Exp
]) ->
    Data = <<
        GoodsId:64,
        Stren:16,
        Exp:32
    >>,
    {ok, pt:pack(17311, Data)};

write (17312,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(17312, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    State,
    Score,
    EquipList,
    EquipAttr
}) ->
    BinList_EquipList = [
        item_to_bin_1(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    BinList_EquipAttr = [
        item_to_bin_2(EquipAttr_Item) || EquipAttr_Item <- EquipAttr
    ], 

    EquipAttr_Len = length(EquipAttr), 
    Bin_EquipAttr = list_to_binary(BinList_EquipAttr),

    Data = <<
        Id:32,
        State:8,
        Score:32,
        EquipList_Len:16, Bin_EquipList/binary,
        EquipAttr_Len:16, Bin_EquipAttr/binary
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    GoodsId,
    Stren,
    Exp
}) ->
    Data = <<
        Pos:8,
        GoodsId:64,
        Stren:16,
        Exp:32
    >>,
    Data.
item_to_bin_2 ({
    AttrType,
    AttrValue
}) ->
    Data = <<
        AttrType:16,
        AttrValue:32
    >>,
    Data.
item_to_bin_3 ({
    Pos,
    GoodsId,
    Stren,
    Exp
}) ->
    Data = <<
        Pos:8,
        GoodsId:64,
        Stren:16,
        Exp:32
    >>,
    Data.
item_to_bin_4 ({
    AttrType,
    AttrValue
}) ->
    Data = <<
        AttrType:16,
        AttrValue:32
    >>,
    Data.
item_to_bin_5 ({
    GoodsId,
    GoodsTypeId
}) ->
    Data = <<
        GoodsId:64,
        GoodsTypeId:32
    >>,
    Data.
