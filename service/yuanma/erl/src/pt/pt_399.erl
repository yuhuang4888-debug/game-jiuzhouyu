-module(pt_399).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(39901, Bin0) ->
    <<GameType:8, Bin1/binary>> = Bin0,
    <<ModuleId:16, Bin2/binary>> = Bin1,
    <<SubId:8, _Bin3/binary>> = Bin2,
    {ok, [GameType, ModuleId, SubId]};
read(39902, _) ->
    {ok, []};
read(39903, Bin0) ->
    <<GameType:8, Bin1/binary>> = Bin0,
    <<ModuleId:16, Bin2/binary>> = Bin1,
    <<SubId:8, Bin3/binary>> = Bin2,
    FunArray0 = fun(<<RestBin0/binary>>) ->
        <<Item:32, _Args1/binary>> = RestBin0,
        {Item,_Args1}
        end,
    {InfoList, _Bin4} = pt:read_array(FunArray0, Bin3),

    {ok, [GameType, ModuleId, SubId, InfoList]};
read(39904, Bin0) ->
    <<GameType:8, Bin1/binary>> = Bin0,
    <<ModuleId:16, Bin2/binary>> = Bin1,
    <<SubId:8, _Bin3/binary>> = Bin2,
    {ok, [GameType, ModuleId, SubId]};
read(39921, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0,
    FunArray0 = fun(<<RestBin0/binary>>) ->
        <<Item:32, _Args1/binary>> = RestBin0,
        {Item,_Args1}
        end,
    {InfoList, Bin2} = pt:read_array(FunArray0, Bin1),

    FunArray1 = fun(<<RestBin1/binary>>) ->
        <<RowId:8, _Args1/binary>> = RestBin1,

        FunArray2 = fun(<<RestBin2/binary>>) ->
        <<NoteId:8, _Args0/binary>> = RestBin2,
        {NoteId,_Args0}
        end,
        {RowNotes, _Args2} = pt:read_array(FunArray2, _Args1),
        {{RowId, RowNotes},_Args2}
        end,
    {Board, Bin3} = pt:read_array(FunArray1, Bin2),

    FunArray4 = fun(<<RestBin4/binary>>) ->
        <<X:8, _Args1/binary>> = RestBin4,
        <<Y:8, _Args2/binary>> = _Args1,
        <<EffType:8, _Args3/binary>> = _Args2,
        <<Param:8, _Args4/binary>> = _Args3,
        {{X, Y, EffType, Param},_Args4}
        end,
    {Effect, Bin4} = pt:read_array(FunArray4, Bin3),

    FunArray5 = fun(<<RestBin5/binary>>) ->
        <<NoteId:8, _Args1/binary>> = RestBin5,
        <<Rate:8, _Args2/binary>> = _Args1,
        {{NoteId, Rate},_Args2}
        end,
    {ScoreChess, _Bin5} = pt:read_array(FunArray5, Bin4),

    {ok, [Type, InfoList, Board, Effect, ScoreChess]};
read(39923, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (39900,[
    Errcode,
    Msg
]) ->
    Bin_Msg = pt:write_string(Msg),

    Data = <<
        Errcode:32,
        Bin_Msg/binary
    >>,
    {ok, pt:pack(39900, Data)};

write (39901,[
    Code,
    GameType,
    ModuleId,
    SubId,
    StartTime,
    EndTime,
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_0(InfoList_Item) || InfoList_Item <- InfoList
    ],

    InfoList_Len = length(InfoList),
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        Code:32,
        GameType:8,
        ModuleId:16,
        SubId:8,
        StartTime:32,
        EndTime:32,
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(39901, Data)};

write (39902,[
    GameType,
    ModuleId,
    SubId,
    StartTime,
    EndTime,
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_1(InfoList_Item) || InfoList_Item <- InfoList
    ],

    InfoList_Len = length(InfoList),
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        GameType:8,
        ModuleId:16,
        SubId:8,
        StartTime:32,
        EndTime:32,
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(39902, Data)};

write (39903,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(39903, Data)};

write (39904,[
    GameType,
    ModuleId,
    SubId,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_2(RankList_Item) || RankList_Item <- RankList
    ],

    RankList_Len = length(RankList),
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        GameType:8,
        ModuleId:16,
        SubId:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(39904, Data)};

write (39905,[
    GameType,
    ModuleId,
    SubId,
    InfoList
]) ->
    BinList_InfoList = [
        item_to_bin_3(InfoList_Item) || InfoList_Item <- InfoList
    ],

    InfoList_Len = length(InfoList),
    Bin_InfoList = list_to_binary(BinList_InfoList),

    Data = <<
        GameType:8,
        ModuleId:16,
        SubId:8,
        InfoList_Len:16, Bin_InfoList/binary
    >>,
    {ok, pt:pack(39905, Data)};



write (39922,[
    ModuleId,
    SubId,
    StartTime,
    EndTime,
    Score,
    Board,
    Effect,
    ScoreChess
]) ->
    BinList_Board = [
        item_to_bin_4(Board_Item) || Board_Item <- Board
    ],

    Board_Len = length(Board),
    Bin_Board = list_to_binary(BinList_Board),

    BinList_Effect = [
        item_to_bin_6(Effect_Item) || Effect_Item <- Effect
    ],

    Effect_Len = length(Effect),
    Bin_Effect = list_to_binary(BinList_Effect),

    BinList_ScoreChess = [
        item_to_bin_7(ScoreChess_Item) || ScoreChess_Item <- ScoreChess
    ],

    ScoreChess_Len = length(ScoreChess),
    Bin_ScoreChess = list_to_binary(BinList_ScoreChess),

    Data = <<
        ModuleId:16,
        SubId:8,
        StartTime:32,
        EndTime:32,
        Score:32,
        Board_Len:16, Bin_Board/binary,
        Effect_Len:16, Bin_Effect/binary,
        ScoreChess_Len:16, Bin_ScoreChess/binary
    >>,
    {ok, pt:pack(39922, Data)};



write (39931,[
    ModuleId,
    SubId,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_8(RankList_Item) || RankList_Item <- RankList
    ],

    RankList_Len = length(RankList),
    Bin_RankList = list_to_binary(BinList_RankList),

    Data = <<
        ModuleId:16,
        SubId:8,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(39931, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    Item
) ->
    Data = <<
        Item:32
    >>,
    Data.
item_to_bin_1 (
    Item
) ->
    Data = <<
        Item:32
    >>,
    Data.
item_to_bin_2 ({
    SerId,
    SerNum,
    Rank,
    RoleId,
    Name,
    Score
}) ->
    Bin_Name = pt:write_string(Name),

    Data = <<
        SerId:32,
        SerNum:32,
        Rank:16,
        RoleId:64,
        Bin_Name/binary,
        Score:32
    >>,
    Data.
item_to_bin_3 (
    Item
) ->
    Data = <<
        Item:32
    >>,
    Data.
item_to_bin_4 ({
    RowId,
    RowNotes
}) ->
    BinList_RowNotes = [
        item_to_bin_5(RowNotes_Item) || RowNotes_Item <- RowNotes
    ],

    RowNotes_Len = length(RowNotes),
    Bin_RowNotes = list_to_binary(BinList_RowNotes),

    Data = <<
        RowId:8,
        RowNotes_Len:16, Bin_RowNotes/binary
    >>,
    Data.
item_to_bin_5 (
    NoteId
) ->
    Data = <<
        NoteId:8
    >>,
    Data.
item_to_bin_6 ({
    X,
    Y,
    EffType,
    Param
}) ->
    Data = <<
        X:8,
        Y:8,
        EffType:8,
        Param:8
    >>,
    Data.
item_to_bin_7 ({
    NoteId,
    Rate
}) ->
    Data = <<
        NoteId:8,
        Rate:8
    >>,
    Data.
item_to_bin_8 ({
    Rank,
    RoleId,
    Name,
    Score,
    Perfects,
    ConPerfects
}) ->
    Bin_Name = pt:write_string(Name),

    Data = <<
        Rank:16,
        RoleId:64,
        Bin_Name/binary,
        Score:32,
        Perfects:16,
        ConPerfects:16
    >>,
    Data.
