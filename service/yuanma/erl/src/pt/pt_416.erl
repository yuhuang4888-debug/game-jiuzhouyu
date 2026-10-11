-module(pt_416).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41601, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(41602, Bin0) ->
    <<Rtype:8, Bin1/binary>> = Bin0, 
    <<Htype:8, _Bin2/binary>> = Bin1, 
    {ok, [Rtype, Htype]};
read(41604, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Times:8, Bin2/binary>> = Bin1, 
    <<AutoBuy:8, _Bin3/binary>> = Bin2, 
    {ok, [Type, Times, AutoBuy]};
read(41605, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<FromPos:16, Bin2/binary>> = Bin1, 
    <<ToPos:16, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, FromPos, ToPos]};
read(41606, _) ->
    {ok, []};
read(41607, Bin0) ->
    <<Stage:16, _Bin1/binary>> = Bin0, 
    {ok, [Stage]};
read(41608, Bin0) ->
    <<Htype:8, Bin1/binary>> = Bin0, 
    <<Rtype:8, _Bin2/binary>> = Bin1, 
    {ok, [Htype, Rtype]};
read(41609, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41610, Bin0) ->
    <<Htype:8, _Bin1/binary>> = Bin0, 
    {ok, [Htype]};
read(41612, Bin0) ->
    <<Htype:8, _Bin1/binary>> = Bin0, 
    {ok, [Htype]};
read(41613, Bin0) ->
    <<Htype:8, _Bin1/binary>> = Bin0, 
    {ok, [Htype]};
read(41614, Bin0) ->
    <<Htype:8, _Bin1/binary>> = Bin0, 
    {ok, [Htype]};
read(41620, Bin0) ->
    <<Htype:8, _Bin1/binary>> = Bin0, 
    {ok, [Htype]};
read(41622, Bin0) ->
    <<Htype:8, Bin1/binary>> = Bin0, 
    <<TaskId:32, _Bin2/binary>> = Bin1, 
    {ok, [Htype, TaskId]};
read(_Cmd, _R) -> {error, no_match}.

write (41600,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(41600, Data)};

write (41601,[
    DrawTiems,
    Turn,
    StageRewardList,
    StageReflushTime,
    RuneFreeTime
]) ->
    BinList_StageRewardList = [
        item_to_bin_0(StageRewardList_Item) || StageRewardList_Item <- StageRewardList
    ], 

    StageRewardList_Len = length(StageRewardList), 
    Bin_StageRewardList = list_to_binary(BinList_StageRewardList),

    Data = <<
        DrawTiems:32,
        Turn:16,
        StageRewardList_Len:16, Bin_StageRewardList/binary,
        StageReflushTime:64,
        RuneFreeTime:64
    >>,
    {ok, pt:pack(41601, Data)};

write (41602,[
    Rtype,
    List
]) ->
    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Rtype:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41602, Data)};

write (41603,[
    Rtype,
    RoleId,
    List
]) ->
    BinList_List = [
        item_to_bin_2(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Rtype:8,
        RoleId:64,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41603, Data)};

write (41604,[
    Res,
    Type,
    Times,
    ChipNum,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Res:32,
        Type:8,
        Times:32,
        ChipNum:64,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(41604, Data)};

write (41605,[
    Errcode,
    GoodsNum,
    GtypId
]) ->
    Data = <<
        Errcode:32,
        GoodsNum:32,
        GtypId:32
    >>,
    {ok, pt:pack(41605, Data)};

write (41606,[
    Errcode,
    GoodIds
]) ->
    BinList_GoodIds = [
        item_to_bin_4(GoodIds_Item) || GoodIds_Item <- GoodIds
    ], 

    GoodIds_Len = length(GoodIds), 
    Bin_GoodIds = list_to_binary(BinList_GoodIds),

    Data = <<
        Errcode:32,
        GoodIds_Len:16, Bin_GoodIds/binary
    >>,
    {ok, pt:pack(41606, Data)};

write (41607,[
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(41607, Data)};

write (41608,[
    Score,
    Htype,
    DrawWeapon,
    Rtype,
    Freetimes,
    FreeTime,
    List
]) ->
    BinList_List = [
        item_to_bin_5(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Score:32,
        Htype:8,
        DrawWeapon:8,
        Rtype:8,
        Freetimes:8,
        FreeTime:64,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41608, Data)};

write (41609,[
    Code,
    Score
]) ->
    Data = <<
        Code:32,
        Score:32
    >>,
    {ok, pt:pack(41609, Data)};

write (41610,[
    Htype,
    LuckeyValue,
    Percent
]) ->
    Data = <<
        Htype:8,
        LuckeyValue:32,
        Percent:16
    >>,
    {ok, pt:pack(41610, Data)};

write (41611,[
    Code
]) ->
    Data = <<
        Code:8
    >>,
    {ok, pt:pack(41611, Data)};

write (41612,[
    Htype,
    List
]) ->
    BinList_List = [
        item_to_bin_6(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Htype:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41612, Data)};

write (41613,[
    Htype,
    Open
]) ->
    Data = <<
        Htype:8,
        Open:8
    >>,
    {ok, pt:pack(41613, Data)};



write (41615,[
    Htype
]) ->
    Data = <<
        Htype:8
    >>,
    {ok, pt:pack(41615, Data)};

write (41620,[
    Code,
    Htype,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_7(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        Code:32,
        Htype:8,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(41620, Data)};

write (41621,[
    Htype,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_8(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        Htype:8,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(41621, Data)};

write (41622,[
    Code,
    Htype,
    TaskId,
    Num,
    State,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        Htype:8,
        TaskId:32,
        Num:32,
        State:8,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(41622, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Stage,
    Status
}) ->
    Data = <<
        Stage:16,
        Status:16
    >>,
    Data.
item_to_bin_1 ({
    RoleId,
    RoleName,
    Type,
    GtypId,
    GoodsNum,
    Time,
    IsRare
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Type:8,
        GtypId:32,
        GoodsNum:32,
        Time:32,
        IsRare:8
    >>,
    Data.
item_to_bin_2 ({
    RoleId,
    RoleName,
    Type,
    GtypId,
    GoodsNum,
    Time,
    IsRare
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Type:8,
        GtypId:32,
        GoodsNum:32,
        Time:32,
        IsRare:8
    >>,
    Data.
item_to_bin_3 ({
    GoodsId,
    GtypId,
    GoodsNum,
    IsRare,
    IsTv
}) ->
    Data = <<
        GoodsId:64,
        GtypId:32,
        GoodsNum:32,
        IsRare:8,
        IsTv:8
    >>,
    Data.
item_to_bin_4 ({
    GoodsNum,
    GtypId
}) ->
    Data = <<
        GoodsNum:32,
        GtypId:32
    >>,
    Data.
item_to_bin_5 ({
    RoleId,
    RoleName,
    Type,
    GtypId,
    GoodsNum,
    Time,
    IsRare
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Type:8,
        GtypId:32,
        GoodsNum:32,
        Time:32,
        IsRare:8
    >>,
    Data.
item_to_bin_6 ({
    ServerId,
    ServerNum,
    RoleId,
    RoleName,
    Type,
    GtypId,
    GoodsNum,
    Time,
    IsRare
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        ServerId:32,
        ServerNum:32,
        RoleId:64,
        Bin_RoleName/binary,
        Type:8,
        GtypId:32,
        GoodsNum:16,
        Time:32,
        IsRare:8
    >>,
    Data.
item_to_bin_7 ({
    TaskId,
    Num,
    State
}) ->
    Data = <<
        TaskId:32,
        Num:32,
        State:8
    >>,
    Data.
item_to_bin_8 ({
    TaskId,
    Num,
    State
}) ->
    Data = <<
        TaskId:32,
        Num:32,
        State:8
    >>,
    Data.
