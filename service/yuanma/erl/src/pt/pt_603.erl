-module(pt_603).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60301, _) ->
    {ok, []};
read(60302, _) ->
    {ok, []};
read(60303, Bin0) ->
    <<GoodsId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(60304, _) ->
    {ok, []};
read(60306, _) ->
    {ok, []};
read(60307, _) ->
    {ok, []};
read(60308, _) ->
    {ok, []};
read(60309, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (60300,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(60300, Data)};

write (60301,[
    Stage,
    EndTime,
    Finish
]) ->
    Data = <<
        Stage:8,
        EndTime:32,
        Finish:8
    >>,
    {ok, pt:pack(60301, Data)};

write (60302,[
    Stage,
    EndTime
]) ->
    Data = <<
        Stage:8,
        EndTime:32
    >>,
    {ok, pt:pack(60302, Data)};

write (60303,[
    GoodsId,
    Count
]) ->
    Data = <<
        GoodsId:32,
        Count:8
    >>,
    {ok, pt:pack(60303, Data)};

write (60304,[
    BossHp,
    MyRank,
    MyHurt,
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_0(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        BossHp:64,
        MyRank:16,
        MyHurt:64,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(60304, Data)};

write (60305,[
    Res,
    Rank,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Res:8,
        Rank:16,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(60305, Data)};

write (60306,[
    BossHp,
    MyRank,
    MyHurt,
    KillerId,
    RoleList
]) ->
    BinList_RoleList = [
        item_to_bin_1(RoleList_Item) || RoleList_Item <- RoleList
    ], 

    RoleList_Len = length(RoleList), 
    Bin_RoleList = list_to_binary(BinList_RoleList),

    Data = <<
        BossHp:64,
        MyRank:16,
        MyHurt:64,
        KillerId:64,
        RoleList_Len:16, Bin_RoleList/binary
    >>,
    {ok, pt:pack(60306, Data)};





write (60309,[
    NextHurtStep,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        NextHurtStep:64,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(60309, Data)};

write (60310,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(60310, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Name,
    HurtValue
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Bin_Name/binary,
        HurtValue:64
    >>,
    Data.
item_to_bin_1 ({
    RoleId,
    Name,
    Career,
    Sex,
    Turn,
    Picture,
    Power,
    HurtValue
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Picture = pt:write_string(Picture), 

    Data = <<
        RoleId:64,
        Bin_Name/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Bin_Picture/binary,
        Power:32,
        HurtValue:64
    >>,
    Data.
