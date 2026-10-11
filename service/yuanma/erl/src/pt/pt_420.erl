-module(pt_420).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42001, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(42002, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Lv:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Lv]};
read(42003, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Id:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Id]};
read(42004, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (42000,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(42000, Data)};

write (42001,[
    Type,
    CurLv,
    BuyTime,
    GetTime,
    LoginDays,
    Rewards
]) ->
    BinList_Rewards = [
        item_to_bin_0(Rewards_Item) || Rewards_Item <- Rewards
    ], 

    Rewards_Len = length(Rewards), 
    Bin_Rewards = list_to_binary(BinList_Rewards),

    Data = <<
        Type:8,
        CurLv:16,
        BuyTime:32,
        GetTime:32,
        LoginDays:16,
        Rewards_Len:16, Bin_Rewards/binary
    >>,
    {ok, pt:pack(42001, Data)};

write (42002,[
    Type,
    Lv
]) ->
    Data = <<
        Type:8,
        Lv:16
    >>,
    {ok, pt:pack(42002, Data)};

write (42003,[
    Type,
    Id,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Type:8,
        Id:8,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(42003, Data)};

write (42004,[
    OpenList
]) ->
    BinList_OpenList = [
        item_to_bin_1(OpenList_Item) || OpenList_Item <- OpenList
    ], 

    OpenList_Len = length(OpenList), 
    Bin_OpenList = list_to_binary(BinList_OpenList),

    Data = <<
        OpenList_Len:16, Bin_OpenList/binary
    >>,
    {ok, pt:pack(42004, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    GotLv
}) ->
    Data = <<
        Id:8,
        GotLv:16
    >>,
    Data.
item_to_bin_1 ({
    Type,
    ShowId,
    State,
    RefreshTime
}) ->
    Data = <<
        Type:8,
        ShowId:16,
        State:8,
        RefreshTime:32
    >>,
    Data.
