-module(pt_203).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(20301, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(20302, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [Type, GoodsId]};
read(20303, _) ->
    {ok, []};
read(20304, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (20300,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(20300, Data)};

write (20301,[
    Code,
    Scene,
    X,
    Y
]) ->
    Data = <<
        Code:32,
        Scene:32,
        X:32,
        Y:32
    >>,
    {ok, pt:pack(20301, Data)};

write (20302,[
    Code,
    Type,
    IsRare,
    Reward,
    GoodsList
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Bin_GoodsList = pt:write_object_list(GoodsList), 

    Data = <<
        Code:32,
        Type:8,
        IsRare:8,
        Bin_Reward/binary,
        Bin_GoodsList/binary
    >>,
    {ok, pt:pack(20302, Data)};

write (20303,[
    LogList
]) ->
    BinList_LogList = [
        item_to_bin_0(LogList_Item) || LogList_Item <- LogList
    ], 

    LogList_Len = length(LogList), 
    Bin_LogList = list_to_binary(BinList_LogList),

    Data = <<
        LogList_Len:16, Bin_LogList/binary
    >>,
    {ok, pt:pack(20303, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ServerNum,
    RoleId,
    Name,
    RewardList
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ServerNum:32,
        RoleId:64,
        Bin_Name/binary,
        Bin_RewardList/binary
    >>,
    Data.
