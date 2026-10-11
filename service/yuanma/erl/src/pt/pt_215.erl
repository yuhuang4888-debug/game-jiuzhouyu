-module(pt_215).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(21501, _) ->
    {ok, []};
read(21502, _) ->
    {ok, []};
read(21503, _) ->
    {ok, []};
read(21504, _) ->
    {ok, []};
read(21505, Bin0) ->
    <<SkillId:64, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(21507, Bin0) ->
    <<DunId:64, Bin1/binary>> = Bin0, 
    <<Times:8, Bin2/binary>> = Bin1, 
    <<BossNum:64, Bin3/binary>> = Bin2, 
    <<Auto:8, _Bin4/binary>> = Bin3, 
    {ok, [DunId, Times, BossNum, Auto]};
read(21508, _) ->
    {ok, []};
read(21509, _) ->
    {ok, []};
read(21510, Bin0) ->
    <<DunId:32, _Bin1/binary>> = Bin0, 
    {ok, [DunId]};
read(_Cmd, _R) -> {error, no_match}.

write (21500,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(21500, Data)};





write (21503,[
    Kill
]) ->
    Data = <<
        Kill:64
    >>,
    {ok, pt:pack(21503, Data)};

write (21504,[
    Power
]) ->
    Data = <<
        Power:64
    >>,
    {ok, pt:pack(21504, Data)};



write (21506,[
    State,
    KillNum,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        State:8,
        KillNum:64,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(21506, Data)};

write (21507,[
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(21507, Data)};

write (21508,[
    WaveNum,
    Time
]) ->
    Data = <<
        WaveNum:32,
        Time:64
    >>,
    {ok, pt:pack(21508, Data)};

write (21509,[
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_0(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(21509, Data)};

write (21510,[
    Code,
    DunId
]) ->
    Data = <<
        Code:32,
        DunId:32
    >>,
    {ok, pt:pack(21510, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    DunId,
    Status
}) ->
    Data = <<
        DunId:32,
        Status:8
    >>,
    Data.
