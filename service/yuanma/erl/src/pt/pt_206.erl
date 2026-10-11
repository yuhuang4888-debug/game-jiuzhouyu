-module(pt_206).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(20601, _) ->
    {ok, []};
read(20602, Bin0) ->
    <<SceneId:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(20603, Bin0) ->
    <<SceneId:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(20604, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (20600,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(20600, Data)};

write (20601,[
    State,
    Etime,
    SerMod,
    GroupId,
    SerList,
    AvgWlv
]) ->
    BinList_SerList = [
        item_to_bin_0(SerList_Item) || SerList_Item <- SerList
    ], 

    SerList_Len = length(SerList), 
    Bin_SerList = list_to_binary(BinList_SerList),

    Data = <<
        State:8,
        Etime:32,
        SerMod:8,
        GroupId:32,
        SerList_Len:16, Bin_SerList/binary,
        AvgWlv:16
    >>,
    {ok, pt:pack(20601, Data)};

write (20602,[
    SceneList
]) ->
    BinList_SceneList = [
        item_to_bin_1(SceneList_Item) || SceneList_Item <- SceneList
    ], 

    SceneList_Len = length(SceneList), 
    Bin_SceneList = list_to_binary(BinList_SceneList),

    Data = <<
        SceneList_Len:16, Bin_SceneList/binary
    >>,
    {ok, pt:pack(20602, Data)};

write (20603,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(20603, Data)};

write (20604,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(20604, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SerId,
    SerNum,
    SerName,
    OpenDay,
    WorldLv
}) ->
    Bin_SerName = pt:write_string(SerName), 

    Data = <<
        SerId:16,
        SerNum:16,
        Bin_SerName/binary,
        OpenDay:16,
        WorldLv:16
    >>,
    Data.
item_to_bin_1 ({
    SceneId,
    Num,
    BossList
}) ->
    BinList_BossList = [
        item_to_bin_2(BossList_Item) || BossList_Item <- BossList
    ], 

    BossList_Len = length(BossList), 
    Bin_BossList = list_to_binary(BinList_BossList),

    Data = <<
        SceneId:32,
        Num:8,
        BossList_Len:16, Bin_BossList/binary
    >>,
    Data.
item_to_bin_2 (
    BossId
) ->
    Data = <<
        BossId:32
    >>,
    Data.
