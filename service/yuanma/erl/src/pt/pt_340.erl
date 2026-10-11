-module(pt_340).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(34001, _) ->
    {ok, []};
read(34002, _) ->
    {ok, []};
read(34003, _) ->
    {ok, []};
read(34004, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<RewardId:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, RewardId]};
read(34005, _) ->
    {ok, []};
read(34006, _) ->
    {ok, []};
read(34007, Bin0) ->
    <<Lv:16, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [Lv, Pos]};
read(34008, Bin0) ->
    <<Lv:16, _Bin1/binary>> = Bin0, 
    {ok, [Lv]};
read(34009, Bin0) ->
    <<Lv:16, _Bin1/binary>> = Bin0, 
    {ok, [Lv]};
read(34010, _) ->
    {ok, []};
read(34011, Bin0) ->
    <<InviteeId:64, _Bin1/binary>> = Bin0, 
    {ok, [InviteeId]};
read(34012, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(_Cmd, _R) -> {error, no_match}.

write (34000,[
    Pt,
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Pt:16,
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(34000, Data)};

write (34001,[
    GetStatus,
    RecoverTime,
    DailyCount,
    TotalCount,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_0(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        GetStatus:8,
        RecoverTime:32,
        DailyCount:8,
        TotalCount:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(34001, Data)};

write (34002,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(34002, Data)};

write (34003,[
    DailyCount
]) ->
    Data = <<
        DailyCount:8
    >>,
    {ok, pt:pack(34003, Data)};

write (34004,[
    Type,
    RewardId
]) ->
    Data = <<
        Type:8,
        RewardId:8
    >>,
    {ok, pt:pack(34004, Data)};

write (34005,[
    Count,
    RewardList,
    PosList
]) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_PosList = [
        item_to_bin_2(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        Count:16,
        RewardList_Len:16, Bin_RewardList/binary,
        PosList_Len:16, Bin_PosList/binary
    >>,
    {ok, pt:pack(34005, Data)};

write (34006,[
    PosList
]) ->
    BinList_PosList = [
        item_to_bin_3(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        PosList_Len:16, Bin_PosList/binary
    >>,
    {ok, pt:pack(34006, Data)};

write (34007,[
    Lv,
    Pos
]) ->
    Data = <<
        Lv:16,
        Pos:8
    >>,
    {ok, pt:pack(34007, Data)};

write (34008,[
    Lv,
    Count,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Lv:16,
        Count:16,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(34008, Data)};

write (34009,[
    Lv,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Lv:16,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(34009, Data)};

write (34010,[
    RedPacketList
]) ->
    BinList_RedPacketList = [
        item_to_bin_4(RedPacketList_Item) || RedPacketList_Item <- RedPacketList
    ], 

    RedPacketList_Len = length(RedPacketList), 
    Bin_RedPacketList = list_to_binary(BinList_RedPacketList),

    Data = <<
        RedPacketList_Len:16, Bin_RedPacketList/binary
    >>,
    {ok, pt:pack(34010, Data)};

write (34011,[
    InviteeId,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        InviteeId:64,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(34011, Data)};

write (34012,[
    Type,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_5(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Type:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(34012, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RewardId,
    Status
}) ->
    Data = <<
        RewardId:8,
        Status:8
    >>,
    Data.
item_to_bin_1 ({
    RewardId,
    Status
}) ->
    Data = <<
        RewardId:8,
        Status:8
    >>,
    Data.
item_to_bin_2 ({
    InviteeId,
    Pos,
    Name,
    Lv,
    Career,
    Status
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        InviteeId:64,
        Pos:8,
        Bin_Name/binary,
        Lv:16,
        Career:8,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    InviteeId,
    Pos,
    Name,
    Lv,
    Career,
    Status
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        InviteeId:64,
        Pos:8,
        Bin_Name/binary,
        Lv:16,
        Career:8,
        Status:8
    >>,
    Data.
item_to_bin_4 ({
    InviteeId,
    Name,
    LeftGold,
    LastGetGold
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        InviteeId:64,
        Bin_Name/binary,
        LeftGold:32,
        LastGetGold:32
    >>,
    Data.
item_to_bin_5 ({
    RewardId,
    Status
}) ->
    Data = <<
        RewardId:8,
        Status:8
    >>,
    Data.
