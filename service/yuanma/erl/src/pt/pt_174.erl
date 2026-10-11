-module(pt_174).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17401, _) ->
    {ok, []};
read(17402, _) ->
    {ok, []};
read(17403, _) ->
    {ok, []};
read(17404, _) ->
    {ok, []};
read(17405, Bin0) ->
    <<Option:8, _Bin1/binary>> = Bin0, 
    {ok, [Option]};
read(17407, _) ->
    {ok, []};
read(17409, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (17400,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17400, Data)};

write (17401,[
    Stage,
    Time
]) ->
    Data = <<
        Stage:8,
        Time:32
    >>,
    {ok, pt:pack(17401, Data)};

write (17402,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17402, Data)};

write (17403,[
    Stage,
    CurNum,
    RemainNum,
    CorrectNum,
    QuizId,
    EndTime
]) ->
    Data = <<
        Stage:8,
        CurNum:16,
        RemainNum:16,
        CorrectNum:16,
        QuizId:32,
        EndTime:32
    >>,
    {ok, pt:pack(17403, Data)};

write (17404,[
    RankList,
    EndTime,
    SelRank,
    SelScore,
    SelExp
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ], 

    RankList_Len = length(RankList), 
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        RankList_Len:16, Bin_RankList/binary,
        EndTime:32,
        SelRank:16,
        SelScore:32,
        SelExp:32
    >>,
    {ok, pt:pack(17404, Data)};

write (17405,[
    Errcode
]) ->
    Data = <<
        Errcode:8
    >>,
    {ok, pt:pack(17405, Data)};

write (17406,[
    CurNum,
    Result
]) ->
    Data = <<
        CurNum:8,
        Result:8
    >>,
    {ok, pt:pack(17406, Data)};

write (17407,[
    ReadyTime
]) ->
    Data = <<
        ReadyTime:32
    >>,
    {ok, pt:pack(17407, Data)};

write (17408,[
    TotalExp,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        TotalExp:64,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(17408, Data)};

write (17409,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17409, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RoleId,
    Rank,
    Name,
    Score
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        RoleId:64,
        Rank:16,
        Bin_Name/binary,
        Score:32
    >>,
    Data.
item_to_bin_1 ({
    Type,
    TypeId,
    Num
}) ->
    Data = <<
        Type:8,
        TypeId:32,
        Num:32
    >>,
    Data.
