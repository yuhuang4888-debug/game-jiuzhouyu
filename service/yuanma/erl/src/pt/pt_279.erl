-module(pt_279).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(27900, _) ->
    {ok, []};
read(27901, _) ->
    {ok, []};
read(27902, Bin0) ->
    <<Scene:16, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(27903, _) ->
    {ok, []};
read(27904, Bin0) ->
    <<Scene:16, _Bin1/binary>> = Bin0, 
    {ok, [Scene]};
read(27905, Bin0) ->
    <<Scene:16, Bin1/binary>> = Bin0, 
    <<MonId:32, _Bin2/binary>> = Bin1, 
    {ok, [Scene, MonId]};
read(27906, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (27900,[
    OpenTime,
    EnterTime,
    EndTime
]) ->
    Data = <<
        OpenTime:32,
        EnterTime:32,
        EndTime:32
    >>,
    {ok, pt:pack(27900, Data)};

write (27901,[
    CanEnterScene,
    JoinList
]) ->
    BinList_JoinList = [
        item_to_bin_0(JoinList_Item) || JoinList_Item <- JoinList
    ], 

    JoinList_Len = length(JoinList), 
    Bin_JoinList = list_to_binary(BinList_JoinList),

    Data = <<
        CanEnterScene:8,
        JoinList_Len:16, Bin_JoinList/binary
    >>,
    {ok, pt:pack(27901, Data)};

write (27902,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(27902, Data)};

write (27903,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(27903, Data)};

write (27904,[
    Scene,
    Mon
]) ->
    BinList_Mon = [
        item_to_bin_1(Mon_Item) || Mon_Item <- Mon
    ], 

    Mon_Len = length(Mon), 
    Bin_Mon = list_to_binary(BinList_Mon),

    Data = <<
        Scene:16,
        Mon_Len:16, Bin_Mon/binary
    >>,
    {ok, pt:pack(27904, Data)};

write (27905,[
    Scene,
    MonId,
    HurtList
]) ->
    BinList_HurtList = [
        item_to_bin_2(HurtList_Item) || HurtList_Item <- HurtList
    ], 

    HurtList_Len = length(HurtList), 
    Bin_HurtList = list_to_binary(BinList_HurtList),

    Data = <<
        Scene:16,
        MonId:32,
        HurtList_Len:16, Bin_HurtList/binary
    >>,
    {ok, pt:pack(27905, Data)};

write (27906,[
    DieTimes,
    Time,
    DieTime,
    SafeTime
]) ->
    Data = <<
        DieTimes:16,
        Time:32,
        DieTime:32,
        SafeTime:32
    >>,
    {ok, pt:pack(27906, Data)};

write (27907,[
    MonId
]) ->
    Data = <<
        MonId:32
    >>,
    {ok, pt:pack(27907, Data)};

write (27908,[
    MonId,
    RebornTime,
    BlServer,
    BlServerNum,
    BlServerName
]) ->
    Bin_BlServerName = pt:write_string(BlServerName), 

    Data = <<
        MonId:32,
        RebornTime:32,
        BlServer:32,
        BlServerNum:32,
        Bin_BlServerName/binary
    >>,
    {ok, pt:pack(27908, Data)};

write (27909,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(27909, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Scene,
    SelfServerNum,
    SceneNum
}) ->
    Data = <<
        Scene:32,
        SelfServerNum:16,
        SceneNum:16
    >>,
    Data.
item_to_bin_1 ({
    MonId,
    MonLv,
    MonType,
    BlServer,
    BlServerName,
    BlServerNum,
    RebornTime
}) ->
    Bin_BlServerName = pt:write_string(BlServerName), 

    Data = <<
        MonId:32,
        MonLv:16,
        MonType:8,
        BlServer:32,
        Bin_BlServerName/binary,
        BlServerNum:32,
        RebornTime:32
    >>,
    Data.
item_to_bin_2 ({
    ServerId,
    ServerNum,
    ServerName,
    PlayerId,
    PlayerName,
    Damage
}) ->
    Bin_ServerName = pt:write_string(ServerName), 

    Bin_PlayerName = pt:write_string(PlayerName), 

    Data = <<
        ServerId:32,
        ServerNum:16,
        Bin_ServerName/binary,
        PlayerId:32,
        Bin_PlayerName/binary,
        Damage:16
    >>,
    Data.
