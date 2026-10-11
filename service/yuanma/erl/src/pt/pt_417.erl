-module(pt_417).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41700, _) ->
    {ok, []};
read(41701, Bin0) ->
    <<Lv:16, _Bin1/binary>> = Bin0, 
    {ok, [Lv]};
read(41702, Bin0) ->
    <<VersionCode:32, _Bin1/binary>> = Bin0, 
    {ok, [VersionCode]};
read(41703, _) ->
    {ok, []};
read(41704, Bin0) ->
    <<Day:8, Bin1/binary>> = Bin0, 
    <<Retroactive:8, _Bin2/binary>> = Bin1, 
    {ok, [Day, Retroactive]};
read(41705, Bin0) ->
    <<Day:8, _Bin1/binary>> = Bin0, 
    {ok, [Day]};
read(41706, Bin0) ->
    <<VersionCode:32, _Bin1/binary>> = Bin0, 
    {ok, [VersionCode]};
read(41707, _) ->
    {ok, []};
read(41708, _) ->
    {ok, []};
read(41710, _) ->
    {ok, []};
read(41711, _) ->
    {ok, []};
read(41712, _) ->
    {ok, []};
read(41713, _) ->
    {ok, []};
read(41714, _) ->
    {ok, []};
read(41715, _) ->
    {ok, []};
read(41716, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41718, Bin0) ->
    {Name, Bin1} = pt:read_string(Bin0), 
    <<Number:64, Bin2/binary>> = Bin1, 
    <<Type:8, _Bin3/binary>> = Bin2, 
    {ok, [Name, Number, Type]};
read(41719, Bin0) ->
    <<Opr:8, _Bin1/binary>> = Bin0, 
    {ok, [Opr]};
read(41720, _) ->
    {ok, []};
read(41722, Bin0) ->
    <<TaskId:16, _Bin1/binary>> = Bin0, 
    {ok, [TaskId]};
read(41723, _) ->
    {ok, []};
read(41724, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (41700,[
    GiftbagState
]) ->
    BinList_GiftbagState = [
        item_to_bin_0(GiftbagState_Item) || GiftbagState_Item <- GiftbagState
    ], 

    GiftbagState_Len = length(GiftbagState), 
    Bin_GiftbagState = list_to_binary(BinList_GiftbagState),

    Data = <<
        GiftbagState_Len:16, Bin_GiftbagState/binary
    >>,
    {ok, pt:pack(41700, Data)};

write (41701,[
    Lv,
    Code,
    Rewads
]) ->
    Bin_Rewads = pt:write_object_list(Rewads), 

    Data = <<
        Lv:16,
        Code:32,
        Bin_Rewads/binary
    >>,
    {ok, pt:pack(41701, Data)};

write (41702,[
    Res,
    VersionCode
]) ->
    Data = <<
        Res:32,
        VersionCode:32
    >>,
    {ok, pt:pack(41702, Data)};

write (41703,[
    TotalDays,
    TotalType,
    TotalState,
    AccState,
    CheckType,
    RetroTimes,
    DaysFresh,
    RemainTimes,
    CheckDay
]) ->
    BinList_TotalState = [
        item_to_bin_1(TotalState_Item) || TotalState_Item <- TotalState
    ], 

    TotalState_Len = length(TotalState), 
    Bin_TotalState = list_to_binary(BinList_TotalState),

    BinList_AccState = [
        item_to_bin_2(AccState_Item) || AccState_Item <- AccState
    ], 

    AccState_Len = length(AccState), 
    Bin_AccState = list_to_binary(BinList_AccState),

    Data = <<
        TotalDays:8,
        TotalType:16,
        TotalState_Len:16, Bin_TotalState/binary,
        AccState_Len:16, Bin_AccState/binary,
        CheckType:16,
        RetroTimes:8,
        DaysFresh:8,
        RemainTimes:8,
        CheckDay:8
    >>,
    {ok, pt:pack(41703, Data)};

write (41704,[
    Code,
    Rewads,
    ExtraRewads
]) ->
    BinList_Rewads = [
        item_to_bin_3(Rewads_Item) || Rewads_Item <- Rewads
    ], 

    Rewads_Len = length(Rewads), 
    Bin_Rewads = list_to_binary(BinList_Rewads),

    BinList_ExtraRewads = [
        item_to_bin_4(ExtraRewads_Item) || ExtraRewads_Item <- ExtraRewads
    ], 

    ExtraRewads_Len = length(ExtraRewads), 
    Bin_ExtraRewads = list_to_binary(BinList_ExtraRewads),

    Data = <<
        Code:32,
        Rewads_Len:16, Bin_Rewads/binary,
        ExtraRewads_Len:16, Bin_ExtraRewads/binary
    >>,
    {ok, pt:pack(41704, Data)};

write (41705,[
    Code,
    Rewads
]) ->
    BinList_Rewads = [
        item_to_bin_5(Rewads_Item) || Rewads_Item <- Rewads
    ], 

    Rewads_Len = length(Rewads), 
    Bin_Rewads = list_to_binary(BinList_Rewads),

    Data = <<
        Code:32,
        Rewads_Len:16, Bin_Rewads/binary
    >>,
    {ok, pt:pack(41705, Data)};

write (41706,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41706, Data)};

write (41707,[
    Code,
    Rewads
]) ->
    Bin_Rewads = pt:write_object_list(Rewads), 

    Data = <<
        Code:32,
        Bin_Rewads/binary
    >>,
    {ok, pt:pack(41707, Data)};

write (41708,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41708, Data)};

write (41710,[
    Times,
    Status,
    NextTime,
    Rewads
]) ->
    Bin_Rewads = pt:write_object_list(Rewads), 

    Data = <<
        Times:16,
        Status:8,
        NextTime:32,
        Bin_Rewads/binary
    >>,
    {ok, pt:pack(41710, Data)};

write (41711,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41711, Data)};

write (41712,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41712, Data)};

write (41713,[
    Code,
    State
]) ->
    Data = <<
        Code:32,
        State:8
    >>,
    {ok, pt:pack(41713, Data)};

write (41714,[
    Code,
    State
]) ->
    Data = <<
        Code:32,
        State:8
    >>,
    {ok, pt:pack(41714, Data)};

write (41715,[
    Time,
    LoginTime,
    List
]) ->
    BinList_List = [
        item_to_bin_6(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Time:16,
        LoginTime:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41715, Data)};

write (41716,[
    Code,
    SendList
]) ->
    BinList_SendList = [
        item_to_bin_7(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        Code:32,
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(41716, Data)};

write (41717,[
    Lv,
    RemainNum
]) ->
    Data = <<
        Lv:16,
        RemainNum:32
    >>,
    {ok, pt:pack(41717, Data)};

write (41718,[
    Type,
    Code,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Type:8,
        Code:32,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(41718, Data)};

write (41719,[
    Code,
    Opr,
    GiftSt,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Code:32,
        Opr:8,
        GiftSt:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(41719, Data)};

write (41720,[
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_8(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(41720, Data)};

write (41721,[
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_9(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(41721, Data)};

write (41722,[
    Errcode,
    TaskId,
    Status
]) ->
    Data = <<
        Errcode:32,
        TaskId:16,
        Status:8
    >>,
    {ok, pt:pack(41722, Data)};

write (41723,[
    Round,
    Times,
    Combat,
    NextCombat,
    List
]) ->
    BinList_List = [
        item_to_bin_10(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Round:8,
        Times:8,
        Combat:64,
        NextCombat:64,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41723, Data)};

write (41724,[
    Code,
    Round,
    Times,
    RewardId,
    NextCombat
]) ->
    Data = <<
        Code:32,
        Round:8,
        Times:8,
        RewardId:16,
        NextCombat:64
    >>,
    {ok, pt:pack(41724, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Lv,
    Received,
    EndTime,
    RemainNum
}) ->
    Data = <<
        Lv:16,
        Received:8,
        EndTime:64,
        RemainNum:32
    >>,
    Data.
item_to_bin_1 ({
    Sum,
    Receive
}) ->
    Data = <<
        Sum:32,
        Receive:8
    >>,
    Data.
item_to_bin_2 ({
    CheckDay,
    Receive
}) ->
    Data = <<
        CheckDay:8,
        Receive:8
    >>,
    Data.
item_to_bin_3 ({
    Style,
    TypeId,
    Count
}) ->
    Data = <<
        Style:32,
        TypeId:32,
        Count:32
    >>,
    Data.
item_to_bin_4 ({
    Style,
    TypeId,
    Count
}) ->
    Data = <<
        Style:32,
        TypeId:32,
        Count:32
    >>,
    Data.
item_to_bin_5 ({
    Style,
    TypeId,
    Count
}) ->
    Data = <<
        Style:32,
        TypeId:32,
        Count:32
    >>,
    Data.
item_to_bin_6 ({
    Id,
    State
}) ->
    Data = <<
        Id:32,
        State:8
    >>,
    Data.
item_to_bin_7 ({
    RewardId,
    Rewards,
    OtherRewards
}) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Bin_OtherRewards = pt:write_object_list(OtherRewards), 

    Data = <<
        RewardId:32,
        Bin_Rewards/binary,
        Bin_OtherRewards/binary
    >>,
    Data.
item_to_bin_8 ({
    TaskId,
    Process,
    Status
}) ->
    Data = <<
        TaskId:16,
        Process:16,
        Status:8
    >>,
    Data.
item_to_bin_9 ({
    TaskId,
    Process,
    Status
}) ->
    Data = <<
        TaskId:16,
        Process:16,
        Status:8
    >>,
    Data.
item_to_bin_10 (
    RewardId
) ->
    Data = <<
        RewardId:16
    >>,
    Data.
