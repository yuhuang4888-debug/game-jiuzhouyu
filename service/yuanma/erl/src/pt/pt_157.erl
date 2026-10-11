-module(pt_157).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15701, Bin0) ->
    <<ActType:8, _Bin1/binary>> = Bin0, 
    {ok, [ActType]};
read(15703, _) ->
    {ok, []};
read(15705, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(15709, _) ->
    {ok, []};
read(15710, _) ->
    {ok, []};
read(15711, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(15713, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15715, _) ->
    {ok, []};
read(15716, Bin0) ->
    <<ActId:32, Bin1/binary>> = Bin0, 
    <<ActSub:16, Bin2/binary>> = Bin1, 
    <<Times:16, _Bin3/binary>> = Bin2, 
    {ok, [ActId, ActSub, Times]};
read(15717, Bin0) ->
    <<ActId:32, Bin1/binary>> = Bin0, 
    <<ActSub:16, _Bin2/binary>> = Bin1, 
    {ok, [ActId, ActSub]};
read(15718, _) ->
    {ok, []};
read(15719, Bin0) ->
    <<Module:32, Bin1/binary>> = Bin0, 
    <<ModuleSub:32, Bin2/binary>> = Bin1, 
    <<AcSub:32, _Bin3/binary>> = Bin2, 
    {ok, [Module, ModuleSub, AcSub]};
read(15720, Bin0) ->
    <<Module:32, Bin1/binary>> = Bin0, 
    <<ModuleSub:32, Bin2/binary>> = Bin1, 
    <<AcSub:32, _Bin3/binary>> = Bin2, 
    {ok, [Module, ModuleSub, AcSub]};
read(15721, _) ->
    {ok, []};
read(15722, Bin0) ->
    <<Open:8, _Bin1/binary>> = Bin0, 
    {ok, [Open]};
read(_Cmd, _R) -> {error, no_match}.

write (15700,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15700, Data)};

write (15701,[
    ActType,
    Time,
    AcList
]) ->
    BinList_AcList = [
        item_to_bin_0(AcList_Item) || AcList_Item <- AcList
    ], 

    AcList_Len = length(AcList), 
    Bin_AcList = list_to_binary(BinList_AcList),

    Data = <<
        ActType:8,
        Time:64,
        AcList_Len:16, Bin_AcList/binary
    >>,
    {ok, pt:pack(15701, Data)};

write (15703,[
    Live,
    LiveMax,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Live:32,
        LiveMax:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(15703, Data)};

write (15705,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:32,
        Id:32
    >>,
    {ok, pt:pack(15705, Data)};

write (15706,[
    Module,
    ModuleSub,
    ActType,
    Status
]) ->
    Data = <<
        Module:32,
        ModuleSub:32,
        ActType:8,
        Status:8
    >>,
    {ok, pt:pack(15706, Data)};

write (15709,[
    Lv,
    Liveness,
    Id,
    Display
]) ->
    Data = <<
        Lv:32,
        Liveness:32,
        Id:32,
        Display:8
    >>,
    {ok, pt:pack(15709, Data)};

write (15710,[
    Errcode,
    Lv,
    Liveness
]) ->
    Data = <<
        Errcode:32,
        Lv:32,
        Liveness:32
    >>,
    {ok, pt:pack(15710, Data)};

write (15711,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:32,
        Id:32
    >>,
    {ok, pt:pack(15711, Data)};

write (15712,[
    RoleId,
    FigureId
]) ->
    Data = <<
        RoleId:64,
        FigureId:32
    >>,
    {ok, pt:pack(15712, Data)};

write (15713,[
    Errcode,
    Type
]) ->
    Data = <<
        Errcode:32,
        Type:8
    >>,
    {ok, pt:pack(15713, Data)};

write (15714,[
    Time
]) ->
    Data = <<
        Time:64
    >>,
    {ok, pt:pack(15714, Data)};

write (15715,[
    ResAct
]) ->
    BinList_ResAct = [
        item_to_bin_2(ResAct_Item) || ResAct_Item <- ResAct
    ], 

    ResAct_Len = length(ResAct), 
    Bin_ResAct = list_to_binary(BinList_ResAct),

    Data = <<
        ResAct_Len:16, Bin_ResAct/binary
    >>,
    {ok, pt:pack(15715, Data)};

write (15716,[
    ActId,
    ActSub,
    Lefttimes
]) ->
    Data = <<
        ActId:32,
        ActSub:16,
        Lefttimes:16
    >>,
    {ok, pt:pack(15716, Data)};

write (15717,[
    ActId,
    ActSub,
    AddLive
]) ->
    Data = <<
        ActId:32,
        ActSub:16,
        AddLive:32
    >>,
    {ok, pt:pack(15717, Data)};

write (15718,[
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_3(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(15718, Data)};

write (15719,[
    Code,
    Module,
    ModuleSub,
    AcSub,
    Status,
    Join
]) ->
    Data = <<
        Code:32,
        Module:32,
        ModuleSub:32,
        AcSub:32,
        Status:8,
        Join:8
    >>,
    {ok, pt:pack(15719, Data)};

write (15720,[
    Code,
    Module,
    ModuleSub,
    AcSub
]) ->
    Data = <<
        Code:32,
        Module:32,
        ModuleSub:32,
        AcSub:32
    >>,
    {ok, pt:pack(15720, Data)};

write (15721,[
    IsRemind,
    ActList
]) ->
    BinList_ActList = [
        item_to_bin_4(ActList_Item) || ActList_Item <- ActList
    ], 

    ActList_Len = length(ActList), 
    Bin_ActList = list_to_binary(BinList_ActList),

    Data = <<
        IsRemind:8,
        ActList_Len:16, Bin_ActList/binary
    >>,
    {ok, pt:pack(15721, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Module,
    ModuleSub,
    AcSub,
    Num,
    MaxNum,
    Live,
    MaxLive,
    CanGetLive,
    State
}) ->
    Data = <<
        Module:32,
        ModuleSub:32,
        AcSub:32,
        Num:32,
        MaxNum:32,
        Live:32,
        MaxLive:32,
        CanGetLive:32,
        State:8
    >>,
    Data.
item_to_bin_1 ({
    Id,
    State
}) ->
    Data = <<
        Id:32,
        State:8
    >>,
    Data.
item_to_bin_2 ({
    ActId,
    ActSub,
    Lefttimes,
    BackTimes
}) ->
    Data = <<
        ActId:32,
        ActSub:16,
        Lefttimes:16,
        BackTimes:16
    >>,
    Data.
item_to_bin_3 ({
    Module,
    ModuleSub,
    AcSub,
    Status,
    Join
}) ->
    Data = <<
        Module:32,
        ModuleSub:32,
        AcSub:32,
        Status:8,
        Join:8
    >>,
    Data.
item_to_bin_4 ({
    Module,
    ModuleSub,
    AcSub,
    State,
    Time,
    SignState
}) ->
    Data = <<
        Module:32,
        ModuleSub:32,
        AcSub:32,
        State:8,
        Time:32,
        SignState:8
    >>,
    Data.
