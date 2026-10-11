-module(pt_412).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41200, _) ->
    {ok, []};
read(41201, _) ->
    {ok, []};
read(41202, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41203, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41204, _) ->
    {ok, []};
read(41208, Bin0) ->
    <<Partnerid:32, _Bin1/binary>> = Bin0, 
    {ok, [Partnerid]};
read(41209, Bin0) ->
    <<TenRecruit:8, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [TenRecruit, Type]};
read(41210, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<Opra:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, Opra]};
read(41211, _) ->
    {ok, []};
read(41212, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<Goodsid:32, Bin2/binary>> = Bin1, 
    <<Num:8, _Bin3/binary>> = Bin2, 
    {ok, [Id, Goodsid, Num]};
read(41214, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41215, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41216, Bin0) ->
    <<Op:8, Bin1/binary>> = Bin0, 
    <<Id:64, _Bin2/binary>> = Bin1, 
    {ok, [Op, Id]};
read(41218, _) ->
    {ok, []};
read(41219, Bin0) ->
    <<SrcPos:8, Bin1/binary>> = Bin0, 
    <<DstPos:8, _Bin2/binary>> = Bin1, 
    {ok, [SrcPos, DstPos]};
read(41220, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41221, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<AttrType:8, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Type:8, _Args1/binary>> = RestBin0, 
        <<GoodsId:32, _Args2/binary>> = _Args1, 
        <<Num:16, _Args3/binary>> = _Args2, 
        {{Type, GoodsId, Num},_Args3}
        end,
    {Goods, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [Id, AttrType, Goods]};
read(41222, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<Color:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, Color]};
read(41223, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<Goodsid:32, Bin2/binary>> = Bin1, 
    <<Pos:8, Bin3/binary>> = Bin2, 
    <<Op:8, _Bin4/binary>> = Bin3, 
    {ok, [Id, Goodsid, Pos, Op]};
read(41224, _) ->
    {ok, []};
read(41225, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Id:64, _Args1/binary>> = RestBin0, 
        {Id,_Args1}
        end,
    {IdList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [IdList]};
read(41226, Bin0) ->
    <<Partnerid:32, _Bin1/binary>> = Bin0, 
    {ok, [Partnerid]};
read(41227, Bin0) ->
    <<Src:8, Bin1/binary>> = Bin0, 
    <<Dst:8, _Bin2/binary>> = Bin1, 
    {ok, [Src, Dst]};
read(41228, _) ->
    {ok, []};
read(41230, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Id:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, Id]};
read(41231, _) ->
    {ok, []};
read(41240, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (41200,[
    CoinEt,
    CoinTms,
    GoldEt,
    GoldTms
]) ->
    Data = <<
        CoinEt:32,
        CoinTms:8,
        GoldEt:32,
        GoldTms:8
    >>,
    {ok, pt:pack(41200, Data)};

write (41201,[
    Partners
]) ->
    BinList_Partners = [
        item_to_bin_0(Partners_Item) || Partners_Item <- Partners
    ], 

    Partners_Len = length(Partners), 
    Bin_Partners = list_to_binary(BinList_Partners),

    Data = <<
        Partners_Len:16, Bin_Partners/binary
    >>,
    {ok, pt:pack(41201, Data)};

write (41202,[
    Code,
    Id,
    Partnerid,
    Lv,
    Exp,
    Maxexp,
    BreakSt,
    BaseAttr,
    Skill,
    Weapon,
    Combat,
    Prodigy
]) ->
    BinList_BaseAttr = [
        item_to_bin_1(BaseAttr_Item) || BaseAttr_Item <- BaseAttr
    ], 

    BaseAttr_Len = length(BaseAttr), 
    Bin_BaseAttr = list_to_binary(BinList_BaseAttr),

    BinList_Skill = [
        item_to_bin_2(Skill_Item) || Skill_Item <- Skill
    ], 

    Skill_Len = length(Skill), 
    Bin_Skill = list_to_binary(BinList_Skill),

    Data = <<
        Code:32,
        Id:64,
        Partnerid:32,
        Lv:16,
        Exp:32,
        Maxexp:32,
        BreakSt:8,
        BaseAttr_Len:16, Bin_BaseAttr/binary,
        Skill_Len:16, Bin_Skill/binary,
        Weapon:32,
        Combat:32,
        Prodigy:8
    >>,
    {ok, pt:pack(41202, Data)};

write (41203,[
    Code,
    Id,
    Attr
]) ->
    Bin_Attr = pt:write_attr_list(Attr), 

    Data = <<
        Code:32,
        Id:64,
        Bin_Attr/binary
    >>,
    {ok, pt:pack(41203, Data)};

write (41204,[
    Id,
    Combat,
    Prodigy
]) ->
    Data = <<
        Id:64,
        Combat:32,
        Prodigy:8
    >>,
    {ok, pt:pack(41204, Data)};

write (41208,[
    Code,
    Id,
    Partnerid,
    Lv,
    State,
    Pos,
    Combat,
    Prodigy,
    Weapon
]) ->
    Data = <<
        Code:32,
        Id:64,
        Partnerid:32,
        Lv:16,
        State:8,
        Pos:8,
        Combat:32,
        Prodigy:8,
        Weapon:32
    >>,
    {ok, pt:pack(41208, Data)};

write (41209,[
    Code,
    TenRecruit,
    Type,
    PartnerList,
    GoodsList
]) ->
    BinList_PartnerList = [
        item_to_bin_3(PartnerList_Item) || PartnerList_Item <- PartnerList
    ], 

    PartnerList_Len = length(PartnerList), 
    Bin_PartnerList = list_to_binary(BinList_PartnerList),

    BinList_GoodsList = [
        item_to_bin_4(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Code:32,
        TenRecruit:8,
        Type:8,
        PartnerList_Len:16, Bin_PartnerList/binary,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(41209, Data)};

write (41210,[
    Code,
    Pos
]) ->
    Data = <<
        Code:32,
        Pos:8
    >>,
    {ok, pt:pack(41210, Data)};

write (41211,[
    Goods
]) ->
    BinList_Goods = [
        item_to_bin_5(Goods_Item) || Goods_Item <- Goods
    ], 

    Goods_Len = length(Goods), 
    Bin_Goods = list_to_binary(BinList_Goods),

    Data = <<
        Goods_Len:16, Bin_Goods/binary
    >>,
    {ok, pt:pack(41211, Data)};

write (41212,[
    Code,
    Id,
    Lv,
    Exp,
    AddExp
]) ->
    Data = <<
        Code:32,
        Id:64,
        Lv:16,
        Exp:32,
        AddExp:32
    >>,
    {ok, pt:pack(41212, Data)};

write (41214,[
    Code,
    Id,
    BreakSt,
    BaseAttr
]) ->
    BinList_BaseAttr = [
        item_to_bin_6(BaseAttr_Item) || BaseAttr_Item <- BaseAttr
    ], 

    BaseAttr_Len = length(BaseAttr), 
    Bin_BaseAttr = list_to_binary(BinList_BaseAttr),

    Data = <<
        Code:32,
        Id:64,
        BreakSt:8,
        BaseAttr_Len:16, Bin_BaseAttr/binary
    >>,
    {ok, pt:pack(41214, Data)};

write (41215,[
    Code,
    Partners
]) ->
    BinList_Partners = [
        item_to_bin_7(Partners_Item) || Partners_Item <- Partners
    ], 

    Partners_Len = length(Partners), 
    Bin_Partners = list_to_binary(BinList_Partners),

    Data = <<
        Code:32,
        Partners_Len:16, Bin_Partners/binary
    >>,
    {ok, pt:pack(41215, Data)};

write (41216,[
    Id,
    Combat,
    Prodigy
]) ->
    Data = <<
        Id:64,
        Combat:32,
        Prodigy:8
    >>,
    {ok, pt:pack(41216, Data)};

write (41218,[
    Embattle
]) ->
    BinList_Embattle = [
        item_to_bin_10(Embattle_Item) || Embattle_Item <- Embattle
    ], 

    Embattle_Len = length(Embattle), 
    Bin_Embattle = list_to_binary(BinList_Embattle),

    Data = <<
        Embattle_Len:16, Bin_Embattle/binary
    >>,
    {ok, pt:pack(41218, Data)};

write (41219,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41219, Data)};

write (41220,[
    Code,
    Num
]) ->
    Data = <<
        Code:32,
        Num:16
    >>,
    {ok, pt:pack(41220, Data)};

write (41221,[
    Code,
    Id,
    Combat,
    Add,
    AttrType,
    Curval
]) ->
    BinList_Add = [
        item_to_bin_11(Add_Item) || Add_Item <- Add
    ], 

    Add_Len = length(Add), 
    Bin_Add = list_to_binary(BinList_Add),

    Data = <<
        Code:32,
        Id:64,
        Combat:32,
        Add_Len:16, Bin_Add/binary,
        AttrType:8,
        Curval:16
    >>,
    {ok, pt:pack(41221, Data)};

write (41222,[
    Code,
    SkList
]) ->
    BinList_SkList = [
        item_to_bin_12(SkList_Item) || SkList_Item <- SkList
    ], 

    SkList_Len = length(SkList), 
    Bin_SkList = list_to_binary(BinList_SkList),

    Data = <<
        Code:32,
        SkList_Len:16, Bin_SkList/binary
    >>,
    {ok, pt:pack(41222, Data)};

write (41223,[
    Code,
    Id,
    SkBook,
    SkId,
    SkLv,
    Pos,
    Combat
]) ->
    Data = <<
        Code:32,
        Id:64,
        SkBook:32,
        SkId:32,
        SkLv:8,
        Pos:8,
        Combat:32
    >>,
    {ok, pt:pack(41223, Data)};

write (41224,[
    List
]) ->
    BinList_List = [
        item_to_bin_13(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41224, Data)};

write (41225,[
    Code,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_14(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Code:32,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(41225, Data)};

write (41226,[
    Code,
    Id,
    Partnerid,
    Lv,
    State,
    Pos,
    Combat,
    Prodigy,
    Weapon
]) ->
    Data = <<
        Code:32,
        Id:64,
        Partnerid:32,
        Lv:16,
        State:8,
        Pos:8,
        Combat:32,
        Prodigy:8,
        Weapon:32
    >>,
    {ok, pt:pack(41226, Data)};

write (41227,[
    Code,
    Battlepos
]) ->
    BinList_Battlepos = [
        item_to_bin_15(Battlepos_Item) || Battlepos_Item <- Battlepos
    ], 

    Battlepos_Len = length(Battlepos), 
    Bin_Battlepos = list_to_binary(BinList_Battlepos),

    Data = <<
        Code:32,
        Battlepos_Len:16, Bin_Battlepos/binary
    >>,
    {ok, pt:pack(41227, Data)};

write (41228,[
    TypeId
]) ->
    Data = <<
        TypeId:64
    >>,
    {ok, pt:pack(41228, Data)};

write (41230,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(41230, Data)};

write (41231,[
    Battlepartner
]) ->
    BinList_Battlepartner = [
        item_to_bin_16(Battlepartner_Item) || Battlepartner_Item <- Battlepartner
    ], 

    Battlepartner_Len = length(Battlepartner), 
    Bin_Battlepartner = list_to_binary(BinList_Battlepartner),

    Data = <<
        Battlepartner_Len:16, Bin_Battlepartner/binary
    >>,
    {ok, pt:pack(41231, Data)};

write (41240,[
    MaxTimes,
    Times
]) ->
    Data = <<
        MaxTimes:8,
        Times:8
    >>,
    {ok, pt:pack(41240, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Partnerid,
    Lv,
    State,
    Pos,
    Combat,
    Prodigy,
    Weapon
}) ->
    Data = <<
        Id:64,
        Partnerid:32,
        Lv:16,
        State:8,
        Pos:8,
        Combat:32,
        Prodigy:8,
        Weapon:32
    >>,
    Data.
item_to_bin_1 ({
    Type,
    Curval,
    Uppval,
    Quality
}) ->
    Data = <<
        Type:8,
        Curval:16,
        Uppval:16,
        Quality:8
    >>,
    Data.
item_to_bin_2 ({
    SkBook,
    SkId,
    SkLv,
    SkPos
}) ->
    Data = <<
        SkBook:32,
        SkId:32,
        SkLv:8,
        SkPos:8
    >>,
    Data.
item_to_bin_3 ({
    Id,
    Partnerid,
    Lv,
    State,
    Pos,
    Combat,
    Prodigy,
    Weapon
}) ->
    Data = <<
        Id:64,
        Partnerid:32,
        Lv:16,
        State:8,
        Pos:8,
        Combat:32,
        Prodigy:8,
        Weapon:32
    >>,
    Data.
item_to_bin_4 ({
    GoodsId,
    Num
}) ->
    Data = <<
        GoodsId:32,
        Num:8
    >>,
    Data.
item_to_bin_5 ({
    Id,
    Num
}) ->
    Data = <<
        Id:64,
        Num:32
    >>,
    Data.
item_to_bin_6 ({
    Type,
    Curval,
    Uppval,
    Quality
}) ->
    Data = <<
        Type:8,
        Curval:16,
        Uppval:16,
        Quality:8
    >>,
    Data.
item_to_bin_7 ({
    Wash,
    Combat,
    Prodigy,
    BaseAttr,
    Skill
}) ->
    BinList_BaseAttr = [
        item_to_bin_8(BaseAttr_Item) || BaseAttr_Item <- BaseAttr
    ], 

    BaseAttr_Len = length(BaseAttr), 
    Bin_BaseAttr = list_to_binary(BinList_BaseAttr),

    BinList_Skill = [
        item_to_bin_9(Skill_Item) || Skill_Item <- Skill
    ], 

    Skill_Len = length(Skill), 
    Bin_Skill = list_to_binary(BinList_Skill),

    Data = <<
        Wash:8,
        Combat:32,
        Prodigy:8,
        BaseAttr_Len:16, Bin_BaseAttr/binary,
        Skill_Len:16, Bin_Skill/binary
    >>,
    Data.
item_to_bin_8 ({
    Type,
    Curval,
    Uppval,
    Quality
}) ->
    Data = <<
        Type:8,
        Curval:16,
        Uppval:16,
        Quality:8
    >>,
    Data.
item_to_bin_9 ({
    SkBook,
    SkId,
    SkLv,
    SkPos
}) ->
    Data = <<
        SkBook:32,
        SkId:32,
        SkLv:8,
        SkPos:8
    >>,
    Data.
item_to_bin_10 ({
    Pos,
    Type,
    Id,
    Partnerid,
    Lv
}) ->
    Data = <<
        Pos:8,
        Type:8,
        Id:64,
        Partnerid:32,
        Lv:16
    >>,
    Data.
item_to_bin_11 (
    Value
) ->
    Data = <<
        Value:8
    >>,
    Data.
item_to_bin_12 ({
    Id,
    Typeid,
    Num,
    Color
}) ->
    Data = <<
        Id:64,
        Typeid:32,
        Num:16,
        Color:8
    >>,
    Data.
item_to_bin_13 ({
    Partnerid,
    Weapon
}) ->
    Data = <<
        Partnerid:32,
        Weapon:32
    >>,
    Data.
item_to_bin_14 ({
    GoodsId,
    Num
}) ->
    Data = <<
        GoodsId:32,
        Num:8
    >>,
    Data.
item_to_bin_15 ({
    Id,
    Pos
}) ->
    Data = <<
        Id:64,
        Pos:8
    >>,
    Data.
item_to_bin_16 ({
    Id,
    Partnerid,
    BreakSt,
    BaseAttr,
    Skill
}) ->
    BinList_BaseAttr = [
        item_to_bin_17(BaseAttr_Item) || BaseAttr_Item <- BaseAttr
    ], 

    BaseAttr_Len = length(BaseAttr), 
    Bin_BaseAttr = list_to_binary(BinList_BaseAttr),

    BinList_Skill = [
        item_to_bin_18(Skill_Item) || Skill_Item <- Skill
    ], 

    Skill_Len = length(Skill), 
    Bin_Skill = list_to_binary(BinList_Skill),

    Data = <<
        Id:64,
        Partnerid:32,
        BreakSt:8,
        BaseAttr_Len:16, Bin_BaseAttr/binary,
        Skill_Len:16, Bin_Skill/binary
    >>,
    Data.
item_to_bin_17 ({
    Type,
    Curval,
    Uppval,
    Quality
}) ->
    Data = <<
        Type:8,
        Curval:16,
        Uppval:16,
        Quality:8
    >>,
    Data.
item_to_bin_18 ({
    SkBook,
    SkId,
    SkLv,
    SkPos
}) ->
    Data = <<
        SkBook:32,
        SkId:32,
        SkLv:8,
        SkPos:8
    >>,
    Data.
