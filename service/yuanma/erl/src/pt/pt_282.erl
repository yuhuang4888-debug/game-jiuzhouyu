-module(pt_282).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28202, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(28203, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Id:64, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Id]};
read(28204, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<Id:64, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, Id]};
read(_Cmd, _R) -> {error, no_match}.

write (28202,[
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
    {ok, pt:pack(28202, Data)};

write (28203,[
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
    {ok, pt:pack(28203, Data)};

write (28204,[
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
    {ok, pt:pack(28204, Data)};

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
